%default    outdir   '/user/txia/query-history/purchase.mapping';

----------- purchase info -----------
table1 = LOAD 'godaddywebsitetraffic.visitorder_snap' USING org.apache.hive.hcatalog.pig.HCatLoader();
table1 = foreach table1 generate
  --- : chararray,  --- 89A151ED-67E2-4CE7-B91B-CA0859819D78 , same as guid in iowa search log
  TRIM(LOWER(visitguid)) as vguid,
  --- : chararray,   --- 599316066, same as order_id in ROD, order_ID in DI
  orderid as order_id
;

table2 = LOAD 'domains.domaininfo_snap' USING org.apache.hive.hcatalog.pig.HCatLoader();
table2 = foreach table2 generate
  order_id,
  shopper_id,
  TRIM(LOWER(domainname)) as domain_name
;

tableOut = join table1 by order_id, table2 by order_id;
tableOut = foreach tableOut generate
  table1::vguid as vguid,
  table2::domain_name as domain_name
;

tableOut = ORDER tableOut BY vguid;
store tableOut into '$outdir';

