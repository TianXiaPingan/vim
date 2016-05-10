#!/usr/bin/env python
#coding: utf8

from algorithm import *

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--server_dir", dest = "server_dir", 
    default = "summer@192.168.1.55:/media/summer/WareHouse",
    help = ("account@IP:dir, no blanks permitted in dir, "
            "default summer@192.168.1.118:/media/summer/WareHouse"))
  parser.add_option("--local_name", dest = "local_name", 
    default = "WareHouse",
    help = "/Volumes/local_name, default 'WareHouse'")
  (options, args) = parser.parse_args()

  os.system("mkdir /Volumes/%s" %options.local_name)
  os.system("sshfs %s /Volumes/%s -ovolname=%s" %(options.server_dir,
                                                  options.local_name,
                                                  options.local_name))

