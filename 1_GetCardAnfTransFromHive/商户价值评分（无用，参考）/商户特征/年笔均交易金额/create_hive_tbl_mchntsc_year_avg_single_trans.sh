#!/bin/bash

# 指标：商户年笔均交易金额,因为总表提取的刷卡数据就是一年的数据，所以此处where中就不做限定
# 源表： tbl_mchntsc_src
# 输出： tbl_mchntsc_year_avg_single_trans

{
   hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_year_avg_single_trans' 
   select mchnt_cd, avg(trans_at) as avg_single_trans
   from tbl_mchntsc_src 
   where trim(mchnt_cd)<>'' and trim(pri_acct_no_conv) is not null
   group by mchnt_cd"  &&
   hive -e "create external table tbl_mchntsc_year_avg_single_trans (
   mchnt_cd            string, 
   avg_single_trans    double

   )
   row format delimited fields terminated by '\001'
   location '/user/hdanaly/mchnt_score/in_mchntsc_year_avg_single_trans'"
}