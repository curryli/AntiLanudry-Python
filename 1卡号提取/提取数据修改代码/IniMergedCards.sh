hive -e "
set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
set mapred.max.split.size=1024000000;
set mapred.min.split.size.per.node=1024000000;
set mapred.min.split.size.per.rack=1024000000;


create table if not exists badaccounts(account string)
row format delimited fields terminated by '\001'
lines terminated by '\n';
load data local inpath 'BadCards.txt' into table badaccounts;

create table if not exists normalaccountsIn(account string);
insert overwrite table normalaccountsIn
select tfr_in_acct_no from tbl_common_his_trans
where trans_id='S33' and pdate>='20150301' and pdate<='20150401' and tfr_in_acct_no not in (
arlab.hmacmd5(reverse('1662.......')),
arlab.hmacmd5(reverse('1662........')),
arlab.hmacmd5(reverse('166..........')),
arlab.hmacmd5(reverse('166.........')),
arlab.hmacmd5(reverse('166.............')),
arlab.hmacmd5(reverse('166.............')),
arlab.hmacmd5(reverse('166..............')),
arlab.hmacmd5(reverse('166........')),
arlab.hmacmd5(reverse('1962.............')))order by rand() limit 100;

create table if not exists normalaccountsOut(account string);
insert overwrite table normalaccountsOut
select tfr_out_acct_no from tbl_common_his_trans
where trans_id='S33' and pdate>='20150301' and pdate<='20150401' and tfr_in_acct_no not in (
arlab.hmacmd5(reverse('1662.......')),
arlab.hmacmd5(reverse('1662........')),
arlab.hmacmd5(reverse('166..........')),
arlab.hmacmd5(reverse('166.........')),
arlab.hmacmd5(reverse('166.............')),
arlab.hmacmd5(reverse('166.............')),
arlab.hmacmd5(reverse('166..............')),
arlab.hmacmd5(reverse('166........')),
arlab.hmacmd5(reverse('1962...........')))order by rand() limit 100;
"

hive -e "insert overwrite local directory 'IniMergedCards'
select * from(
select * from badaccounts
union all
select * from normalaccountsIn
union all
select * from normalaccountsOut
) tmp;
"

hive -e "
drop table if exists badaccounts;
drop table if exists normalaccountsIn;
drop table if exists normalaccountsOut;
"
