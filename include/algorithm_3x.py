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

class DisjointSet:
  def __init__(self, size):
    self._fathers = [None] * size
    self._sizes   = [1] * size
    self._cluster_size = size

  def getFather(self, p):
    if self._fathers[p] is None:
      return p
    self._fathers[p] = self.getFather(self._fathers[p])
    return self._fathers[p]

  def isTogether(self, p1, p2):
    return self.getFather(p1) == self.getFather(p2)

  def combine(self, p1, p2):
    f1, f2 = self.getFather(p1), self.getFather(p2)
    if f1 != f2:
      if self._sizes[f1] >= self._sizes[f2]:
        self._fathers[f2] = f1
        self._sizes[f1] += self._sizes[f2]
      else:
        self._fathers[f1] = f2
        self._sizes[f2] += self._sizes[f1]
      self._cluster_size -= 1

def group_by_key(dataIter):
  # dataIter.next() --> (key, data)
  # return: (key, [data1, ...])
  sample = []
  prevKey = None
  for key, inst in dataIter:
    if sample == [] or key == prevKey:
      sample.append(inst)
    else:
      yield prevKey, sample
      sample = [inst]

    prevKey = key

  if sample != []:
    yield prevKey, sample

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

def discrete_sample(dists):
  '''each probability must be greater than 0'''
  dists = array(dists)
  assert all(dists >= 0)
  accsum = scipy.cumsum(dists)
  expNum = accsum[-1] * random.random()
  return bisect.bisect(accsum, expNum)

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


  data = [("a", 1), ("a", 2), ("b", 3), ("c", 4)]
  print(list(group_by_key(iter(data))))

  dists = [1, 2, 3, 4]
  print(collections.Counter([discrete_sample(dists) for freq in range(100000)]))

  toks = "name=TianXia\tage=16\theight=1.76".split("\t")
  print(list(extract_attribute(toks, set(["name"])).items()))
  print(list(extract_attribute(toks, set(["name", "age"])).items()))
  print(list(extract_attribute(toks).items()))

