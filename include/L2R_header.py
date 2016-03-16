#!/usr/bin/env python

from algorithm import *

class Url:
  FEAT_NUM  = None      # must be set manually.
  URL_SIZE  = 0

  def __init__(self, ln):
    toks     = ln[: ln.rfind("#")].split()
    self.score   = 0
    self.grade   = int(toks[0])
    self.feats   = array([0.0] * Url.FEAT_NUM)
    for tok in toks[2:]:
      fid, f = tok.split(":")
      self.feats[int(fid)] = float(f)
    self.qid   = toks[1]
    self.idx   = Url.URL_SIZE
    Url.URL_SIZE += 1

  @staticmethod
  def read_data(fname):
    data = defaultdict(list)
    urls = map(Url, open(fname))
    for url in urls:
      data[url.qid].append(url)
    print "In %s, #query: %d, #urls: %d, #average: %d" %(fname, len(data.keys()), len(urls), float(len(urls)) / len(data.keys()))
    data = data.values()
    data.sort(key = lambda urls: urls[0].idx)
    return data

  @staticmethod
  def calc_per_dcg(urls):
    '''return dcg[11], an array.
    '''
    norm = lambda pos: log(pos + 2)
    dcg  = [(2 ** u.grade - 1) / norm(i) for i, u in enumerate(urls[: 10])]
    dcg  = [0.0] + dcg + [0.0] * (10 - len(dcg))
    for p in xrange(1, 11):
      dcg[p] += dcg[p - 1]
    return array(dcg) + ZERO  

  @staticmethod
  def update_score(urls, weight):
    for url in urls:
      url.score = weight.dot(url.feats)
    urls.sort(key = lambda u: (-u.score, u.idx))

  @staticmethod
  def calc_per_ndcg(urls, idcgs = {}):
    '''return ndcg[order=0..10]
      'Do NOT use the 'idcgs' parameter, which is used as a static variable in C++.
    '''
    hashv = urls[0].qid 
    if hashv not in idcgs:
      cp_urls = copy(urls)
      cp_urls.sort(key = lambda u: -u.grade)
      idcgs[hashv] = Url.calc_per_dcg(cp_urls)
    
    norm  = idcgs[hashv]
    ret   = Url.calc_per_dcg(urls) / norm 
    return ret 

  @staticmethod
  def print_ndcg(ndcg):
    '''ndcg: array[11]
    '''
    ret = ["ndcg@%d %s" %(od, str(round(ndcg[od], 4))) for od in xrange(1, 11)] 
    return " ".join(ret)

if __name__ == "__main__":
  parser = OptionParser(usage = "cmd [options] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose", default = False, help = "don't print status messages to stdout")
  parser.add_option("-d", "--data",  dest = "fname",    help = "")
  (options, args) = parser.parse_args()

  Url.FEAT_NUM = 46
  data = Url.read_data(options.fname)
  print "ndcg:", Url.print_ndcg(Url.calc_ndcg(data, array([1.0] * Url.FEAT_NUM)))
  print "ndcg:", Url.print_ndcg(Url.calc_ndcg(data, array([random() for freq in xrange(Url.FEAT_NUM)])))
