#!/usr/bin/env python
#coding: utf8

from algorithm import *
from _scp import *

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd srcDir targetDir")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--exclude", dest="excludePattern", default=None)
  parser.add_option("-d", action = "store_true", dest = "delete",
                    default = False)
  (options, args) = parser.parse_args()
  assert len(args) == 2 and ("." == args[0] or "." == args[1])
  
  deleteOpt = "--delete" if options.delete else ""
  if options.excludePattern is not None:
    excludeOpt = "--exclude=%s" %options.excludePattern
  else:   
    excludeOpt = "" 
 
  srcDir = replaceServer(args[0]) + "/"
  tgtDir = replaceServer(args[1]) + "/"
  
  cmd = "rsync -ravutzh --progress -e ssh %s %s   %s %s" \
      %(srcDir, tgtDir, excludeOpt, deleteOpt)
  print cmd
  executeCmd(cmd)
