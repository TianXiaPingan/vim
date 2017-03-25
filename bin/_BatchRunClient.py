#!/usr/bin/env python2.7
#coding: utf8

from _RunClient import Client
from algorithm import *
from multiprocessing import Queue
from threading import Thread

servers = ["cloud1", "cloud2", "cloud3", "cloud4", "cloud5", "cloud6"]
ports   = [9001, 9002]

class FeatExtraction(Thread):
  def __init__(self, server, port, queryQueue, resultQueue):
    super(FeatExtraction, self).__init__()
    self._server = server
    self._port = port
    self._queryQueue = queryQueue
    self._resultQueue = resultQueue

  def _portAvailable(self):
    client = Client(self._server, self._port, 100)
    valueDict = {
      "key"       : "test-key",
      "query"     : "zeospizza.com",
      "country"   : "www",
      "geo"       : "geo",
      "user"      : "new",
      "longitude" : None,
      "latitude"  : None,
      "city"      : None,
      "date"      : None,
      "addToCart" : None,
      "purchase"  : None
    }

    for tryFreq in xrange(10):
      try:
        _, _, _, results = client.fetchSerp(valueDict)
        return True
      except Exception as error:
        time.sleep(10)

    return False

  def run(self):
    client = Client(self._server, self._port, 100)
    fnLog = open("log.%s" %self._port, "w")
    while True:
      try:
        valueDict = queryQueue.get()
        if valueDict is None:
          print "(%s, %s) is exiting" %(self._server, self._port)
          break

        if options.debug:
          print >> fnLog, "port: %s, valueDict: %s" %(self._port, valueDict)
        _, _, _, results = client.fetchSerp(valueDict)
        # score:rel:domain
        ranks = [":".join(item) for item in results[1:]]
        line = "\t".join(["key=" + valueDict["key"],
                          "user=" + valueDict["user"],
                          "addToCart=" + valueDict["addToCart"],
                          "purchase=" + valueDict["purchase"],
                          "rank=" + " ".join(ranks)])
        self._resultQueue.put(line)
        print >> fnLog, "\nsucceed in port=", self._port, valueDict
        fnLog.flush()

      except UnicodeDecodeError:
        print >> fnLog, "Warning: Unicode error in port=", self._port, valueDict
        fnLog.flush()

      except Exception as error:
        print >> fnLog, "Warning(unknown exception):", error, \
                        "in port=", self._port, valueDict
        fnLog.flush()

        if not self._portAvailable():
          print >> fnLog, "Error: fail in port=%s" %self._port
          fnLog.flush()
          queryQueue.put(valueDict)
          break

  @staticmethod
  def threadWrite(resultQueue, outFile):
    fou = open(outFile, "w")
    while True:
      line = resultQueue.get()
      if line is None:
        break

      line = toUtf8(line)
      if line is not None:
        print >> fou, line
        fou.flush()
    fou.close()

if __name__ == "__main__":
  parser = OptionParser(usage = "cmd [optons] file1 file2 ...")
  parser.add_option("-o", dest = "outFile", default = "rank.txt",
                    help = "default 'rank.txt'")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--debug", action = "store_true", dest = "debug",
                     default = False, help = "")
  (options, args) = parser.parse_args()

  threadNum = len(servers) * len(ports)
  queryQueue, resultQueue = Queue(threadNum), Queue()
  threads = [FeatExtraction(server, port, queryQueue, resultQueue)
             for server, port in itertools.product(servers, ports)]
  writeProcess = Thread(target = FeatExtraction.threadWrite,
                        args = (resultQueue, options.outFile))
  writeProcess.start()

  for td in threads:
    td.start()
    print "starting", td.getName()

  queryIter = readNamedColumnFile(args)
  for query in queryIter:
    try:
      queryQueue.put(query, timeout = 10 * 60)
    except:
      break

  for td in threads:
    queryQueue.put(None)

  for td in threads:
    td.join()
    print td.getName(), "joins"
  resultQueue.put(None)

  print "All threads have joined"


