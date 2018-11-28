#!/usr/bin/env python
#coding: utf8

from algorithm import *

debug = False

class ServerManager:
  _inst = None

  def __init__(self):
    self._servers = {}
    for ln in open("%s/.vim/include/servers.config" %os.getenv("HOME")):
      ln = ln.strip()
      if ln == "":
        continue
      server = extractAttribute(ln)
      if len(server) == 0:
        continue
      self._servers[server["name"]] = server

  def getIP(self, serverName):
    if serverName == "localhost":
      return serverName
    return self._servers.get(serverName, {"ip": None})["ip"]

  def getLogin(self, serverName):   
    if serverName not in self._servers:
      return None

    server = self._servers[serverName]
    return "%s@%s" %(server["account"], server["ip"])

  def getServerNames(self):
    return self._servers.keys()

  def showAllServers(self):
    for p, name in enumerate(sorted(self._servers.keys())):
      print p, self._servers[name]

  @staticmethod
  def getInstance():
    if ServerManager._inst is None:
      ServerManager._inst = ServerManager()

    return ServerManager._inst    

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd dev1@dir1 dir2")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()

  serverManager = ServerManager.getInstance()
  serverManager.showAllServers()
