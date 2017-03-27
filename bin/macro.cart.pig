---- macro 
--- CartLoader

--- Created 2016/01/06

DEFINE CartLoader( IN_DIR, OUTPUT_TABLE )  RETURNS void { 

$OUTPUT_TABLE = LOAD '$IN_DIR' USING PigStorage () AS (
    
  vguid : chararray , --- #0
  visitor_guid : chararray , --- #1
  shopperId : chararray , --- #2

  datestamp : chararray , --- #3
  hourstamp : chararray , --- #4
  timestamp : chararray , --- #5

  pf_id : chararray , --- #6
  domain : chararray , --- #7      ---- for bundle, it has more than one domains delimited by ','  Example: servicizer.net,servicizer.org,servicizer.info
  sld : chararray , --- #8  ---- for bundle : servicizer  
  tld : chararray , --- #9         ---- for bundle, it could be like net,org,info , Example: net,org,info
  source : chararray , --- #10
  matchSource : chararray , --- #11
  position : int , --- #12
  fullCheckAvail : chararray , --- #13
  responseAvail : chararray , --- #14
  filters : chararray , --- #15
  filterPosition : chararray , --- #16
  filtersValue : chararray , --- #17

  eventtype : chararray , --- #18
  usrin : chararray , --- #19
  ads    : chararray , --- #20

  FOSsplitId : chararray, --- #21   ---- Eg. 1410-2=510&1436-4=0&1194-4=174&1448-5=592&1455-2=599
  language : chararray, --- #22
  countrySite : chararray, --- #23
  isc  : chararray, --- #24
            
  userIP : chararray, --- #25
  referer  : chararray, --- #26
  userAgent  : chararray, --- #27 

  ---- added 2015/08/24
  price     : chararray, --- #28

  rawQuery      : chararray, --- #29
  apiKey   : chararray, --- #30

  experimentId  : chararray, --- #31
  bucket_num   : int,     --- #32
  splitId        : chararray, --- #33  ---- A or B
  tracking_id     : chararray, --- #34
  num_buckets : int   ,  --- #35

  --- added 2016/01/06
  findtype : chararray , --- #36      'exact', 'bundle', 'serp'
  bundleSize : int,      --- #37      number of domains included in the bundle

  ---- added  2016/11/18
  currency : chararray ,
  itc : chararray ,
  market : chararray ,
  last5search : chararray 
);

};

----------------------
---- Use the following url to check the addToCart data
---- 1) http://img.godaddy.com/VisitDetails.aspx?visitguid=bc939ad6-5144-4a4c-ba05-0205e98bd6e4
---- 2) http://img.godaddy.com/VisitDetails.aspx

--------------------
--- * add exact results:

--- action,addToCart^pf_id,101^domain,well8larry.com^source,^matchSource,^position,0^fullCheckAvail,true^responseAvail,available^filters,[]^filtersValue,[]^Ad,^price,? 199.00^NameSearched,well8larry.com^findKey,dpp_search^ExperimentID,^BucketNumber,^SplitSide,^TrackingId,^NumberOfBuckets,

-----------------------
--- * add bundle results:

--- action,addToCart^domain,well8larry.net,well8larry.org,well8larry.info^position,0^fullCheckAvail,false^filters,[]^filtersValue,[]^^savingstext,66%^price,? 1,157.00^NameSearched,well8larry.com^findKey,dpp_search^^^^^

-------------------------
---- * add cctld (maki pos=0) results: (no way to distinguish this)

---- action,addToCart^pf_id,11601^domain,well8well.us^source,cctld^matchSource,e.ccb^position,1^fullCheckAvail,true^responseAvail,available^filters,[]^filtersValue,[]^Ad,false^price,$2.99^NameSearched,well8well.com^findKey,dpp_search^ExperimentID,^BucketNumber,^SplitSide,^TrackingId,^NumberOfBuckets,

------------------------
----- * add cctld at serp
---- action,addToCart^pf_id,9850^domain,well8larry.in^source,cctld^matchSource,e.ccb^position,1^fullCheckAvail,true^responseAvail,available^filters,[]^filtersValue,[]^Ad,false^price,? 99.00^NameSearched,well8larry.com^findKey,dpp_search^ExperimentID,^BucketNumber,^SplitSide,^TrackingId,^NumberOfBuckets,

-------------------------
------ * serp clicks
----- action,addToCart^pf_id,334499^domain,well8larry.xyz^source,extension^matchSource,e.g^position,14^fullCheckAvail,true^responseAvail,available^filters,[]^filtersValue,[]^Ad,false^price,? 199.00^NameSearched,well8larry.com^findKey,dpp_search^ExperimentID,^BucketNumber,^SplitSide,^TrackingId,^NumberOfBuckets,

