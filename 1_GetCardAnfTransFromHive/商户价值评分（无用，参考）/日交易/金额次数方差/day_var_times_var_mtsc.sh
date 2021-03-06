#!/bin/bash

# 指标：日消费金额中值、日度消费金额方差、日度消费次数方差


# 简介：统计每个商户的每日的交易总金额、交易总次数,此处是否需要对数据量进行限定
# 源表： tbl_mchntsc_src
# 输出： tbl_mchnt_day_sum_times

{
   hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_day_sum_times' 
   select mchnt_cd, loc_trans_dt, sum(trim(trans_at)) as sum, count(*) as times
   from tbl_mchntsc_src 
   where trim(mchnt_cd) is not NULL
   group by mchnt_cd, loc_trans_dt    ##根据商户标识和交易日期进行group。获得同一商户同一日期的信息
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




# 简介：日消费金额中值、日度消费金额方差、日度消费次数方差
# 源表： tbl_mchntsc_day_sum_times_daynum
# 输出： tbl_mchntsc_var_times_var

{
   hive -e "insert overwrite directory 
	'/user/hdanaly/mchnt_score/in_mchntsc_var_times_var' 
			select mchnt_cd, 
       variance(sum)      as   var_sum_day, 
       variance(times)    as   var_times_day,
       avg(sum) as avg_sum_day,
       avg(times) as avg_times_day
       
			from tbl_mchntsc_day_sum_times_daynum
			group by mchnt_cd"  &&
   hive -e "create external table tbl_mchntsc_var_times_var (
				mchnt_cd            string, 
				var_sum_day         double,
				var_times_day       double,
				avg_sum_day         double,
				avg_times_day       double	
			)
			row format delimited fields terminated by '\001'
			location '/user/hdanaly/mchnt_score/in_mchntsc_var_times_var'"
}