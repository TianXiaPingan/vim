#!/usr/bin/python
  
from sys import argv
from time import time
from os import listdir, rename, getcwd
import re
from sys import argv
from mutagen.mp3 import MP3 
from mutagen.easyid3 import EasyID3 
import mutagen.id3

# sudo apt-get install python-mutagen

class PinyinDic:
    def __init__(self, dict_name):
        self.reg = re.compile("((.*?)-)?(.*)\.mp3", re.IGNORECASE)
        self.zhdic = {}
        for ln in file(dict_name, "rU"):
            if ":" not in ln:
                continue
            tok1, tok2 = ln.split(":")
            tok1, tok2 = tok1.strip()[: -1].title(), tok2.strip().decode("utf8")
            for tok in tok2:
                self.zhdic[tok] = tok1
        #print len(self.zhdic)                

    def Chinese2pinyin(self, name):
        r = "".join([self.zhdic.get(ch, ch) for ch in name.strip().decode("utf8")])
        r = "".join(filter(lambda ch: ord(ch) < 256, r)).encode("utf8")
        return r
    
    def update_mp3_ID3(self, fe):
        nfe = self.Chinese2pinyin(fe)
        r = self.reg.findall(nfe[nfe.rfind("/") + 1:])
        if r == []:
            print "fe is not a mp3 file"
        else:
            artist, title = r[0][1], r[0][2]
            m = MP3(fe, ID3=EasyID3) 
            try: 
                m.add_tags(ID3=EasyID3) 
            except mutagen.id3.error: 
                pass
            m["artist"] = artist.decode("utf8")
            m["title"] = title.decode("utf8")
            m["album"] = ""
            m["genre"] = ""
            m.save()
            print m.pprint()

if __name__ == "__main__":
    pdic = PinyinDic("/media/inf/1-study/tools/pinyin.dictionary")
    for fe in [fe for fe in listdir(getcwd()) if not fe.startswith(".")]:
        pdic.update_mp3_ID3(fe)
    print "Program finishes"


