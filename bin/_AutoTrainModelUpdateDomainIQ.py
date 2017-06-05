#!/usr/bin/env python
#coding: utf8

from algorithm import *

SourceZip = "DomainIQ-0.1.0-SNAPSHOT.zip"
targetServers = [
  "cloud1",
  "cloud2",
  "cloud3",
  "cloud4",
  "cloud5",
  "cloud6",
  "cloud7",
  "cloud8",
  "cloud9",
  "cloud10",
  "cloud11",
  "cloud12",
  "cloud13",
  "cloud14",
  "cloud15",
  "cloud16",
  "cloud17",
  "cloud18",
]

def updateServer(server):
  '''make sure no Java is running'''
  executeCmd("_ssh.py %s 'rm -rf %s DomainIQ'" %(server, SourceZip))
  executeCmd("_scp.py %s %s@~/" %(SourceZip, server))
  executeCmd("_ssh.py %s 'unzip %s'" %(server, SourceZip))
  executeCmd("_ssh.py %s 'rm ~/DomainIQ/bin/DomainIQ'" %(server))
  executeCmd("_scp.py dist/bin/DomainIQ2 %s@~/DomainIQ/bin/DomainIQ" %(server))

  curCwd = os.getcwd()
  os.chdir("/var/data")
  executeCmd("_supdate.py -d %s@/var/data/" %server)
  os.chdir(curCwd)

def updateRunScript(fname):
  cmdTpt = ("nohup java $JAVA_OPTS -Denable.feature.extraction=true "
            "-Dlauncher.port=%s -cp $CLASSPATH $JAVA_OPTS_DOMAINIQ "
            "Launcher > log.%s 2>&1 &")

  lines = [ln.strip() for ln in open(fname) if not ln.startswith("java")]
  lines.append(cmdTpt %("9001", "9001"))
  lines.append(cmdTpt %("9002", "9002"))
  print >> open(fname + "2", "w"), "\n".join(lines)

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()

  assert os.path.isfile("dist/bin/DomainIQ")
  assert os.path.isfile(SourceZip)

  updateRunScript("dist/bin/DomainIQ")

  for server in targetServers:
    print "-" * 32, server, "-" * 32
    updateServer(server)
