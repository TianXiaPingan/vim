#!/usr/bin/env python

import commands
import optparse   
import os
import popen2
import re
import string
import sys
import thread
import time

debug = None

class VimCppDebugger(object):
  def __init__(self, server_name, main_class):
    self._debugger_type = "gdb"
    self._server_name   = server_name 
    self._quit          = False
    self._lock          = thread.allocate_lock()
    self._main_class    = main_class 
    self._bp2file       = dict()    # breakpoint ID(int) --> fulllfile
    self._file2bp       = dict()    # fullfile --> breakpoint ID
    self._fullfile      = dict()    # shortfile --> fullfile

  def system(self, cmd):
    self.log("cmd: %s" %cmd)
    os.system(cmd)

  def log(self, *msgs):
    if debug:
      print "\nlog:", 
      for msg in msgs:
        print msg, 
      print   

  def _store_fullfile(self, fullfile):
    path, fn = os.path.split(fullfile) 
    self.log("_store_fullfile: ('%s', '%s')" %(fn, fullfile))
    self._fullfile[fn] = fullfile

  def _get_fullfile(self, shortfile):
    fullfile = self._fullfile.get(shortfile)

  def _monitor_vim(self, gdb_pipe):
    '''Monitoring commands from Vim from .{_server_name}, and writing to gdb'''
    reg = re.compile('''(break|clear)\s* (.*?):(\d+)''')

    while True:
      cmdPipe = os.popen("cat .%s" % self._server_name)
      for line in cmdPipe:
        self.log("_monitor_vim: '%s'" %line)

        match = reg.findall(line)
        if match != []:
          kw, fullfile, lineID = match[0]
          self._store_fullfile(fullfile)
          line = '''%s "%s":%s\n''' %(kw, fullfile, lineID)
          self.log("_monitor_vim: new line: '%s'" %line)

        gdb_pipe.tochild.write(line)
      cmdPipe.close()

      with self._lock:
        if self._quit:
          break

  def _monitor_gdb(self, gdb_pipe):
    '''Filtering status from gdb and send to Vim.'''
    while True:
      line = gdb_pipe.fromchild.readline()
      print line
      sys.stdout.flush()
      self.log("_monitor_gdb: '%s'" %line)

      m1 = re.search('''Breakpoint (\d+) at .*?: file (.*?), line (\d+)''', line)
      m2 = re.search('''(#0|Breakpoint \d+,).*? at ([a-zA-Z_\.\d]+):(\d+)''', line)
      m3 = re.search('''Deleted breakpoint (\d+)''', line)

      if m1 is not None:
        shortfile, lineID = m1.group(2), m1.group(3)
        fullfile = self._fullfile.get(shortfile, "<no-found>")
        self._file2bp[fullfile + ":" + lineID] = int(m1.group(1))
        self._bp2file[int(m1.group(1))] = fullfile + ":" + lineID

        self.log("Breakpoint Set Detected:", m1.groups())
        self._send_to_vim("VDBBreakSet(%s, '%s', %s)" %(lineID, fullfile, lineID))
      elif m2 is not None:
        shortfile, lineID = m2.group(2), m2.group(3)
        self.log("Line Step Detected:", m2.groups())

        # We require "step" is followed by "where" and "info source".
        if shortfile not in self._fullfile:
          while "Located in" not in line:
            line = gdb_pipe.fromchild.readline()
          fullfile = line[len("Located in"):].strip()
          self._store_fullfile(fullfile)
          self.log("fullname found:", fullfile)
        else:
          fullfile = self._fullfile.get(shortfile, "<no-found>")

        self._send_to_vim("VDBHighlightLine(%s, '%s')" %(lineID, fullfile))
      elif m3 is not None:
        bp = int(m3.group(1))
        fullfile, lineID = self._bp2file[bp].split(":") 
        self.log("Breakpoint Clear Detected:", m3.groups())
        self._send_to_vim("VDBBreakClear(%s, '%s')" %(lineID, fullfile))
      else:
        self.log("Ignoring '%s'" %line)

      with self._lock:
        if self._quit: 
          break

  def _monitor_cmd_input(self, gdb_pipe):
    while True:
      char = sys.stdin.read(1)
      gdb_pipe.tochild.write(char)
      with self._lock:
        if self._quit:
          gdb_pipe.tochild.write("quit\n")
          break

  def _send_to_vim(self, cmd, silent = True):
    '''In cmd, only ' is permitted, instead of ".'''
    silent = "silent" if silent else ""
    self.system('''vim --servername %s -u NONE -U NONE '''\
                '''--remote-send "<C-\\><C-N>:%s call %s<CR><CR>"'''
                %(self._server_name, silent, cmd));

  def run(self, params):
    try:
      # Monitoring commands from Vim.
      os.mkfifo(".%s" % self._server_name, 0600)
      self._send_to_vim('''VDBInit('.%s', '%s', '%s')''' 
                        %(self._server_name, os.path.realpath(os.curdir), 
                          self._debugger_type))
      # Monitoring gdb.
      gdb = "sudo gdb %s %s" %(self._main_class, params)
      gdb_pipe = popen2.Popen3(gdb, capturestderr = False, bufsize = 0)

      thread.start_new_thread(self._monitor_gdb, (gdb_pipe,))
      thread.start_new_thread(self._monitor_cmd_input, (gdb_pipe,))
      thread.start_new_thread(self._monitor_vim, (gdb_pipe,))

      try:
        while True:
          if gdb_pipe.poll() != -1:
            self._quit = True
            break
          time.sleep(0.1)
      except KeyboardInterrupt, ex:
        with self._lock:
          self._quit = True

      time.sleep(0.3)
      self._send_to_vim("VDBClose()")

    finally:
      self.system("rm -f .%s" % self._server_name)

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] parameters")
  parser.add_option("--debug", action = "store_true", dest = "debug",
                     default = False, help = "debug mode")
  parser.add_option("--servername", dest = "server_name",
                     default = "debug", help = "default 'debug'")
  parser.add_option("--mainclass", dest = "main_class",
                     default = "test", help = "default 'test'")
  (options, args) = parser.parse_args()

  debug = options.debug
  VimCppDebugger(options.server_name, options.main_class).run(" ".join(args))
