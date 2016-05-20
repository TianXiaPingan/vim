#!/usr/bin/env python

import os
import optparse

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd [optons] [backup|restore]]")
  parser.add_option("-d", action = "store_true", dest = "is_delete", 
                    help = "Whether to delete all extra files in the" 
                    "target directory.")
  (options, args) = parser.parse_args()

  tpt = "time rsync -ravutzh --progress -e ssh %s %s"
  server_dir = (r"summer@192.168.1.100:"
                "'/media/summer/WareHouse/in\ the\ laptop.inf/'")

  os.chdir("/Users/%s/inf" %os.getlogin())

  cmd = args[0]
  if cmd == "backup":
    cmd = tpt %(".", server_dir) 
  elif cmd == "restore":
    cmd = tpt %(server_dir, ".") 
  else:
    print "See help"
    exit(1)

  if options.is_delete:
    cmd += " --delete"
  print cmd, "\n"
  os.system(cmd)
