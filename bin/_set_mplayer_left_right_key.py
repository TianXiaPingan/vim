#!/usr/bin/env python

from algorithm import *

if __name__ == "__main__":
  parser = OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose", \
      #default = False, help = "don't print status messages to stdout")
  parser.add_option("-t", "--time", dest = "time_length", type = "int", \
      default = 10, help = "10s by default")
  (options, args) = parser.parse_args()

  assert options.time_length > 0

  try:
    chdir("/Users/world/Library/Preferences")
    cmd = '''defaults write org.niltsh.MPlayerX SeekStepTimeL -%d; \
        defaults write org.niltsh.MPlayerX SeekStepTimeR %d'''
    system(cmd %(options.time_length, options.time_length)) 
  except:
    print "Fails"

