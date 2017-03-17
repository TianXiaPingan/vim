#!/usr/bin/env python
#coding: utf8

from algorithm import *

debug = False

def loadServerConfig():
  path = "/Users/txia/inf/study/linux-settings/common-settings/vim/bin"
  ret = {}

  for ln in open(path + "/servers.config"):
    ln = ln.strip()
    if ln == "":
      continue
    d = extractAttribute(ln)
    if len(d) == 0:
      continue
    ret[d["name"]] = "%s@%s" %(d["account"], d["ip"])
    if debug:
      print d

  return ret 

def replaceServer(addr):
  global servers
  if "@" not in addr:
    return addr
  
  servers = loadServerConfig()
  server = addr[: addr.index("@")]
  if server in servers:
    return addr.replace(server + "@", servers[server] + ":")
  return addr

def showServers():
  servers = loadServerConfig()
  for name in sorted(servers.keys()):
    print name, servers[name]

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd dev1@dir1 dir2")
  parser.add_option("-d", action = "store_true", dest = "debug")
  parser.add_option("--show", action = "store_true", dest = "showServer",
                    help = "show all servers")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()

  debug = options.debug
  if options.showServer:
    showServers()
    exit(0)

  assert len(args) == 2
  
  srcDir, tgtDir = replaceServer(args[0]), replaceServer(args[1])

  dirOpt = "-r" if srcDir.endswith("/") else ""
  cmd = "scp %s %s %s" %(dirOpt, srcDir, tgtDir)
  if debug:
    print cmd
  os.system(cmd)

