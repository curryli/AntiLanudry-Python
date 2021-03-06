#!/bin/bash

# 指标：商户日消费金额中值
# 简介：1/2
# 源表：tbl_mchntsc_day_sum_times_daynum
# 输出：tbl_mchntsc_sum_med

{
   hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_day_sum_med' 
   select mchnt_cd, 
   percentile(cast(sum as bigint), 0.5)  as med_day_sum   
   from tbl_mchntsc_day_sum_times_daynum
   group by mchnt_cd"  &&
   
   hive -e "create external table tbl_mchntsc_sum_med (
   mchnt_cd    string,      
   med_day_sum         double
   )
   row format delimited fields terminated by '\001'
   location '/user/hdanaly/mchnt_score/in_mchntsc_day_sum_med'"
   
   
   
   
}