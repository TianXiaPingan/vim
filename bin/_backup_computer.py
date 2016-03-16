#!/usr/bin/env python

import os
import optparse

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  parser.add_option("-d", action = "store_true", dest = "is_delete", 
                    help = "Whether to delete all extra files in the" 
                    "target directory.")
  (options, args) = parser.parse_args()

  os.chdir("/Users/world/inf")
  cmd = ("time rsync -ravutzh --progress -e ssh "
         ". summer@192.168.1.116:"
         '''"/media/summer/3T-backup/in\ the\ laptop.inf"''')
  if options.is_delete:
    cmd += " --delete"
  print cmd
  os.system(cmd)
