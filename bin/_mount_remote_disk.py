#!/usr/bin/env python
#coding: utf8

from algorithm import *

#alias _mount_3T_backup="mkdir /Volumes/3T-backup; sshfs summer@192.168.1.116:/media/summer/3T-backup  /Volumes/3T-backup -ovolname=3T-backup"

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--server_dir", dest = "server_dir", 
                    help = "account@IP:dir, not blanks permitted in dir")
  parser.add_option("--local_name", dest = "local_name", 
                    help = "/Volumes/local_name")
  (options, args) = parser.parse_args()


  os.system("mkdir /Volumes/%s" %options.local_name)
  os.system("sshfs %s /Volumes/%s -ovolname=%s" %(options.server_dir,
                                                  options.local_name,
                                                  options.local_name))

