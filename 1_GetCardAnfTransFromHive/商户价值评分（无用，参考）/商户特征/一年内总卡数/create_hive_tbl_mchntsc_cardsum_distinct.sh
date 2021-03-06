#!/bin/bash

# 简介： 商户一年内总卡量，因为总表提取的刷卡数据就是一年的数据，所以此处where中就不做限定
# 源表： tbl_mchntsc_src
# 输出： tbl_hqmsc_cardnum_distinct
#  
# 
# 源表： tbl_hqmsc_cardnum_distinct
# 输出： tbl_hqmsc_cardsum

{
hive -e "insert overwrite directory '/user/hdanaly/mchnt_score/in_hqmsc_cardnum_distinct'
   select distinct mchnt_cd,pri_acct_no_conv from tbl_mchntsc_src 
   where trim(mchnt_cd)<>'' and trim(pri_acct_no_conv) is not null
   order by mchnt_cd,pri_acct_no_conv"  &&
   
hive -e "
   create external table tbl_hqmsc_cardnum_distinct (
    mchnt_cd            string,
    pri_acct_no_conv    string
   )
    row format delimited fields terminated by '\001'
    location '/user/hdanaly/mchnt_score/in_hqmsc_cardnum_distinct'"
    
    
hive -e "insert overwrite directory '/user/hdanaly/mchnt_score/in_hqmsc_cardsum'
   select mchnt_cd,count(*) as cardsum from tbl_hqmsc_cardnum_distinct 
   group by mchnt_cd"  &&
   
hive -e "create external table tbl_hqmsc_cardsum (
    mchnt_cd            string,
    cardsum    int
   )
    row format delimited fields terminated by '\001'
    location '/user/hdanaly/mchnt_score/in_hqmsc_cardsum'"
 
}