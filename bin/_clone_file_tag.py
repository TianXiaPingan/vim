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

def applyFileTag(item):
  fn, tag = item
  assert len(file2tags) > 0
  fn = normalizeFile(fn)
  try:
    print "adding '%s' into '%s'" %(tag, fn)
    cmd = '''_tag_file -s "%s" "%s"''' %(tag, fn)
    os.system(cmd)
  except:
    print "failed '%s'" %fn

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  parser.add_option("-c", "--cmd", dest = "cmd", default = "analyze", 
                    help = "[gen, apply, analyze], default 'analyze'")
  parser.add_option("--path", dest = "path", default = "~/inf",
                    help = "target folder, default ~/inf")

  (options, args) = parser.parse_args()

  assert options.cmd in ["gen", "apply", "analyze"]

  os.chdir(os.path.expanduser(options.path))
  tagFile = "tags.dict"

  if options.cmd == "analyze":
    file2tags = eval(open(tagFile).read())
    folders = sorted(set([os.path.split(fn)[0] for fn in file2tags]))
    print "folders with tagged files"
    print "\n".join(folders)

  elif options.cmd == "gen":
    candFiles = listFiles()
    print "#all files:", len(candFiles)
    print "permitted file extension:", validExts

    file2tags = dict(filter(lambda r: r is not None,
                            multiprocessing.Pool().map(analyzeFileTag,
                                                       candFiles)))
    print "#tagged files:", len(file2tags)
    print >> open(tagFile, "w"), file2tags

  elif options.cmd == "apply":
    file2tags = eval(open(tagFile).read())
    multiprocessing.Pool().map(applyFileTag, file2tags.items())
    
