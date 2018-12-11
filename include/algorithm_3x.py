#!/usr/bin/env python

from optparse import OptionParser

import bisect
import collections
import copy
import datetime
import heapq
import itertools
import logging
import functools
import math
import multiprocessing
import operator
import optparse
import os
import pickle
import pprint
import queue
import random
import re
import struct
import sys
import time
import common as nlp

try:
  import scipy
  from scipy import array
except ImportError:
  print("Does not find package 'scipy'")

try:
  import tensorflow as tf
except ImportError:
  print("Does not find package 'tensorflow'")

class WordIdDict:
  def __init__(self):
    self._word2Id = {}
    self._words = []

  def addWord(self, word):
    idx = self._word2Id.get(word, None)
    if idx is not None:
      return idx
    self._words.append(word)
    self._word2Id[word] = len(self._word2Id)
    return len(self._words) - 1

  def getWordId(self, word):
    return self._word2Id.get(word, None)

  def getWord(self, idx):
    return self._words[idx] if 0 <= idx < len(self._words) else None

  def size(self):
    return len(self._words)

def trim_dict(dictObj, attrsKept):
  attrsKept = set(attrsKept)
  for attr in list(dictObj.keys()):
    if attr not in attrsKept: 
      del dictObj[attr]
  return dictObj 

def read_named_column_file_list(files: list, keptAttrs=None, removedAttrs=None):
   for fn in files:
    for record in read_named_column_file(fn, keptAttrs, removedAttrs):
      yield record

def read_named_column_file(file_name: str, keptAttrs=None, removedAttrs=None):
  '''files: string
     keptAttrs: None, or a list
     removedAttrs: None, or a list
     take keptAttrs with priority.
  '''
  assert type(file_name) is str
  if (keptAttrs is not None or
      keptAttrs is None and removedAttrs is None):
    for ln in open(file_name):
      yield extract_attribute(ln, keptAttrs)
  elif removedAttrs is not None:
    for ln in open(file_name):
      d = extract_attribute(ln)
      if len(d) == 0:
        continue

      for attr in removedAttrs:
        if attr in d:
          d.pop(attr)

      yield d
  else:
    assert False

def extract_attribute(line: str, keys=None):
  toks = line.split("\t")
  if keys is not None and type(keys) is not set:
    keys = set(keys)

  try:
    items = [list(map(operator.methodcaller("strip"), tok.split("=")))
             for tok in toks]
    items = [pair for pair in items if keys is None or pair[0] in keys]
    return dict(items)
  except:
    print("ERROR: Wrong format:", line)
    return dict()

if __name__ == "__main__":
  parser = OptionParser(usage="cmd dev1@dir1 dir2")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
  #default = False, help = "")
  (options, args) = parser.parse_args()

  idxDict = WordIdDict()
  print(idxDict.addWord("summer"))
  print(idxDict.addWord("rain"))
  print(idxDict.getWord(100))
  print(idxDict.getWord(1))
  print(idxDict.size())

  toks = "name=TianXia\tage=16\theight=1.76".split("\t")
  print(list(extract_attribute(toks, set(["name"])).items()))
  print(list(extract_attribute(toks, set(["name", "age"])).items()))
  print(list(extract_attribute(toks).items()))

