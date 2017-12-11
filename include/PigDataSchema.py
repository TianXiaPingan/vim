#!/usr/bin/env python
#coding: utf8

from algorithm import *

IMPRESSION_SCHEMA = [
  "shopperId", # : chararray,  ----     #1
  "vguid", #     : chararray,
  "timestamp", #     : long,   ---- #3
  "datestamp", #     : chararray,
  "splitId", #      : chararray,
  "rawQuery", #    : chararray,  --- ----     #6
  "bundleSize", #    : int,
  "language", #  :  chararray,   --------- #8
  "currency", #  : chararray,     ---- #9
  "privateLabelId", # :  chararray,   ---- ----     #10
  "company", #        : chararray,
  "userIP", #    : chararray,
  "callerIP", #    : chararray,
  "latitude", #   : double,
  "longitude", #  : double,   ---- ----     #15
  "city", #   : chararray, --- ----     #16
  "country", #    : chararray, --- ----     #17
  "region", #   : chararray,  --- ----     #18
  "countrySite", #  : chararray,  --- ----     #19
  "exactDomain", # : chararray,    ---- on 2015/01/07, this stores json blob like the following :    ----- #20
  "domain", #    : chararray,   ---- ----     #21
  "score", #   : double,
  "matchSource", # : chararray,             ---- #23
  "price", #   : double,
  "inventory", #   : chararray,
  "position", #    : int,             -------- #26
  "internalTierID", #  : chararray,
  "punyDomainName", #  : chararray,
  "recommendedKeywords", # : chararray,   ---- ----     #29
  "responseTime", #   : int,
  "responseTimeAvail", #    : int,
  "responseTimeWhiteList", #    : int,
  "responseTimeSld", #    : int,
  "responseTimeTld", #    : int,
  "responseTimeTldCCTLD", #   : int,
  "responseTimeDomainsBot", #   : int,
  "url", #          : chararray,     ---- ----     #37
  "version", #        : chararray,
  "requestId", #      : chararray,      ---- #39
  "dataVersion", #    : chararray,
  "codeVersion", #    : chararray,
  "apiRequest", #     : chararray,
  "gdtimestamp", #      : chararray,     --- ----     #43
  "recommended_tld", #  : chararray,       ---- ----     #44
  "exact_domainName", # : chararray,
  "exact_sld", #        : chararray,
  "exact_tld", #          : chararray,
  "exact_isBackorderable", #  : chararray,  --- true,false
  "exact_isPurchasable", #    : chararray,  --- true,false    ---- #49
  "experimentId", # :  chararray,       ---- ----     #50
  "num_buckets", # :  int,
  "bucket_num", # : int ,
  "is_test", # : chararray,
  "domain_source", # : chararray,     ---- for suggested domain
  "domain_serp_pfid", # : int,        --- for suggested domain #55
  "visitorGuid", # : chararray,      ---- ----     #56 up to 1 year life.
  "apiKey", # : chararray,            ---- ----     #57
  "tracking_id", # : chararray,
  "shopper_active", # : int,
  "shopper_strategy", # : chararray,    ---- ----     #60
  "recommended_sld", #  : chararray,
  "findtype", # : chararray, ---- exact, serp, cctld : cctld displayed beneath the exact block  ---- #62
  "findApiQuery" # : chararray                ---- ----     #63
]

PURCHASE_INFO_MAPPING = ["vguid", "domain"]

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

