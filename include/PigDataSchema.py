#!/usr/bin/env python
#coding: utf8

from algorithm import *

IMPRESSION_SCHEMA = [
  "shopperId", # impression : chararray,  ----     #1
  "vguid", # impression     : chararray,
  "timestamp", # impression     : long,   ---- #3
  "datestamp", # impression     : chararray,
  "splitId", # impression      : chararray,
  "rawQuery", # impression    : chararray,  --- ----     #6
  "bundleSize", # impression    : int,
  "language", # impression  :  chararray,   --------- #8
  "currency", # impression  : chararray,     ---- #9
  "privateLabelId", # impression :  chararray,   ---- ----     #10
  "company", # impression        : chararray,
  "userIP", # impression    : chararray,
  "callerIP", # impression    : chararray,
  "latitude", # impression   : double,
  "longitude", # impression  : double,   ---- ----     #15
  "city", # impression   : chararray, --- ----     #16
  "country", # impression    : chararray, --- ----     #17
  "region", # impression   : chararray,  --- ----     #18
  "countrySite", # impression  : chararray,  --- ----     #19
  "exactDomain", # impression : chararray,    ---- on 2015/01/07, this stores json blob like the following :    ----- #20
  "domain", # impression    : chararray,   ---- ----     #21
  "score", # impression   : double,
  "matchSource", # impression : chararray,             ---- #23
  "price", # impression   : double,
  "inventory", # impression   : chararray,
  "position", # impression    : int,             -------- #26
  "internalTierID", # impression  : chararray,
  "punyDomainName", # impression  : chararray,
  "recommendedKeywords", # impression : chararray,   ---- ----     #29
  "responseTime", # impression   : int,
  "responseTimeAvail", # impression    : int,
  "responseTimeWhiteList", # impression    : int,
  "responseTimeSld", # impression    : int,
  "responseTimeTld", # impression    : int,
  "responseTimeTldCCTLD", # impression   : int,
  "responseTimeDomainsBot", # impression   : int,
  "url", # impression          : chararray,     ---- ----     #37
  "version", # impression        : chararray,
  "requestId", # impression      : chararray,      ---- #39
  "dataVersion", # impression    : chararray,
  "codeVersion", # impression    : chararray,
  "apiRequest", # impression     : chararray,
  "gdtimestamp", # impression      : chararray,     --- ----     #43
  "recommended_tld", # impression  : chararray,       ---- ----     #44
  "exact_domainName", # impression : chararray,
  "exact_sld", # impression        : chararray,
  "exact_tld", # impression          : chararray,
  "exact_isBackorderable", # impression  : chararray,  --- true,false
  "exact_isPurchasable", # impression    : chararray,  --- true,false    ---- #49
  "experimentId", # impression :  chararray,       ---- ----     #50
  "num_buckets", # impression :  int,
  "bucket_num", # impression : int ,
  "is_test", # impression : chararray,
  "domain_source", # impression : chararray,     ---- for suggested domain
  "domain_serp_pfid", # impression : int,        --- for suggested domain #55
  "visitorGuid", # impression : chararray,      ---- ----     #56 up to 1 year life.
  "apiKey", # impression : chararray,            ---- ----     #57
  "tracking_id", # impression : chararray,
  "shopper_active", # impression : int,
  "shopper_strategy", # impression : chararray,    ---- ----     #60
  "recommended_sld", # impression  : chararray,
  "findtype", # impression : chararray, ---- exact, serp, cctld : cctld displayed beneath the exact block  ---- #62
  "findApiQuery" # impression : chararray                ---- ----     #63
]

CART_SCHEMA = [
  "vguid", # cart : chararray , --- #0
  "visitorGuid", # cart : chararray , --- #1
  "shopperId", # cart : chararray , --- #2
  "datestamp", # cart : chararray , --- #3
  "hourstamp", # cart : chararray , --- #4
  "timestamp", # cart : chararray , --- #5
  "pf_id", # cart : chararray , --- #6
  "domain", # cart : chararray , --- #7      ---- for bundle, it has more than one domains delimited by ','  Example: servicizer.net,servicizer.org,servicizer.info
  "sld", # cart : chararray , --- #8  ---- for bundle : servicizer  
  "tld", # cart : chararray , --- #9         ---- for bundle, it could be like net,org,info , Example: net,org,info
  "source", # cart : chararray , --- #10
  "matchSource", # cart : chararray , --- #11
  "position", # cart : int , --- #12
  "fullCheckAvail", # cart : chararray , --- #13
  "responseAvail", # cart : chararray , --- #14
  "filters", # cart : chararray , --- #15
  "filterPosition", # cart : chararray , --- #16
  "filtersValue", # cart : chararray , --- #17
  "eventtype", # cart : chararray , --- #18
  "usrin", # cart : chararray , --- #19
  "ads", # cart    : chararray , --- #20
  "FOSsplitId", # cart : chararray, --- #21   ---- Eg. 1410-2=510&1436-4=0&1194-4=174&1448-5=592&1455-2=599
  "language", # cart : chararray, --- #22
  "countrySite", # cart : chararray, --- #23
  "isc", # cart  : chararray, --- #24
  "userIP", # cart : chararray, --- #25
  "referer", # cart  : chararray, --- #26
  "userAgent", # cart  : chararray, --- #27 
  "price", # cart     : chararray, --- #28
  "rawQuery", # cart      : chararray, --- #29
  "apiKey", # cart   : chararray, --- #30
  "experimentId", # cart  : chararray, --- #31
  "bucket_num", # cart   : int,     --- #32
  "splitId", # cart        : chararray, --- #33  ---- A or B
  "tracking_id", # cart     : chararray, --- #34
  "num_buckets", # cart : int   ,  --- #35
  "findtype", # cart : chararray , --- #36      'exact', 'bundle', 'serp'
  "bundleSize", # cart : int,      --- #37      number of domains included in the bundle
  "currency", # cart : chararray ,
  "itc", # cart : chararray ,
  "market", # cart : chararray ,
  "last5search", # cart : chararray 
]

PURCHASE_INFO_MAPPING = ["vguid", "domain"]
#PURCHASE_INFO_MAPPING = ["vguid", "visitorGuid", domain"]

def readPigData(line, schemaList):
  values = line.split("\t")
  if len(values) == 0:
    return None
  return dict(zip(schemaList, values))

def showSchema(schema, title):
  print "-" * 30, title
  print "Index starts from 1"
  for p, attr in enumerate(schema):
    print p + 1, attr
  print
  print

if __name__ == "__main__":
  os.system("clear")

  parser = optparse.OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()

  showSchema(IMPRESSION_SCHEMA, "impression")

