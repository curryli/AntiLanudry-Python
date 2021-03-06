#!/bin/bash

# 简介： 商户评分源表，数据源:pdate>'20130531' and pdate<'20140601'
# 源表： tbl_common_his_trans_success
# 输出： tbl_mchntsc_src

{
hive -e "insert overwrite directory '/user/hdanaly/mchnt_score/in_mchntsc_src'
  select mchnt_cd, mchnt_tp, pri_acct_no_conv, card_attr_b, total_disc_at, trans_at,   loc_trans_tm, loc_trans_dt ,pdate
  from tbl_common_his_trans_success
  where trim(mchnt_cd)<>'' and trim(pri_acct_no_conv) is not null and pdate>'20130531' and pdate<'20140601'"  &&
hive -e "
   create external table tbl_mchntsc_src (
    mchnt_cd            string,
    mchnt_tp            string,
    pri_acct_no_conv    string,
    card_attr_b         string,
    total_disc_at       string,
    trans_at            string,
    loc_trans_tm        string,
    loc_trans_dt        string,
    pdate               string
       )
    row format delimited fields terminated by '\001'
    location '/user/hdanaly/mchnt_score/in_mchntsc_src'"

}