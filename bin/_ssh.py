#!/usr/bin/env python2
#coding: utf8

from algorithm import *
from _scp import *

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd server 'cmd'")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()

  if len(args) == 0:
    showServers()
    exit(0)

  loginServer = args[0] 
  if "@" not in loginServer:
    servers = loadServerConfig()
    loginServer = servers.get(loginServer, loginServer)
  
  cmd = "ssh -oStrictHostKeyChecking=no %s '%s'" %(loginServer, "" if len(args) == 1 else args[1])
  print cmd
  os.system(cmd)

