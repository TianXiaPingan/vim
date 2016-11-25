#!/usr/bin/env python

import os
import optparse

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd [optons] [backup|restore]]")
  parser.add_option("-d", action = "store_true", dest = "is_delete", 
                    help = "Whether to delete all extra files in the" 
                    "target directory.")
  parser.add_option("--server", dest = "server", default = "192.168.1.104",
                    help = "default 192.168.1.104") 
  (options, args) = parser.parse_args()

  tpt = "time rsync -ravutzh --progress -e ssh %s %s"
  serverDir = ("summer@%s:/media/summer/WareHouse/in-the-laptop.inf/" 
               %options.server)

  os.chdir("/Users/%s/inf" %os.getlogin())

  cmd = args[0]
  if cmd == "backup":
    cmd = tpt %(".", serverDir) 
  elif cmd == "restore":
    cmd = tpt %(serverDir, ".") 
  else:
    print "See help"
    exit(1)

  if options.is_delete:
    cmd += " --delete"
  print cmd, "\n"
  os.system(cmd)
