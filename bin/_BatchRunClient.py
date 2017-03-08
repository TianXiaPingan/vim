#!/usr/bin/env python2.7
#coding: utf8

from algorithm import *
from multiprocessing import Process, Queue;
from _RunClient import Client
import urllib2

debug     = None

checkUrl = ("http://localhost:{port}/v3/name/find?q=zoespizza"
            "&user_country_site=www&geo_country_code=us&pagination_size=20"
            "&pagination_start=0&max_price=2147483647&min_price=0"
            "&max_sld_length=2147483647&min_sld_length=1"
            "&user_shopper_status=PUBLIC&server_private_label_id=1"
            "&server_currency=USD&server_ip=127.0.0.1&server_name=anonymous"
            "&domain_source=ALL&user_vguid=strange-visitor-session-ID"
            "&user_shopper_id=52563262")

def portAvailable(port):
  url = checkUrl.replace("{port}", port)
  cmd = "wget '%s' -O test.%s.html" %(url, port)
  for tryFreq in xrange(10):
    code = os.system(cmd)
    print "Checking port=%s in the %d-th time: code=%d" %(port, tryFreq, code)
    print cmd
    sys.stdout.flush()
    if code == 0:
      return True
    time.sleep(10)
  return False

def threadFunction(port, queryQueue, resultQueue):
  client = Client(port, 100)
  fnLog = open("log.%s" %port, "w")
  while True:
    try:
      valueDict = queryQueue.get()
      if debug:
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

      if not portAvailable(port):
        print >> fnLog, "Error: fail in port=%s" %port
        fnLog.flush()
        queryQueue.put(valueDict)
        break

def threadWrite(resultQueue, outFile):
  fou = open(outFile, "w")
  while True:
    line = toUtf8(resultQueue.get())
    if line is not None:
      print >> fou, line
      fou.flush()
  fou.close()

def extractFinishedKey(files):
  def extractSingleFile(fname):
    reg = re.compile("key=(.*?)\s")
    keys = set() 
    for ln in open(fname):
      rst = reg.findall(ln)
      keys.update(rst)

    return keys

  ret = extractSingleFile(files[0])
  for fn in files[1:]:
    ret.update(extractSingleFile(fn))
  return ret

if __name__ == "__main__":
  parser = OptionParser(usage = "cmd [optons] file1 file2 ...")
  parser.add_option("--ports", dest = "ports")
  parser.add_option("-o", dest = "outFile", default = "rank.txt",
                    help = "default 'rank.txt'")
  parser.add_option("--rankHistory", dest = "rankHistory", default = None,
                    help = ("support multiple files, splitted with ','"
                            "default None"))
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--debug", action = "store_true", dest = "debug",
                     default = False, help = "")
  (options, args) = parser.parse_args()

  debug = options.debug

  if "-" not in options.ports:
    ports = [options.ports]
  else:
    portFrom, portTo = map(int, options.ports.split("-"))
    ports = map(str, range(portFrom, portTo + 1))
  print ports

  print "query files:", args
  queries = list(readNamedColumnFile(args))
  print "There are %d queries" %len(queries)

  if options.rankHistory is not None:
    finishedKeys = extractFinishedKey(options.rankHistory.split(","))
    print "#Finished query:", len(finishedKeys)

    queries = filter(lambda d: d["key"] not in finishedKeys, queries)
    print "#query after filtering:", len(queries)
    del finishedKeys

  queryQueue, resultQueue = multiprocessing.Queue(), multiprocessing.Queue()
  for query in queries:
    queryQueue.put(query)

  processes = [Process(target = threadFunction,
                       args = (port, queryQueue, resultQueue))
               for port in ports]
  writeProcess = Process(target = threadWrite,
                         args = (resultQueue, options.outFile))
  writeProcess.start()

  for process in processes:
    process.start()
    print "start"
