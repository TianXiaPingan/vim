#!/usr/bin/env python

from algorithm import *

def check_source_dir():
  files = listdir(".")
  return "assets" in files and "index.html" in files

if __name__ == "__main__":
  parser = OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose", \
      #default = False, help = "don't print status messages to stdout")
  (options, args) = parser.parse_args()

  cmd_tpt = '''rsync -ravutzh --progress \
    -e 'ssh' \
    . \
    "summer@130.108.28.50:/media/inf/web\ services/robot\ reporter/slide"'''

  try:
    src_dir = "/Users/world/Desktop/robot reporter/slide"
    chdir(src_dir)
  except OSError:
    print '''Can not find "%s"''' %src_dir
    exit(1)

  print cmd_tpt
  system(cmd_tpt)
