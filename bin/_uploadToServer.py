#!/usr/bin/env python
#coding: utf8

from algorithm import *

servers = {
  "dev1"  : "txia@g1dlfinddev01.dev.glbt1.gdg",
  "hadoop": "txia@p3plpashl01.prod.phx3.gdg"
}

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] file1 file2 ...]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--server", dest = "server", default = "dev1", 
                    help = "dev1 | hadoop. dev1 by default.")
  parser.add_option("--dir", dest = "dir", default = "~/", 
                    help = "~/")
  (options, args) = parser.parse_args()

  for fname in args:
    dirOpt = "-r" if os.path.isdir(fname) else ""
    cmd = "scp %s %s %s:%s" %(dirOpt, fname,
                              servers[options.server], 
                              options.dir)
    print cmd
    os.system(cmd)

