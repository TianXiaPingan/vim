#!/usr/bin/env python
#coding: utf8

from algorithm import *

validExts = set([
  "pdf",
  "html", "webarchive",
  "jpg", "jpeg", "png",
  "numbers", "pages",
  "text",
  "mp4",
])

def listFiles():
  def isCandidate(name):
    if "/." in name:
      return False
    if "Photos Library" in name:
      return False

    return name.rpartition(".")[2] in validExts

  allFiles = os.popen("find .").read().split("\n")
  return filter(isCandidate, allFiles)

def normalizeFile(fn):
  return fn.strip().replace('"', r'\"')

def analyzeFileTag(fname):
  fname = normalizeFile(fname)
  try:
    line = os.popen('''_tag_file -l "%s"''' % fname).readlines()[0]
  except:
    print "skipping '%s'" % fname
    return None

  toks = line.split("\t")
  if len(toks) == 1:
    "not found for '%s'" % fname
    return None

  tags = toks[1].strip()
  print "found: '%s': %s" %(fname, tags)

  return fname, tags

def applyFileTag(data):
  fn_ID, fn = data
  assert len(file2tags) > 0
  fn = normalizeFile(fn)
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
                    help = "[analyze, apply], default 'analyze'")
  parser.add_option("--path", dest = "path", default = "/Users/txia/inf",
                    help = "target folder, default ~/inf")

  (options, args) = parser.parse_args()

  assert options.cmd in ["analyze", "apply"]

  os.chdir(options.path)
  candFiles = listFiles()
  print "#all files:", len(candFiles)
  print "permitted file extension:", validExts

  tagFile = "tags.dict"
  if options.cmd == "analyze":
    file2tags = dict(filter(lambda r: r is not None,
                            multiprocessing.Pool().map(analyzeFileTag,
                                                       candFiles)))
    print "#tagged files:", len(file2tags)
    print >> open(tagFile, "w"), file2tags

  elif options.cmd == "apply":
    file2tags = eval(open(tagFile).read())
    multiprocessing.Pool().map(applyFileTag, candFiles)
    
