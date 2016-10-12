hive -e"
create table if not exists mergedaccounts (account string);
load data local inpath 'IniMergedCards' into table mergedaccounts;  

insert overwrite local directory 'ResultIn'
select * from(  
select t1.tfr_in_acct_no, t1.tfr_out_acct_no, t1.trans_at, t1.pdate, t1.source_region_cd, t1.dest_region_cd
from tbl_common_his_trans t1
left semi join mergedaccounts t2
on t1.tfr_in_acct_no=t2.account
where t1.trans_id='S33' and t1.pdate>='20151002' and t1.pdate<='20151231'
order by t1.tfr_in_acct_no,t1.pdate
) tmp1;


insert overwrite local directory 'ResultOut'
select * from(  
select t1.tfr_in_acct_no, t1.tfr_out_acct_no, t1.trans_at, t1.pdate, t1.source_region_cd, t1.dest_region_cd
from tbl_common_his_trans t1
left semi join mergedaccounts t2
on t1.tfr_out_acct_no=t2.account
where t1.trans_id='S33' and t1.pdate>='20151002' and t1.pdate<='20151231'
order by t1.tfr_out_acct_no,t1.pdate
) tmp2;


drop table if exists mergedaccounts;
"

