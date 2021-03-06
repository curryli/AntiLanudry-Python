#!/bin/bash

# 指标：商户日交易次数中值
# 简介：1/2
# 源表：tbl_mchntsc_day_sum_times_daynum_orderby_times
# 输出：tbl_mchntsc_times_med

{
  
     hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_day_sum_times_daynum_orderby_times' 
   select * from tbl_mchntsc_day_sum_times_daynum
   order by mchnt_cd,times"  &&
   hive -e "create external table tbl_mchntsc_day_sum_times_daynum_orderby_times (
   mchnt_cd            string, 
   loc_trans_dt        string, 
   sum                 double,
   times               int,
   daynum              int 
   )
   row format delimited fields terminated by '\001'
   location '/user/hdanaly/mchnt_score/in_mchntsc_day_sum_times_daynum_orderby_times'"
   
   
      hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_day_times_med' 
   select mchnt_cd, 
    percentile(cast(times as bigint), 0.5)  as med_day_times   
   from tbl_mchntsc_day_sum_times_daynum_orderby_times
   group by mchnt_cd"  &&
   
   hive -e "create  external table tbl_mchntsc_times_med (
   mchnt_cd    string,      
   med_day_times         double
   )
   row format delimited fields terminated by '\001'
   location '/user/hdanaly/mchnt_score/in_mchntsc_day_times_med'"
   
}