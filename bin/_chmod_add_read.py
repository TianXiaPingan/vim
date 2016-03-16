#!/usr/bin/env python
#coding: utf8

from algorithm import *

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()

  cwd = os.getcwd()

  cmd = "find . -type d -exec chmod -v a+x {} \;"
  os.system(cmd)

  cmd = "chmod -Rv a+r ."
  os.system(cmd)

