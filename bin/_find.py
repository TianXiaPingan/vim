#!/usr/bin/env python2
#coding: utf8

from algorithm import *

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] kw1 kw2 ...]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("-d", "--dir", action = "store_true", dest = "search_dir",
                     default = False, help = "")
  parser.add_option("-g", "--global", action = "store_true", dest = "global_search",
                     default = False, help = "")
  (options, args) = parser.parse_args()

  if len(args) > 0:
    if options.global_search:
      os.chdir("/Users/%s/inf" %os.getlogin())

    args = [kw.lower() for kw in args]
    search_dir = "-type d" if options.search_dir else ""
    cmd = ('''find . %s -iregex ".*%s.*" %s'''
           %(search_dir, args[0], 
             " ".join(["| grep -i %s" %kw for kw in args[1:]])))
    #print cmd
    files = []
    for f in os.popen(cmd):
      if ".git" in f or "/." in f:
        continue
      files.append(f.strip())

    print "\n".join(files)



