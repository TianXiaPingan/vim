#!/usr/bin/env python

from algorithm import *

def isTargetDirValid(path, folder):
  msg = os.popen("_ssh.py wd 'cd %s; ls'" %path).read()
  #print msg
  return folder in msg

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd [optons]")
  parser.add_option("-d", action = "store_true", dest = "delete",
                    help = "Whether to delete all extra files in the"
                    "target directory.")
  (options, args) = parser.parse_args()

  os.chdir("/Users/%s/inf" %os.getlogin())
  path, folder = "/media/summer/WareHouse", "in-the-laptop.inf"
  assert isTargetDirValid(path, folder), path + "/" + folder

  cmd = "_supdate.py wd@%s/%s" %(path, folder)
  if options.delete:
    cmd += " -d"
  executeCmd(cmd)
