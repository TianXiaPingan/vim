#!/usr/bin/env python
#coding: utf8

from algorithm import *
from _scp import *

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd targetDir")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--reverse", action = "store_true", dest = "reverse",
                    default = False)
  parser.add_option("-d", action = "store_true", dest = "delete",
                    default = False)
  (options, args) = parser.parse_args()
  assert len(args) == 1
  
  opt = "--delete" if options.delete else ""
  if options.reverse:
    srcDir = replaceServer(args[0]) + "/"
    cmd = "rsync -ravutzh --progress -e ssh %s . %s" %(srcDir, opt)
  else:  
    tgtDir = replaceServer(args[0])
    cmd = "rsync -ravutzh --progress -e ssh . %s %s" %(tgtDir, opt)

  executeCmd(cmd)
