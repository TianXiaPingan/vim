#!/usr/bin/env python2

from algorithm import *

if __name__ == "__main__":
  parser = OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose", \
      #default = False, help = "don't print status messages to stdout")
  parser.add_option("-t", "--time", dest = "timeLength", type = "int", 
                    default = 10, help = "10s by default")
  (options, args) = parser.parse_args()

  assert options.timeLength > 0

  os.chdir(os.path.expanduser("~/Library/Preferences"))
  executeCmd("defaults write org.niltsh.MPlayerX SeekStepTimeL -float -%d"
             %options.timeLength)
  executeCmd("defaults write org.niltsh.MPlayerX SeekStepTimeR -float %d"
             %options.timeLength)

