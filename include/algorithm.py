#!/usr/bin/env python

from collections import defaultdict, namedtuple
from operator import methodcaller, attrgetter, itemgetter, add
from optparse import OptionParser
from scipy import array

import bisect
import cPickle
import collections
import copy 
import heapq 
import itertools
import logging
import math 
import multiprocessing 
import optparse
import os
import pprint
import random
import re
import scipy
import struct
import sys
import time

INF         = float("inf")
EPSILON     = 1e-6

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

def toUtf8(line):
  if type(line) is unicode:
    try:
      return line.encode("utf8")
    except:
      print "Warning: in toUtf8(...)"
      return None
  elif type(line) is str:
    return line
  else:
    print "Error: wrong type in toUtf8(...)"
    return None

def calcNdcg(relsList):
  '''relsList: [[1, 2, 3, 1, ...], [2, 3, 1, 0, ..]]
  '''
  def calcPerDcg(rels):
    rels = rels[: 20] if len(rels) >= 20 else rels + [0] * (20 - len(rels))
    rels = array(rels)
    poses = array(range(20))
    scores = (2 ** rels - 1) / scipy.log(poses + 2)
    return scipy.cumsum(scores)

  def calcPerNdcg(rels):
    if rels.count(0) == len(rels):
      return 1.

    dcg = calcPerDcg(rels)
    iDcg = calcPerDcg(sorted(copy.copy(rels), reverse = True))
    return dcg / iDcg

  ret = sum(map(calcPerNdcg, relsList)) / len(relsList)
  return ret

def readNamedColumnFile(files, removedAttrs = None):
  '''files: string, or a list
     keptAttrs: None, or a list
     removedAttrs: None, or a list
  '''
  if type(files) is str:
    files = [files]
  if removedAttrs is None:
    removedAttrs = []

  ret = []
  for fname in files:
    data = filter(lambda d: len(d) > 0,
                  map(extractAttribute, open(fname)))
    for d in data:
      for attr in removedAttrs:
        if attr in d:
          d.pop(attr)
      ret.append(d)
  return ret

def extractAttribute(input, keys = None):
  if type(input) in [str, unicode]:
    toks = input.split("\t")
  elif type(input) is list:
    toks = input
  else:
    print "ERROR: Wrong input:", type(input) 
    return dict()

  try:
    items = map(lambda tok: map(methodcaller("strip"), tok.split("=")), toks)
    items = filter(lambda pair: keys is None or pair[0] in keys, items)
    return dict(items)
  except:
    print "ERROR: Wrong format:", input
    return dict()

def getInstalledPackages():
  import pip
  packages = pip.get_installed_distributions()
  packages = sorted(["%s==%s" % (i.key, i.version) for i in packages])
  return packages

def eq(v1, v2, prec = EPSILON):
  return abs(v1 - v2) < prec

def getMemory(size_type = "rss"):
  '''Generalization; memory sizes (MB): rss, rsz, vsz.'''
  content = os.popen('ps -p %d -o %s | tail -1' 
                     %(os.getpid(), size_type)).read()
  return round(float(content) / 1024, 3)

def norm1(vec):
  vec = array(vec)
  nm = float(sum(abs(vec)))
  return vec if eq(nm, 0) else vec / nm

def norm2(vec):
  vec = array(vec)
  nm = math.sqrt(sum(vec * vec))
  return vec if eq(nm, EPSILON) else vec / nm

def discreteSample(dists):        
  '''each probability must be greater than 0'''
  dists = array(dists)
  assert all(dists >= 0)
  accsum = scipy.cumsum(dists)
  expNum = accsum[-1] * random.random()
  return bisect.bisect(accsum, expNum)

def logSum(ds):
  '''input: [d1, d2, d3..] = [log(p1), log(p2), log(p3)..]
      output: log(p1 + p2 + p3..)
  '''
  dv = max(ds)
  e = math.log(sum([math.exp(d - dv) for d in ds]))
  return dv + e

def logFPrime(fss, weight):
  '''input: fss: a list of feature vectors
      weight: scipy.array
      output: return log-gradient of log-linear model.
  '''
  #dn  = logsum([(ws.T * f)[0] for f in fs])
  dn  = logSum(map(weight.dot, fss))
  pdw = array([0.0] * len(weight))
  for fs in fss:
    pdw += math.exp(weight.dot(fs) - dn) * fs
  return pdw

if __name__ == "__main__":
  print "general memory:", getMemory()

  print eq(0, 0, EPSILON)
  print eq(1.2345678912345678e30, 1.23456789123456689e30, 1e-13)

  dists = [1, 2, 3, 4]
  print collections.Counter([discreteSample(dists) for freq in xrange(100000)])

  toks = "name=TianXia\tage=16\theight=1.76".split("\t")
  print extractAttribute(toks, set(["name"])).items()
  print extractAttribute(toks, set(["name", "age"])).items()
  print extractAttribute(toks).items()

  relsList = []
  relsList.append([3, 2, 1] + [0] * 20 + [4] * 2)
  print "relsList:", relsList
  print "ndcg:", calcNdcg(relsList)
