#!/usr/bin/env python
#coding: utf8

from algorithm import *
from _scp import *

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd targetDir")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--show", action = "store_true", dest = "showServer",
                    help = "show all servers")
  (options, args) = parser.parse_args()

  if options.showServer:
    showServers()
    exit(0)

  assert len(args) == 1
  loginServer = args[0] 
  if "@" not in loginServer:
    servers = loadServerConfig()
    loginServer = servers.get(loginServer, loginServer)
  
  cmd = "ssh %s" %loginServer 
  print cmd
  os.system(cmd)

