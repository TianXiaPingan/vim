#!/usr/bin/env python

from collections import defaultdict, namedtuple, Counter
from operator import methodcaller, attrgetter, itemgetter, add
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

try:
  import scipy
  from scipy import array
except ImportError:
  print("Does not find package 'scipy'")

try:
  import tensorflow as tf
except ImportError:
  print("Does not find package 'tensorflow'")

INF         = float("inf")
EPSILON     = 1e-6

def toInt(tensor):
  return tf.cast(tensor, tf.int32)

def toFloat(tensor):
  return tf.cast(tensor, tf.float32)

class TF:
  @staticmethod
  def multiHot(x, depth):
    def funcC(p, v):
      return tf.less(p, tf.shape(x)[0])

    def funcB(p, v):
      row = tf.add_n(tf.unstack(indexes[p]))
      return p + 1, tf.concat([v, [row]], axis=0)

    indexes = tf.one_hot(x, depth)
    initV = tf.constant(0)

    _, v = tf.while_loop(funcC, funcB,
                         [initV, tf.convert_to_tensor([list(range(depth))],
                                                      tf.float32)],
                         shape_invariants=[initV.get_shape(),
                                           tf.TensorShape([None, depth])])

    return v[1:,]
  
class SentenceBLEU:
  '''
  Regarding corpus BLEU: refer to "nltk.translate.bleu_score.sentence_bleu".
  '''
  def __init__(self, refs: list, max_order=4):
    '''
    :param refs: list[str]
    '''
    
    refs = [ref.split() for ref in refs]
    self._max_order = max_order
    global_ngram2freq = defaultdict()
    for ref in refs:
      ngram2freq = self._stat_ngram_freqs(ref)
      global_ngram2freq = self._cut(global_ngram2freq, ngram2freq)
    self._ref_ngram2freq = global_ngram2freq
    
    self._ref_len = min([len(ref) for ref in refs])

  def compute(self, hyp: str):
    hyp = hyp.split()
    hyp_ngram2freq = self._stat_ngram_freqs(hyp)
    matched = defaultdict(int)
    
    for ngram, freq in hyp_ngram2freq.items():
      order = ngram.count(" ") + 1
      freq = min(freq, self._ref_ngram2freq.get(ngram, 0))
      matched[order] += freq
      
    matched["hyp_len"] = len(hyp)
    
    return self._calc_BLEU(matched)
    
  def _calc_BLEU(self, matched):
    hyp_len, ref_len = matched["hyp_len"], self._ref_len
    precs = [matched[order] / (hyp_len - order + 1 + 1e-10)
             for order in range(1, self._max_order + 1)]
    prec  = functools.reduce(operator.mul, precs, 1) ** (1 / self._max_order)
    ratio = math.exp(min(0, 1 - ref_len / (hyp_len + 1e-10)))
    bleu = prec * ratio
    
    return bleu
  
  def _cut(self, ngram2freq1: dict, ngram2freq2: dict):
    ngram2freq = defaultdict(int)
    for key in set(list(ngram2freq1.keys()) + list(ngram2freq2.keys())):
      ngram2freq[key] = max(ngram2freq1.get(key, 0), ngram2freq2.get(key, 0))
    return ngram2freq
  
  def _stat_ngram_freqs(self, hyp_list: list):
    ngram2freq = defaultdict(int)
    for order in range(1, self._max_order + 1):
      for pos in range(0, len(hyp_list) - order + 1):
        ngram2freq[" ".join(hyp_list[pos: pos + order])] += 1
        
    return ngram2freq

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

class Spark:
  @staticmethod
  def toUtf8(data, keys: list):
    def mapper(vd):
      for key in keys:
        value = toUtf8(vd[key])
        if value is None:
          return None
        vd[key] = value
      return vd    

    return data.map(mapper).filter(lambda vd: vd is not None)

  @staticmethod
  def sql(hiveContext, sql):
    '''from pyspark import SparkContext, HiveContext
       sc = SparkContext()
       hiveContext = HiveContext(sc)
       Please remember string value from database might be unicode
       '''
    return hiveContext.sql(sql).rdd.coalesce(1024, True)

  @staticmethod
  def save(data, outputDir):
    hadoopDeleteFile(outputDir)
    data.saveAsTextFile(outputDir)

  @staticmethod
  def readPigData(sc, fname, schema, blockSize = 1024):
    '''We should add .coalesce(1024, True) for any read operation.
    '''
    def mapper(line):
      line = toUtf8(line)
      if line is None:
        return None

      values = line.split("\t")
      if len(values) == 0:
        return None
      return dict(list(zip(schema, values)))

    return sc.textFile(fname).coalesce(blockSize, True)\
             .map(mapper).filter(lambda vd: vd is not None)

  @staticmethod
  def readObjectData(sc, fname, blockSize = 1024):
    def evalObject(ln):
      try:
        return eval(ln)
      except Exception as error:
        print(error)
        print("ln:", ln) 
        assert False

    return sc.textFile(fname).coalesce(blockSize, True)\
             .map(evalObject)

  @staticmethod
  def mapToKeyValue(data, keys):
    return data.map(lambda vd: (Spark.getKey(vd, keys), vd))

  @staticmethod
  def mapToKeyValueList(data, keys):
    return data.map(lambda vd: (Spark.getKey(vd, keys), [vd]))

  @staticmethod
  def groupByKey(data, keys):
    return data.map(lambda vd: (Spark.getKey(vd, keys), [vd]))\
               .reduceByKey(add)

  @staticmethod
  def getKey(vd, keys):
    '''Only utf8 string, or int'''
    return "+".join(str(vd.get(key, "")) for key in keys)

  @staticmethod
  def distinctByKey(data, keys):
    return list(Spark.mapToKeyValue(data, keys)\
                .reduceByKey(lambda vd1, vd2: vd1).values())

  @staticmethod
  def removeNullKeyValue(data, keys):
    '''If some key-value is null or empty, then the final key-string
    would make no sense.'''
    return data.filter(lambda vd: not any([isNoneOrEmpty(vd.get(key))
                                           for key in keys]))

  @staticmethod
  def intersecByKey(data1, data2, keys):
    '''We must guarantee data == Spark.distinctByKey(data, keys)
    '''
    data1 = Spark.mapToKeyValue(data1, keys)
    data2 = Spark.mapToKeyValue(data2, keys)
    return list(data1.join(data2).values())

  @staticmethod
  def unionByKey(sc, datas, keys):
    return Spark.distinctByKey(sc.union(datas), keys)

class FileLock:
  lockName = "/tmp/lock.data"

  def __init__(self, sleepTime = 60):
    '''sleepTime: seconds'''
    self._sleepTime = sleepTime
    self._waitUntilRelease()
    executeCmd("touch %s" %FileLock.lockName)

  def unlock(self):
    executeCmd("rm %s" %FileLock.lockName)

  def _waitUntilRelease(self):
    while os.path.isfile(FileLock.lockName):
      print("_waitUntilRelease ...")
      sys.stdout.flush()
      time.sleep(self._sleepTime)

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

def groupByKey(dataIter):
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

def createList(shape: list, defaultValue=None):
  assert len(shape) > 0
  if len(shape) == 1:
    return [defaultValue for _ in range(shape[0])]
  else:
    return [createList(shape[1:], defaultValue) for _ in range(shape[0])]

def splitBy(data, f):
  data1, data2 = [], []
  for d in data:
    if f(d):
      data1.append(d)
    else:
      data2.append(d)
  return data1, data2

def trimDict(dictObj, attrsKept):
  attrsKept = set(attrsKept)
  for attr in list(dictObj.keys()):
    if attr not in attrsKept: 
      del dictObj[attr]
  return dictObj 

def addIncludePath(path):
  '''We could use relative path'''
  if path not in sys.path:
    sys.path.append(path)

def isNoneOrEmpty(data):
  '''This applies to any data type which has a __len__ method'''
  if data is None:
    return True
  if isinstance(data, (str, list, set, dict)):
    return len(data) == 0
  return False

def hadoopDeleteFile(fname):
  executeCmd("hadoop fs -rm -r %s" %fname)

def executeCmd(cmd):
  if (re.search(r"\bspark-submit\b", cmd) is not None or
      re.search(r"\bpig\b", cmd) is not None or
      re.search(r"\bhadoop\b", cmd) is not None):
    print("spark_submit or pig or hadoop fs is found in the cmd.")
    try:
      renewGSS()
      print("OK to run renewGSS()")
    except:
      print("Fail to run renewGSS()")

  ret = os.system(cmd)
  status = "OK" if ret == 0 else "fail"
  print(time.strftime("%x %X"), "[%s] executing '%s'" %(status, cmd))
  sys.stdout.flush()

def toUtf8(line):
  if type(line) is str:
    try:
      return line.encode("utf8")
    except:
      print("Warning: in toUtf8(...)")
      return None
  elif type(line) is str:
    return line
  else:
    print("Error: wrong type in toUtf8(...)")
    return None

def toUtf8List(lines: list):
  return [ln for ln in map(toUtf8, lines) if ln is not None]

def calcNdcg(relsList):
  '''relsList: [[1, 2, 3, 1, ...], [2, 3, 1, 0, ..]]
  '''
  def calcPerDcg(rels):
    rels = rels[: 20] if len(rels) >= 20 else rels + [0] * (20 - len(rels))
    rels = array(rels)
    poses = array(list(range(20)))
    scores = (2 ** rels - 1) / scipy.log(poses + 2)
    return scipy.cumsum(scores)

  def calcPerNdcg(rels):
    if rels.count(0) == len(rels):
      return array([1.] * 20)

    dcg = calcPerDcg(rels)
    iDcg = calcPerDcg(sorted(rels, reverse = True))
    return dcg / iDcg

  ret = sum(map(calcPerNdcg, relsList)) / len(relsList)
  return ret

def printFlush(cont, stream = None):
  if stream is None:
    stream = sys.stdout
  print(cont, file=stream)
  stream.flush()

def readNamedColumnFile(files, keptAttrs = None, removedAttrs = None):
  '''files: string, or a list
     keptAttrs: None, or a list
     removedAttrs: None, or a list
     take keptAttrs with priority.
  '''
  if type(files) is list:
    for fn in files:
      for record in readNamedColumnFile(fn, keptAttrs, removedAttrs):
        yield record
    return

  assert type(files) is str
  if (keptAttrs is not None or
      keptAttrs is None and removedAttrs is None):
    for ln in open(files):
      yield extractAttribute(ln, keptAttrs)
  elif removedAttrs is not None:
    for ln in open(files):
      d = extractAttribute(ln)
      if len(d) == 0:
        continue

      for attr in removedAttrs:
        if attr in d:
          d.pop(attr)

      yield d
  else:
    assert False

def getKeyValue(ln, key, local={}):
  if key not in local:
    local[key] = re.compile("%s=(.*?)(\t|\n)" %key)

  mt = local[key].search(ln)
  assert mt is not None
  return mt.group(1)

def extractAttribute(input, keys = None):
  if type(input) in [str, str]:
    toks = input.split("\t")
  elif type(input) is list:
    toks = input
  else:
    print("ERROR: Wrong input:", type(input))
    return dict()
  if keys is not None and type(keys) is not set:
    keys = set(keys)

  try:
    items = [list(map(methodcaller("strip"), tok.split("="))) for tok in toks]
    items = [pair for pair in items if keys is None or pair[0] in keys]
    return dict(items)
  except:
    print("ERROR: Wrong format:", input)
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
  dn  = logSum(list(map(weight.dot, fss)))
  pdw = array([0.0] * len(weight))
  for fs in fss:
    pdw += math.exp(weight.dot(fs) - dn) * fs
  return pdw

def renewGSS():
  executeCmd("kinit -R -k -t /home/txia/.ssh/txia.keytab txia@DC1.CORP.GD")

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


  data = createList([10])
  data[0] = 1
  print(data)

  data = createList([3, 4], None)
  data[0][0] = 1
  print(data)

  data = createList([3, 4, 5], None)
  data[0][0][0] = 1
  print(data)

  data = [("a", 1), ("a", 2), ("b", 3), ("c", 4)]
  print(list(groupByKey(iter(data))))

  print("general memory:", getMemory())

  print(eq(0, 0, EPSILON))
  print(eq(1.2345678912345678e30, 1.23456789123456689e30, 1e-13))

  dists = [1, 2, 3, 4]
  print(collections.Counter([discreteSample(dists) for freq in range(100000)]))

  toks = "name=TianXia\tage=16\theight=1.76".split("\t")
  print(list(extractAttribute(toks, set(["name"])).items()))
  print(list(extractAttribute(toks, set(["name", "age"])).items()))
  print(list(extractAttribute(toks).items()))

  relsList = []
  relsList.append([3, 2, 1] + [0] * 20 + [4] * 2)
  print("relsList:", relsList)
  print("ndcg:", calcNdcg(relsList))

  printFlush("hello", sys.stdout)

  executeCmd("ls")
  
  # sentBLEU = SentenceBLEU(["1 2 3 4", "1 3 4 5"], 2)
  # print("BLEU:", sentBLEU.compute("1 4 5"))

  ref1 = "a b c d 1 2 3 4 5 6 7 8 e"
  ref2 = "a b c d 1 2 3 4 5 6 7 8 e"
  ref3 = "a b c e 1 2 3 4 5 6 7 8 d"
  hyp  = "a b c e 1 2 3 4 5 6 7 e e"

  import nltk
  bleu = nltk.translate.bleu_score.sentence_bleu([ref1.split(),
                                                  ref2.split(),
                                                  ref3.split()],
                                                 hyp.split(),
                                                 [1, 1, 1])
  print(f"nltk BLEU: {bleu}")

  #todo
  sentBLEU = SentenceBLEU([ref1, ref2, ref3], 3)
  print(f"BLEU1:", sentBLEU.compute(hyp))

  '''lock1 = FileLock(1)
  print("Wait several seconds and delete /tmp/lock.data")
  lock2 = FileLock(1)
  print("lock2")
  lock2.unlock()'''


