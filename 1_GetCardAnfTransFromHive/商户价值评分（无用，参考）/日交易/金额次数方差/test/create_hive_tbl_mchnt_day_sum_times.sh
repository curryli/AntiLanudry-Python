#!/bin/bash

# 指标：日消费金额中值、日度消费金额方差、日度消费次数方差
# 简介：统计每个商户的每日的交易总金额、交易总次数
# 源表： tbl_mchntsc_src
# 输出： tbl_mchnt_day_sum_times

{
   hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_day_sum_times' 
   select mchnt_cd, loc_trans_dt, sum(trim(trans_at)) as sum, count(*) as times
   from tbl_mchntsc_src 
   where trim(mchnt_cd) is not NULL
   group by mchnt_cd, loc_trans_dt
   order by mchnt_cd, sum,times"  &&
   hive -e "create external table tbl_mchntsc_day_sum_times (
   mchnt_cd            string, 
   loc_trans_dt        string, 
   sum                 double,
   times               int  
   )
   row format delimited fields terminated by '\001'
   location '/user/hdanaly/mchnt_score/in_mchntsc_day_sum_times'"
}