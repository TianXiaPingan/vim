from algorithm import *
from multiprocessing import Pool
from _BatchRunClient import servers as featGenServers
from _BatchRunClient import ports as featGenPorts
from _scp import loadServerConfig

def startFeatGenServers(server):
  def isJavaAlive():
    javaNum = 0
    for ln in os.popen("_ssh.py %s 'ps -A | grep -i java'" %server):
      if ln.split()[-1] == "java":
        javaNum += 1
    return javaNum == 2

  # nohup java $JAVA_OPTS
  # -Denable.feature.extraction=true
  # -Dlauncher.port=9001 -cp $CLASSPATH $JAVA_OPTS_DOMAINIQ
  # Launcher > log.9091 2>&1 &
  cmds = [
    "killall java",
    "cd ~/DomainIQ",
    "rm -r logs",
    "rm log.9091 log.9092",
    "rm feats.*",
    "source bin/DomainIQ",
  ]
  cmd = "_ssh.py %s '%s'" %(server, ";".join(cmds))

  for tryFreq in xrange(10):
    os.system(cmd)
    # print cmd
    if isJavaAlive():
      print "Starting %s: OK" %server
      return True

  print "Starting %s: fail" %server
  return False

def collectFeat(server):
  featFile = "feat.%s.tgz" %server
  rankServer = loadServerConfig()["rankServer"]
  cmds = [
    "killall java",
    "cd ~/DomainIQ",
    "rm -r logs",
    "rm log.9091 log.9092",
    "tar -cvzf %s feats.*.txt" %featFile,
    "scp -oStrictHostKeyChecking=no %s %s:~/" %(featFile, rankServer)
  ]
  cmd = "_ssh.py %s '%s'" %(server, ";".join(cmds))
  print cmd
  os.system(cmd)

if __name__ == "__main__":
  parser = OptionParser(usage = "cmd [optons] file1 file2 ...")
  parser.add_option("-o", dest = "outFile", default = "rank.txt",
                    help = "default 'rank.txt'")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--debug", action = "store_true", dest = "debug",
                     default = False, help = "")
  (options, args) = parser.parse_args()

  print featGenServers, featGenPorts

  for server in featGenServers:
    startFeatGenServers(server)

  cmd = "_BatchRunClient.py %s" %" ".join(args)
  print cmd
  os.system(cmd)

  Pool().map(collectFeat, featGenServers)


