#!/bin/bash

# 指标： 客户回头率,因为总表提取的刷卡数据就是一年的数据，所以此处where中就不做限定
# 源表： tbl_mchntsc_src
# 输出： tbl_mchntsc_year_customer_turn_head_rate1




# 源表： tbl_hqmsc_cardsum（一年商户的总卡量（顾客数））和tbl_mchntsc_year_customer_turn_head_rate1
# 输出： tbl_mchntsc_year_customer_turn_head_rate2

{
   hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_year_customer_turn_head_rate1' 
     select mchnt_cd, pri_acct_no_conv,count(*) as card_pay_num
   from tbl_mchntsc_src 
   where trim(mchnt_cd)<>'' and trim(pri_acct_no_conv) is not null
   group by mchnt_cd,pri_acct_no_conv
   order by mchnt_cd"  &&
   hive -e "create external table tbl_mchntsc_year_customer_turn_head_rate1 (
   mchnt_cd            string, 
   pri_acct_no_conv    string, 
   avg_single_trans    int

   )
   row format delimited fields terminated by '\001'
   location '/user/hdanaly/mchnt_score/in_mchntsc_year_customer_turn_head_rate1'"
   
   
   
   
      hive -e "insert overwrite directory 
   '/user/hdanaly/mchnt_score/in_mchntsc_year_customer_turn_head_rate2' 
     select t2.mchnt_cd, t1.cardsum,t2.cardsum_big_two,t2.cardsum_big_two/t1.cardsum as turn_head_rate
   from  (
          select mchnt_cd, count(*) as cardsum_big_two
          from tbl_mchntsc_year_customer_turn_head_rate1 
          where avg_single_trans>1
          group by mchnt_cd
        ) t2 
   join tbl_hqmsc_cardsum  t1 
   on t1.mchnt_cd = t2.mchnt_cd
   order by mchnt_cd"  &&
   hive -e "create external table tbl_mchntsc_year_customer_turn_head_rate2(
   mchnt_cd            string, 
   cardsum    int,
   cardsum_big_two    int,
   turn_head_rate    double

   )
   row format delimited fields terminated by '\001'
   location '/user/hdanaly/mchnt_score/in_mchntsc_year_customer_turn_head_rate2'"
   
   
   
}