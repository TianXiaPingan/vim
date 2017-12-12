#!/usr/bin/env python
#coding: utf8

from algorithm import *

cmdTpt = ("/opt/spark/2.1/bin/spark-submit "
          "--master yarn "
          "--conf spark.driver.maxResultSize=%dG "
          "--conf spark.dynamicAllocation.maxExecutors=%d "
          "--driver-memory %dg "
          "--executor-memory %dg "
          "--py-files /home/txia/.vim/include/algorithm.py%s "
          "%s")

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("--maxResultSize", type = int, default = 3, 
                    dest = "maxResultSize", help = "3G")
  parser.add_option("--maxExecutors", type = int, default = 200, 
                    dest = "maxExecutors", help = "200")
  parser.add_option("--driverMemory", type = int, default = 10, 
                    dest = "driverMemory", help = "10G")
  parser.add_option("--executorMemory", type = int, default = 3, 
                    dest = "executorMemory", help = "3g")
  parser.add_option("--pyFiles", default = "", dest = "pyFiles")
  (options, args) = parser.parse_args()

  pyFiles = options.pyFiles.strip()
  pyFiles = "," + pyFiles if pyFiles != "" else ""

  cmd = cmdTpt %(options.maxResultSize, options.maxExecutors,
                 options.driverMemory, options.executorMemory,
                 pyFiles, " ".join(args))

  print cmd
  executeCmd(cmd)

