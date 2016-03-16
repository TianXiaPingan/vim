#!/usr/bin/env python
#coding: utf8

from algorithm import *

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] kw1 kw2 ...]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()

  if len(args) > 0:
    args = [kw.lower() for kw in args]
    cmd = ('''find . -iregex ".*%s.*" %s'''
           %(args[0], " ".join(["| grep -i %s" %kw for kw in args[1:]])))
    #print cmd
    os.system(cmd)


