#!/usr/bin/env python
#coding: utf8

from algorithm import *

def normalize_file(fn):
  return fn.strip().replace('"', r'\"')

def analyze_file(data):
  fn_ID, fn = data
  #print "processing", fn_ID, fn
  fn = normalize_file(fn) 
  if "/." in fn:
    return None
  try:
    line = os.popen('''_tag_file -l "%s"''' %fn).readlines()[0]
  except:
    print "skipping '%s'" %fn
    return None

  toks = line.split("\t")
  if len(toks) == 1:
    return None
  print "found tags in", fn
  return [fn, toks[1].strip()]

def apply_file(data):
  fn_ID, fn = data
  assert len(file2tags) > 0
  fn = normalize_file(fn)
  try:
    if fn in file2tags:
      print "adding '%s' into '%s'" %(file2tags[fn], fn)
      cmd = '''_tag_file -s "%s" "%s"''' %(file2tags[fn], fn)
      #print "cmd:", cmd
      os.system(cmd)
  except:
    print "skipping '%s'" %fn

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("-c", "--cmd", dest = "cmd", default = "analyze", 
                    help = "analyze, apply")
  (options, args) = parser.parse_args()

  assert options.cmd in ["analyze", "apply"] 

  all_files = enumerate(filter(lambda r: "/." not in r, os.popen("find .")))
  #print "#all files:", len(all_files),
  #print "\n".join(all_files)

  if options.cmd == "analyze":
    file2tags = dict(filter(lambda r: r is not None, 
                            multiprocessing.Pool().map(analyze_file, 
                                                       all_files)))

    cPickle.dump(file2tags, open("tags.dict", "w"))
  elif options.cmd == "apply":
    file2tags = cPickle.load(open("tags.dict"))
    multiprocessing.Pool().map(apply_file, all_files)
    
