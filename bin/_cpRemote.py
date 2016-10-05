#!/usr/bin/env python
#coding: utf8

from algorithm import *

servers = {
  "dev1"  : "txia@g1dlfinddev01.dev.glbt1.gdg",
  "dev2"  : "txia@g1dlfinddev02.dev.glbt1.gdg",
  "dev3"  : "txia@g1dlfinddev03.dev.glbt1.gdg",
  "dev4"  : "txia@g1dlfinddev04.dev.glbt1.gdg",
  "hadoop": "txia@p3plpashl01.prod.phx3.gdg"
}

def replaceServer(addr):
  if "@" not in addr:
    return addr
  server = addr[: addr.index("@")]
  return addr.replace(server + "@", servers[server] + ":")

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd dev1@dir1 dir2")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()

  assert len(args) == 2
  
  srcDir, tgtDir = replaceServer(args[0]), replaceServer(args[1])

  dirOpt = "-r" if srcDir.endswith("/") else ""
  cmd = "scp %s %s %s" %(dirOpt, srcDir, tgtDir)
  #print cmd
  os.system(cmd)

