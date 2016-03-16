#!/usr/bin/env python
#coding: utf8

import os, re

def extract_pwd(thread):
  reg = re.compile(r"PWD=(.*?)LANG")
  return reg.findall(open("/proc/%s/environ" %thread).read())[0]

if __name__ == "__main__":
  threads = [line.split()[0] 
             for line in list(os.popen("ps -A | grep -i python"))]
  for thread in threads:
    try:
      print "%-10s %-80s %-80s" %(thread, 
                                  extract_pwd(thread),
                                  open("/proc/%s/cmdline" %thread).read())
    except:
      pass

