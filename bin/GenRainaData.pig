---- add to cart info from search log
%default date    '2016-09';

%default inputView        '/user/hdp_find/pipeline/serp.daily/view/$date*';
%default inputCart        '/user/hdp_find/pipeline/serp.daily/cart/$date*';
%default inputPurchase    '/user/txia/query-history/purchase.mapper'
%default outputDir        '/user/txia/query-history/serp.cart.purchase.history/$date.30.2'

IMPORT 'macro.serp.pig';
IMPORT 'macro.cart.pig';

SET pig.noSplitCombination false;

------ serp data ----
SerpLoader('$inputView', tableView);

tableView = FOREACH tableView GENERATE
  TRIM(LOWER(vguid)) as vguid,      --- 20 minutes duration.
  shopperId,
  datestamp,
  timestamp,
  countrySite,
  country as geo,
  TRIM(LOWER(rawQuery)) as rawQuery,
  TRIM(LOWER(domain)) as domain,
  position,
  exactDomain,
  matchSource,
  apiKey,     
  latitude,
  longitude,
  city,
  findApiQuery,
  shopper_strategy,
  visitor_guid
;

-- keep 'dpp_search' and not include exact match results.
/*tableView = FILTER tableView BY (apiKey == 'dpp_search') AND (vguid is not null) AND (position is not null and position != 0 and position<=30);*/
tableView = FILTER tableView BY (apiKey == 'dpp_search') AND (vguid is not null) AND (position is not null and position != 0);
-- Tian: should not limit to top 30.

-- get serp count, number of searches for one specific query in the same session.
-- Tian: if one query search crosses two sessions?
tableSerp = FOREACH (GROUP tableView BY (vguid, rawQuery)) GENERATE
    group AS id,
    FLATTEN(tableView.(vguid,rawQuery,datestamp,timestamp)) AS (vguid,rawQuery,datestamp,timestamp);
    -- Tian: meaning?
tableSerp = DISTINCT tableSerp;

tableSerpCount = FOREACH (GROUP tableSerp BY id) GENERATE
    FLATTEN(tableSerp.(vguid,rawQuery,datestamp,timestamp)) AS (vguid,rawQuery,datestamp,timestamp),
    COUNT(tableSerp.id) AS serp_cnt;

-- append serp count to table
tableView1 = JOIN tableView BY (vguid,rawQuery,datestamp,timestamp) LEFT, tableSerpCount BY (vguid,rawQuery,datestamp,timestamp);

tableView1 = foreach tableView1 generate
  tableView::vguid AS vguid,
  tableView::shopperId AS shopperId,
  tableView::datestamp AS datestamp,
  tableView::timestamp AS timestamp,
  tableView::countrySite AS countrySite,
  tableView::geo AS geo,
  tableView::rawQuery AS rawQuery,
  tableView::domain AS domain,
  tableView::position AS position,
  tableView::exactDomain AS exactDomain,
  tableView::matchSource AS matchSource,
  tableView::apiKey AS apiKey,
  tableSerpCount::serp_cnt AS serp_cnt,
  tableView::latitude as latitude,
  tableView::longitude as longitude,
  tableView::city as city,
  tableView::findApiQuery as findApiQuery,
  tableView::shopper_strategy as shopper_strategy,
  tableView::visitor_guid as visitor_guid
;

------- add to cart data --------
CartLoader('$inputCart', tableCart);
tableCart = FOREACH tableCart GENERATE
  TRIM(LOWER(vguid)) as vguid,
  TRIM(LOWER(rawQuery)) as rawQuery,
  TRIM(LOWER(domain)) as domain,
  position as position,
  (int)1 as cart,
  eventtype,
  ads,
  findtype,
  experimentId,
  splitId,
  price,
  currency
;

tableView2 = JOIN tableView1 BY (vguid,rawQuery,domain,position) LEFT, tableCart BY (vguid,rawQuery,domain,position);
--DESCRIBE tableView2;

tableView3 = foreach tableView2 generate
  tableView1::vguid as vguid,
  tableView1::shopperId as shopperId,
  tableView1::datestamp as datestamp,
  tableView1::timestamp as timestamp,
  tableView1::countrySite as countrySite,
  tableView1::geo as geo,
  tableView1::rawQuery as  rawQuery,
  tableView1::exactDomain as  exactDomain,
  tableView1::domain as domain,
  tableView1::position as position ,
  tableView1::matchSource as matchSource,
  tableView1::apiKey as apiKey,
  tableView1::serp_cnt as serp_cnt,
  tableCart::eventtype as eventtype,
  tableCart::ads as ads,
  tableCart::findtype as findtype,
  (int) (tableCart::cart is null ? 0 : 1) as added,
  tableView1::latitude as latitude,
  tableView1::longitude as longitude,
  tableView1::city as city,
  tableView1::findApiQuery as findApiQuery,
  tableView1::shopper_strategy as shopper_strategy,
  tableView1::visitor_guid as visitor_guid,
  tableCart::experimentId as experimentId,
  tableCart::splitId as splitId,
  tableCart::price as price,
  tableCart::currency as currency
;

tableView4 = FOREACH (GROUP tableView3 BY (vguid,rawQuery,datestamp,timestamp)) GENERATE
  FLATTEN(tableView3),
  SUM(tableView3.added) AS addToCart_cnt;
tableView4 = FILTER tableView4 BY (addToCart_cnt!=0);

tableView4 = foreach tableView4 generate
  tableView3::vguid as vguid,
  tableView3::shopperId as shopperId,
  tableView3::datestamp as datestamp,
  tableView3::timestamp as timestamp,
  tableView3::countrySite as countrySite,
  tableView3::geo as geo,
  tableView3::rawQuery as rawQuery,
  tableView3::exactDomain as exactDomain,
  tableView3::domain as domain,
  tableView3::position as position,
  tableView3::matchSource as matchSource,
  tableView3::apiKey as apiKey,
  tableView3::serp_cnt as serp_cnt,
  tableView3::eventtype as eventtype,
  tableView3::ads as ads,
  tableView3::findtype as findtype,
  tableView3::added as added,
  tableView3::latitude as latitude,
  tableView3::longitude as longitude,
  tableView3::city as city,
  tableView3::findApiQuery as findApiQuery,
  tableView3::shopper_strategy as shopper_strategy,
  tableView3::visitor_guid as visitor_guid,
  addToCart_cnt as addToCart_cnt,
  tableView3::experimentId as experimentId,
  tableView3::splitId as splitId,
  tableView3::price as price,
  tableView3::currency as currency
;

----------- purchase info -----------
tablePurchase = load '$inputPurchase' using PigStorage() as (
  vguid,
  domain_name
);

tableOut = join tableView4 by (vguid,domain) left, tablePurchase by (vguid,domain_name);

tableOut = foreach tableOut generate
  tableView4::vguid as vguid,
  tableView4::shopperId as shopperId,
  tableView4::datestamp as datestamp,
  tableView4::timestamp as timestamp,
  tableView4::countrySite as countrySite,
  tableView4::geo as geo,
  tableView4::rawQuery as  rawQuery,
  tableView4::exactDomain as  exactDomain,
  tableView4::domain as domain,
  tableView4::position as position ,
  tableView4::matchSource as matchSource,
  tableView4::apiKey as apiKey,
  tableView4::serp_cnt as serp_cnt,
  tableView4::eventtype as eventtype,
  tableView4::ads as ads,
  tableView4::findtype as findtype,
  tableView4::added  as added,
  tableView4::latitude as latitude,
  tableView4::longitude as longitude,
  tableView4::city as city,
  tableView4::findApiQuery as findApiQuery,
  tableView4::shopper_strategy as shopper_strategy,
  tableView4::visitor_guid as visitor_guid,
  tableView4::addToCart_cnt as addToCart_cnt,
  (tablePurchase::domain_name is null or tablePurchase::domain_name==''? 0:1) as purchased,
  tableView4::experimentId as experimentId,
  tableView4::splitId as splitId,
  tableView4::price as price,
  tableView4::currency as currency
;

tableOut = ORDER tableOut BY datestamp, vguid, rawQuery, timestamp, position;
store tableOut into '$outputDir';

