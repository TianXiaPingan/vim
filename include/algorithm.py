#!/usr/bin/env python

from collections import defaultdict, namedtuple
from operator import methodcaller, attrgetter, itemgetter, add
from optparse import OptionParser
import bisect
import cPickle
import collections
import copy 
import heapq 
import itertools
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

  def get_father(self, p):
    if self._fathers[p] is None:
      return p
    self._fathers[p] = self.get_father(self._fathers[p])
    return self._fathers[p]

  def is_together(self, p1, p2):
    return self.get_father(p1) == self.get_father(p2)

  def combine(self, p1, p2):
    f1, f2 = self.get_father(p1), self.get_father(p2)
    if f1 != f2:
      if self._sizes[f1] >= self._sizes[f2]:
        self._fathers[f2] = f1
        self._sizes[f1] += self._sizes[f2]
      else:
        self._fathers[f1] = f2 
        self._sizes[f2] += self._sizes[f1]
      self._cluster_size -= 1    


def extractAttribute(toks, keys = None):
  items = map(lambda tok: map(methodcaller("strip"), tok.split("=")), toks)
  items = filter(lambda pair: keys is None or pair[0] in keys, items)
  return dict(items)

def getInstalledPackages():
  import pip
  packages = pip.get_installed_distributions()
  packages = sorted(["%s==%s" % (i.key, i.version) for i in packages])
  return packages

def eq(v1, v2, prec = EPSILON):
  return abs(v1 - v2) < EPSILON

def getMemory(size_type = "rss"):
  '''Generalization; memory sizes (MB): rss, rsz, vsz.'''
  content = os.popen('ps -p %d -o %s | tail -1' 
                     %(os.getpid(), size_type)).read()
  return round(float(content) / 1024, 3)

def norm1(vec):
  nm = sum(abs(e) for e in vec)
  if eq(nm, EPSILON):
    return array([0.0] * len(vec))
  else:
    return array([e / nm for e in vec])

def norm2(vec):
  nm = sqrt(sum(e * e for e in vec))
  if eq(nm, EPSILON):
    return array([0.0] * len(vec))
  else:
    return array([e / nm for e in vec])

def discreteSample(dists):        
  '''each probability must be greater than 0'''
  sumv = sum(dists)
  prob = sumv * random.random()
  asum = 0.0
  for p in xrange(len(dists)):
    asum += dists[p]
    if prob <= asum:
        return p
  for p in dists:
    assert p >= 0

def nFoldSplit(data, N = 10):
  seed(0)
  shuffle(data)
  ret   = []
  pdata = [data[fi::N] for fi in xrange(N)]
  for fi in xrange(N):
    test_data = pdata[fi]
    pdata.remove(test_data)
    yield [sum(pdata, []), test_data]
    pdata.insert(fi, test_data)

def logSum(ds):
  '''input: [d1, d2, d3..] = [log(p1), log(p2), log(p3)..]
      output: log(p1 + p2 + p3..)
  '''
  dv = max(ds)
  e = log(sum([exp(d - dv) for d in ds]))
  return dv + e

def logFPrime(fss, weight):
  '''input: fss: a list of feature vectors
      weight: scipy.array
      output: return log-gradient of log-linear model.
  '''
  #dn  = logsum([(ws.T * f)[0] for f in fs])
  dn  = logsum(map(weight.dot, fss))
  pdw = array([0.0] * len(weight))
  for fs in fss:
    pdw += exp(weight.dot(fs) - dn) * fs 
  return pdw

def unique(data, key = lambda d: d):
  '''data should be pre-sorted'''
  ph, p = 0, 1
  while p < len(data):
    if not eq(key(data[p]), key(data[ph])):
      ph += 1
      data[ph] = data[p]
    p += 1   
  return data[: ph + 1]    

if __name__ == "__main__":
  print "general memory:", getMemory()

  print unique([(0, 1), (0, 1), (1, 1)], key = lambda d: d[0])
  print eq(0, 0, EPSILON)
  print eq(1.2345678912345678e30, 1.23456789123456689e30, 1e-13)

  dists = [1, 2, 3, 4]
  print collections.Counter([discreteSample(dists) for freq in xrange(100000)])

  toks = "name=TianXia\tage=16\theight=1.76".split("\t")
  print extractAttribute(toks, set(["name"])).items()
  print extractAttribute(toks, set(["name", "age"])).items()
  print extractAttribute(toks).items()

