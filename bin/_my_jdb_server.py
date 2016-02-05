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

class VimJavaDebugger(object):
  def __init__(self, server_name, main_class):
    self._debugger_type = "jdb"
    self._server_name   = server_name 
    self._quit          = False
    self._lock          = thread.allocate_lock()
    self._main_class    = main_class 

  def system(self, cmd):
    if debug:
      print "cmd: %s" %cmd
    os.system(cmd)

  def _get_file_position(self, jdb_pipe):
    jdb_pipe.tochild.write("where\n")
    while True:
      line = jdb_pipe.fromchild.readline()
      if debug:
        print "_get_file_position:", line
      filename = re.findall("\[1\] .*? \((.*?):(\d+)\)", line)
      if filename != []:
        return filename[0]

  def _parse_jdb_status(self, jdb_pipe, line):
    '''Parsing commands from jdb and send to Vim'''
    if ("Breakpoint hit" in line or 
        "Step completed" in line):
        
      filename, lineID = self._get_file_position(jdb_pipe)
      if debug:
        print "Line Step Detected: (%s:%s)" %(filename, lineID)
      self._send_to_vim("VDBHighlightLine(%s, '%s')" %(lineID, filename))
      return

    if debug:
      print "Ignoring '%s'" %line

  def _monitor_vim(self, jdb_pipe):
    '''Monitoring commands from Vim from .{_server_name}, and writing to jdb'''
    while True:
      cmdPipe = os.popen("cat .%s" % self._server_name)
      for line in cmdPipe:
        if debug:
          print "_monitor_vim:", line
        if "stop at" in line:
          line = line.replace("/", ".")
        jdb_pipe.tochild.write(line)
      cmdPipe.close()

      with self._lock:
        if self._quit:
          break

  def _monitor_jdb(self, jdb_pipe):
    '''Filtering status from jdb and send to Vim.'''
    line = ""
    while True:
      char = jdb_pipe.fromchild.read(1)
      sys.stdout.write(char)
      sys.stdout.flush()

      if char == '\n':
        if debug:
          print "_monitor_jdb:", line
        self._parse_jdb_status(jdb_pipe, line)
        line = ""
      else:
        line += char

      with self._lock:
        if self._quit: 
          break

  def _monitor_cmd_input(self, jdb_pipe):
    while True:
      char = sys.stdin.read(1)
      if debug:
        print "_monitor_cmd_input:", char
      jdb_pipe.tochild.write(char)
      with self._lock:
        if self._quit:
          jdb_pipe.tochild.write("quit\n")
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
      # Monitoring jdb.
      jdb = "java -classpath /opt/local/share/java/jline.jar:"\
            "/Library/Java/JavaVirtualMachines/jdk1.8.0_71.jdk"\
            "/Contents/Home/lib/tools.jar "\
            "jline.ConsoleRunner com.sun.tools.example.debug.tty.TTY %s '%s'" \
            %(self._main_class, params)
      jdb_pipe = popen2.Popen3(jdb, capturestderr = False, bufsize = 0)

      thread.start_new_thread(self._monitor_jdb, (jdb_pipe,))
      thread.start_new_thread(self._monitor_cmd_input, (jdb_pipe,))
      thread.start_new_thread(self._monitor_vim, (jdb_pipe,))

      try:
        while True:
          if jdb_pipe.poll() != -1:
            self._quit = True
            break
          time.sleep(1)
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
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--debug", action = "store_true", dest = "debug",
                     default = False, help = "debug mode")
  parser.add_option("--servername", dest = "server_name",
                     default = "debug", help = "default 'debug'")
  parser.add_option("--mainclass", dest = "main_class",
                     default = "Main", help = "default 'Main'")
  (options, args) = parser.parse_args()

  debug = options.debug
  VimJavaDebugger(options.server_name, options.main_class).run(" ".join(args))
