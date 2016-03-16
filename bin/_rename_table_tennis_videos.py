#!/usr/bin/env python
#coding: utf8

from algorithm import *
import codecs
import sys

class RenameTableTennies:
  video_exts_ = [".mp4"]

  def __init__(self):
    self._players = [
      ["ma long", "马龙"],
      ["ma lin", "马琳"],
      ["zhang ji ke", "张继科"],
      ["zhang yining", "张怡宁"],
      ["wang hao", "王皓"],
      ["wang li qin", "王励勤"],
      ["kong ling hui", "孔令辉"],
      ["xu xin", "许昕"],
      ["fang bo", "方博"],
      ["fan zhen dong", "樊振东"],
      ["Chuang Chih Yuan", "庄智渊"],
      ["chen qi", "陈玘"],
      ["Timo Boll", "波尔"],
      ["zhou yu", "周雨"],
      ["liu guo liang", "刘国梁"],
      ["Dimitrij Ovtcharov", "奥恰洛夫"],
      ["Ovtcharov", "奥恰洛夫"],
      ["waldner", "老瓦"],
    ]

    self._others = [
      ["-", " vs "],
      ["_", " "],
      ["[", "("],
      ["]", ")"],
      ["【", "("],
      ["】", ")"],
      ["（", "("],
      ["）", ")"],
      ["!", ""],
      ["！", ""],
      ["：", ": "],
    ]

  def _get_videos(self, files):
    for fname in files:
      lfname = fname.lower()
      for ext in RenameTableTennies.video_exts_:
        if lfname.endswith(ext):
          yield fname

  def rename(self, files, debug):
    existent_vfiles = set(self._get_videos(os.listdir(".")))
    fou = open("log.rename.txt", "w")
    fid = 0

    for fn in self._get_videos(files):
      fn_new = self._get_new_file(fn)
      if fn_new == fn:
        continue

      msg = "%3d) %s --> %s" %(fid, fn, fn_new)
      print msg 
      print >> fou, msg 

      if fn_new in existent_vfiles:
        print >> fou, "Error: new file name exists"
        print "Error: new file name exists"
        break
      if not debug:
        os.rename(fn, fn_new)
        existent_vfiles.add(fn_new)
      fid += 1   
    fou.close()

  def _get_new_file(self, fn):
    for en_name, ch_name in self._players:
      fn = re.sub(".*".join(en_name.split()), ch_name, fn, 
                  flags = re.IGNORECASE)

    for str1, str2 in self._others:
      fn = fn.replace(str1, str2)

    fn = " ".join(fn.lower().split())
    return fn

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                    #default = False, help = "")
  parser.add_option("-D", action = "store_false", dest = "debug",
                    default = True, help = "No debug")
  (options, args) = parser.parse_args()

  os.chdir(os.getcwd())
  files = os.listdir(".")

  renamer = RenameTableTennies()
  renamer.rename(files, options.debug)
