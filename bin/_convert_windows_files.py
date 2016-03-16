#!/usr/bin/env python

from algorithm import *

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose", \
      #default = False, help = "don't print status messages to stdout")
  (options, args) = parser.parse_args()

  for fn in args:
    try:
      txt = open(fn).read()
      txt = filter(lambda ch: ord(ch) != 13, txt)
      print >> open(fn + ".converted", "w"), txt
      print fn, "is OK"
    except:
      break

