#!/usr/bin/env python
#coding: utf8

import os

if __name__ == "__main__":
  os.system("clear")

  os.chdir("/Users/%s/inf/study/wiki" %os.getlogin())
  os.system("nohup ./wikiserver.py 2>/dev/null &")

