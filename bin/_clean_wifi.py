#!/usr/bin/env python
#coding: utf8

from algorithm_3x import *

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd server 'cmd'")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()

  os.chdir("/Library/Preferences/SystemConfiguration")
  executeCmd("sudo rm -v com.apple.airport.preferences.plist")
  executeCmd("sudo rm -v NetworkInterfaces.plist")
  executeCmd("sudo rm -v preferences.plist") 
