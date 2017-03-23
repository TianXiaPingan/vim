#!/usr/bin/env python2.7
#coding: utf8

from _RunClient import Client
from algorithm import *
from multiprocessing import Queue
from threading import Thread

servers = ["cloud1", "cloud2", "cloud3", "cloud4", "cloud5", "cloud6"]
ports = [9001, 9002]

def portAvailable(server, port):
  client = Client(server, port, 100)
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

def threadFunction(server, port, queryQueue, resultQueue):
  # print "(%s, %s) is starting" %(server, port)
  client = Client(server, port, 100)
  fnLog = open("log.%s" %port, "w")
  while True:
    try:
      valueDict = queryQueue.get()
      if valueDict is None:
        print "(%s, %s) is exiting" %(server, port)
        break

      if options.debug:
        print >> fnLog, "port: %s, valueDict: %s" %(port, valueDict)
      _, _, _, results = client.fetchSerp(valueDict)
      # score:rel:domain
      ranks = [":".join(item) for item in results[1:]]
      line = "\t".join(["key=" + valueDict["key"],
                        "user=" + valueDict["user"],
                        "addToCart=" + valueDict["addToCart"],
                        "purchase=" + valueDict["purchase"],
                        "rank=" + " ".join(ranks)])
      resultQueue.put(line)
      print >> fnLog, "\nsucceed in port=", port, valueDict
      fnLog.flush()

    except UnicodeDecodeError:
      print >> fnLog, "Warning: Unicode error in port=", port, valueDict
      fnLog.flush()

    except Exception as error:
      print >> fnLog, "Warning(unknown exception):", error, \
                      "in port=", port, valueDict
      fnLog.flush()

      if not portAvailable(server, port):
        print >> fnLog, "Error: fail in port=%s" %port
        fnLog.flush()
        queryQueue.put(valueDict)
        break

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

  threads = [Thread(target = threadFunction, 
                    args = (server, port, queryQueue, resultQueue))
             for server, port in itertools.product(servers, ports)]

  writeProcess = Thread(target = threadWrite,
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


