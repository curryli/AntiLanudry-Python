#!/bin/bash

# 指标：日消费金额中值、日度消费金额方差、日度消费次数方差
# 简介：统计每个商户的每日的交易总金额、交易总次数和交易天数
# 源表： tbl_mchntsc_day_sum_times
# 输出： tbl_mchnt_day_sum_times

{
   hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_day_sum_times_daynum' 
   select t1.mchnt_cd, t1.loc_trans_dt,t1.sum,t1.times,t2.day_num as daynum
   from (
          select mchnt_cd, count(*) as day_num
          from tbl_mchntsc_day_sum_times 
          group by mchnt_cd
        ) t2 
   join tbl_mchntsc_day_sum_times  t1
   on t1.mchnt_cd = t2.mchnt_cd
   order by mchnt_cd, sum,times"  &&
   hive -e "create external table tbl_mchntsc_day_sum_times_daynum (
   mchnt_cd            string, 
   loc_trans_dt        string, 
   sum                 double,
   times               int,
   daynum              int 
   )
   row format delimited fields terminated by '\001'
   location '/user/hdanaly/mchnt_score/in_mchntsc_day_sum_times_daynum'"
}