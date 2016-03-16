#!/usr/bin/env python2.7
#coding: utf-8
  
from sys import argv
from time import time
from os import listdir, path, rename, getcwd, chdir
from optparse import OptionParser

def rename_video_name(pattern, cdir, files):
    cwd = getcwd()
    chdir(cdir)
    prefix = cdir[cdir.rfind("/") + 1:]
    cnt = 0
    for fname in files:
        if fname.lower().endswith(".mov"):
            if fname.startswith("MVI_"):
                rename(fname, "%s.%d.mov" %(prefix, cnt))
                print "rename to %s.%d.mov" %(prefix, cnt)
                cnt += 1
            else:
                print "find %s/%s" %(cdir, fname)
    chdir(cwd)            

if __name__ == "__main__":
    path.walk(getcwd(), rename_video_name, None)


