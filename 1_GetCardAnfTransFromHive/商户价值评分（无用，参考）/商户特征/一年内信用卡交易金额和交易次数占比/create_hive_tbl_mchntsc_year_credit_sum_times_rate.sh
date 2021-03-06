#!/bin/bash

# 指标： 商户信用卡交易金额和交易次数占比,因为总表提取的刷卡数据就是一年的数据，所以此处where中就不做限定

# 说明： 商户交易金额和交易次数总量
# 源表： tbl_mchntsc_src
# 输出： tbl_mchntsc_year_credit_sum_times_rate1

# 说明： 商户信用卡交易金额和交易次数占比
# 源表： tbl_mchntsc_year_credit_sum_times_rate1和（信用卡交易金额和交易次数临时表）
# 输出： tbl_mchntsc_year_credit_sum_times_rate2


{
   hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_year_credit_sum_times_rate1' 
     select mchnt_cd, sum(trans_at) as totle_sum, count(*) as totle_times
   from tbl_mchntsc_src 
   where trim(mchnt_cd)<>'' and trim(pri_acct_no_conv) is not null  and trim(card_attr_b) is not null
   group by mchnt_cd
   order by mchnt_cd"  &&
   hive -e "create external table tbl_mchntsc_year_credit_sum_times_rate1 (
   mchnt_cd        string, 
   totle_sum       double, 
   totle_times     int

   )
   row format delimited fields terminated by '\001'
   location '/user/hdanaly/mchnt_score/in_mchntsc_year_credit_sum_times_rate1'"
   
   
   
   
      hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_year_credit_sum_times_rate2' 
     select t1.mchnt_cd, t1.totle_sum,t2.credit_sum,t2.credit_sum/t1.totle_sum as credit_sum_rate,t1.totle_times,t2.credit_times,t2.credit_times/t1.totle_times as credit_times_rate 
     from  (
           select mchnt_cd, sum(trans_at) as credit_sum, count(*) as credit_times
            from tbl_mchntsc_src 
            where trim(mchnt_cd)<>'' 
                   and trim(pri_acct_no_conv) is not null  and trim(card_attr_b)='02' 
            group by mchnt_cd
        ) t2 
   join tbl_mchntsc_year_credit_sum_times_rate1  t1 
   on t1.mchnt_cd = t2.mchnt_cd
   order by mchnt_cd"  &&
   hive -e "create external table tbl_mchntsc_year_credit_sum_times_rate2(
   mchnt_cd            string, 
   totle_sum    double,
   credit_sum    double,
   credit_sum_rate    double,
   totle_times    int,
   credit_times    int,
   credit_times_rate    double

   )
   row format delimited fields terminated by '\001'
   location '/user/hdanaly/mchnt_score/in_mchntsc_year_credit_sum_times_rate2'"
   
   
   
}