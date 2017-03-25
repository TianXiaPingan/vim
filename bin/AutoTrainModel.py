from algorithm import *
from threading import Thread
from _BatchRunClient import ports as featGenPorts
from _BatchRunClient import servers as featGenServers
from _scp import loadServerConfig

class PipeLine:
  pipelineStages = [
    "featExtraction", "featCollection", "modelTrain", "modelTest"
  ]

  def __init__(self, stageStartFrom, dataFiles):
    self._stageStartFrom = stageStartFrom
    self._dataFiles = dataFiles

  def run(self):
    stageIndex = self.pipelineStages.index(self._stageStartFrom)
    if stageIndex <= 0:
      self._stage0()
    if stageIndex <= 1:
      self._stage1()

  def _stage0(self):
    for server in featGenServers:
      self._startFeatGenServers(server)

    cmd = "_BatchRunClient.py %s" %" ".join(self._dataFiles)
    print cmd
    os.system(cmd)

  def _stage1(self):
    threads = [Thread(target = PipeLine._collectFeat, args = (server,))
               for server in featGenServers]
    for thread in threads:
      thread.start()
    for thread in threads:
      thread.join()

  def _isJavaAlive(self, server):
    javaNum = 0
    for ln in os.popen("_ssh.py %s 'ps -A | grep -i java'" %server):
      if ln.split()[-1] == "java":
        javaNum += 1
    return javaNum == 2

  def _startFeatGenServers(self, server):
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
      if self._isJavaAlive(server):
        print "Starting %s: OK" %server
        return True

    print "Starting %s: fail" %server
    return False

  @staticmethod
  def _collectFeat(server):
    print "server: ", server
    featFile = "feat.%s.tgz" %server
    rankServer = loadServerConfig()["rankServerGoogle"]
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
  parser.add_option("--startFromStage", dest = "startFromStage",
                    default = "featExtraction",
                    help = ", ".join(PipeLine.pipelineStages))
  (options, args) = parser.parse_args()

  print featGenServers, featGenPorts
  PipeLine(options.startFromStage, args).run()



