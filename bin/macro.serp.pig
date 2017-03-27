---- macro 
--- SerpLoader
--- SerpFilter

DEFINE SerpLoader( IN_DIR, OUTPUT_TABLE )  RETURNS void { 

--- the schema must match the C table in etl.serp.logs.pig
$OUTPUT_TABLE = LOAD '$IN_DIR' USING PigStorage () AS (
    
     --- user tracking 
     shopperId : chararray,  ----     #1
     vguid     : chararray,

    --- timestamp
     timestamp     : long,   ---- #3
     datestamp     : chararray,
    
    --- split test ID
      splitId      : chararray,

    --- query & context
      rawQuery    : chararray,  --- ----     #6
      bundleSize    : int,
 
      language  :  chararray,   --------- #8
      currency  : chararray,     ---- #9  

      privateLabelId :  chararray,   ---- ----     #10
      company        : chararray,

      userIP    : chararray,
      callerIP    : chararray,

    ---- Geo
       latitude   : double,
       longitude  : double,   ---- ----     #15
 
       city   : chararray, --- ----     #16
       country    : chararray, --- ----     #17
       
       region   : chararray,  --- ----     #18
       countrySite  : chararray,  --- ----     #19

    --- exact match
      exactDomain : chararray,    ---- on 2015/01/07, this stores json blob like the following :    ----- #20

     ---- domain suggestions
      domain    : chararray,   ---- ----     #21
      score   : double,
      matchSource : chararray,             ---- #23
      price   : double,
      inventory   : chararray,
      position    : int,             -------- #26
      internalTierID  : chararray,
      punyDomainName  : chararray,

     ---- keyword suggestions
      recommendedKeywords : chararray,   ---- ----     #29

     ---- response time
       responseTime   : int,
       responseTimeAvail    : int,
       responseTimeWhiteList    : int,
       responseTimeSld    : int,
       responseTimeTld    : int,
       responseTimeTldCCTLD   : int,
       responseTimeDomainsBot   : int,

     ---- request url and version      
       url          : chararray,     ---- ----     #37
       version        : chararray,
       requestId      : chararray,      ---- #39
       dataVersion    : chararray,
       codeVersion    : chararray,

       apiRequest     : chararray,
       
       gdtimestamp      : chararray,     --- ----     #43

       ---- add the following on 2015/01/07
       recommended_tld  : chararray,       ---- ----     #44
       exact_domainName : chararray,
       exact_sld        : chararray,      
       exact_tld          : chararray,     
       exact_isBackorderable  : chararray,  --- true,false
       exact_isPurchasable    : chararray,  --- true,false    ---- #49

        --- add fields for a/b test, 2015/07/09
       experimentId :  chararray,       ---- ----     #50 
       num_buckets :  int,
       bucket_num : int ,
       is_test : chararray,
       domain_source : chararray,     ---- for suggested domain

       --- added 2015-08-24
       domain_serp_pfid : int,        --- for suggested domain #55
       visitor_guid : chararray,      ---- ----     #56 
       apiKey : chararray,            ---- ----     #57 
       tracking_id : chararray,

       --- added 2015-08-26
       shopper_active : int,
       shopper_strategy : chararray,    ---- ----     #60
       recommended_sld  : chararray,

       ---- added 2016-01-06
       findtype : chararray, ---- exact, serp, cctld : cctld displayed beneath the exact block  ---- #62
       findApiQuery : chararray                ---- ----     #63
);

};


DEFINE SerpCartPurchaseFunnelLoader( IN_DIR, OUTPUT_TABLE )  RETURNS void { 

--- the schema must match the C table in etl.serp.logs.pig
  $OUTPUT_TABLE = LOAD '$IN_DIR' USING PigStorage () AS (

    --- user tracking 
    shopperId : chararray,  ----     #1
    vguid     : chararray,

    --- timestamp
    timestamp     : long,   --- # 3
    datestamp     : chararray,

    --- split test ID
    splitId      : chararray,

    --- query & context
    rawQuery    : chararray,  --- ----     #6
    bundleSize    : int,

    language  :  chararray,   --------- #8
    currency  : chararray,     ---- #9  

    privateLabelId :  chararray,   ---- ----     #10
    company        : chararray,

    userIP    : chararray,
    callerIP    : chararray,

    ---- Geo
    latitude   : double,
    longitude  : double,   ---- ----     #15

    city   : chararray, --- ----     #16
    country    : chararray, --- ----     #17

    region   : chararray,  --- ----     #18
    countrySite  : chararray,  --- ----     #19

    --- exact match
    exactDomain : chararray,    ---- on 2015/01/07, this stores json blob like the following :    ----- #20

    ---- domain suggestions
    domain    : chararray,   ---- ----     #21
    score   : double,
    matchSource : chararray,
    price   : double,
    inventory   : chararray,
    position    : int,
    internalTierID  : chararray,
    punyDomainName  : chararray,

    ---- keyword suggestions
    recommendedKeywords : chararray,   ---- ----     #29

    ---- response time
    responseTime   : int,
    responseTimeAvail    : int,
    responseTimeWhiteList    : int,
    responseTimeSld    : int,
    responseTimeTld    : int,
    responseTimeTldCCTLD   : int,
    responseTimeDomainsBot   : int,

    ---- request url and version      
    url          : chararray,     ---- ----     #37
    version        : chararray,
    requestId      : chararray,      ---- #39
    dataVersion    : chararray,
    codeVersion    : chararray,

    apiRequest     : chararray,

    gdtimestamp      : chararray,     --- ----     #43

    ---- add the following on 2015/01/07
    recommended_tld  : chararray,       ---- ----     #44
    exact_domainName : chararray,
    exact_sld        : chararray,      
    exact_tld          : chararray,     
    exact_isBackorderable  : chararray,  --- true,false
    exact_isPurchasable    : chararray,  --- true,false    ---- #49

    --- add fields for a/b test, 2015/07/09
    experimentId :  chararray,       ---- ----     #50 
    num_buckets :  int,
    bucket_num : int ,
    is_test : chararray,
    domain_source : chararray,     ---- for suggested domain

    --- added 2015-08-24
    domain_serp_pfid : int,        --- for suggested domain #55
    visitor_guid : chararray,      ---- ----     #56 
    apiKey : chararray,            ---- ----     #57 
    tracking_id : chararray,

    --- added 2015-08-26
    shopper_active : int,
    shopper_strategy : chararray,    ---- ----     #60
    recommended_sld  : chararray,

    ---- added 2016-01-06
    findtype : chararray, ---- exact, serp, cctld0 : cctld displayed beneath the exact block  ---- #62
    findApiQuery : chararray  ,

    ---- for cart
    cart_flag : chararray ,    --- 64

    pf_id : chararray ,        --- 65
    price : chararray , 
    experimentId  : chararray,
    bucket_num   : int,  
    splitId        : chararray,      
    tracking_id    : chararray,      --- 70
    num_buckets : int, 

    findtype : chararray            ,  --- 72

    ---- for purchase
    purchae_flag : chararray,        --- 73

    order_id   :  chararray,
    shopperId  :  chararray,

    transaction_currency   :  chararray,
    transaction_adjusted_price   :  int,

    pf_id  :  int,

    quantity                      : int , 
    is_first_order                : chararray, ---- boolean --- 80 

    pnl_category :        chararray,  
    pnl_line : chararray          ----    82
  );
};

DEFINE SerpFilterByDateRange( IN_TABLE, OUT_TABLE , earliestdate, latestdate)  RETURNS void { 
       ---       A = foreach IN_TABLE generate
       ---     *,
  ---    (long) (CONCAT(SUBSTRING(datestamp,0,4), CONCAT(SUBSTRING(datestamp,5,7),SUBSTRING(datestamp,8,10)))) as _tmp_datestamp,
      
       $OUT_TABLE = filter $IN_TABLE by ((datestamp >= '$earliestdate') and (datestamp <= '$latestdate'));
};


DEFINE SerpFilterBySplitTestId( IN_TABLE, OUT_TABLE ,splitValue)  RETURNS void { 

     $OUT_TABLE = filter $IN_TABLE by (splitId == '$splitValue');

};

DEFINE CountSearchRequests( IN_TABLE, OUT_TABLE )  RETURNS void { 
---- calc total number of requests

$OUT_TABLE = foreach (group $IN_TABLE ALL) {
         D2 = foreach $IN_TABLE generate requestId, timestamp; 
   D3 = distinct D2;
        generate
         FLATTEN($IN_TABLE),   
         COUNT(D3) as totalRequests
   ;
   };
};

DEFINE CreateTotalSearchRequests( IN_TABLE, OUT_TABLE )  RETURNS void { 
---- faster implementation ?

A = foreach $IN_TABLE generate         * ,  (int) 1 as  tmpkey_totalreq;
B = foreach A generate requestId, timestamp , tmpkey_totalreq;
---C = distinct B parallel 100;
C = distinct B;
---D = group C by tmpkey_totalreq parallel 100;
D = group C by tmpkey_totalreq;
E = foreach D generate group as tmpkey_totalreq, COUNT(C) as totalRequests;
$OUT_TABLE = filter E by tmpkey_totalreq == 1;

};


DEFINE countFieldNumber( IN, OUT , FIELD )  RETURNS void { 
--- count the number of instance for the field
           A = group $IN by $FIELD;
     B = foreach A generate 
             FLATTEN($IN),
       COUNT($IN)  as cnt_$FIELD  --- the count for each field value
;
      $OUT = foreach B generate
          *
    ;
};

DEFINE countCoFields( IN, OUT , F1, F2 )  RETURNS void { 
--- count the number of instance for the F1 and F2
           A = group $IN by ($F1,$F2);
     B = foreach A generate 
             FLATTEN($IN),
       COUNT($IN)  as cnt_$F1$F2  --- the count for each field value
;
     $OUT = foreach B generate
          *
    ;
};
