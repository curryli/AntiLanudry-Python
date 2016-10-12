hive -e"
create table if not exists mergedaccounts1 (account string);
load data local inpath 'SingleMergedCards1' into table mergedaccounts1;  

insert overwrite local directory 'round1'
select * from(  
select t1.tfr_in_acct_no, t1.tfr_out_acct_no
from tbl_common_his_trans t1
left semi join mergedaccounts1 t2
on t1.tfr_in_acct_no=t2.account
where t1.trans_id='S33' and t1.pdate>20150301 and t1.pdate<20150501
union all
select t1.tfr_in_acct_no, t1.tfr_out_acct_no
from tbl_common_his_trans t1
left semi join mergedaccounts1 t2
on t1.tfr_out_acct_no=t2.account
where t1.trans_id='S33' and t1.pdate>20150301 and t1.pdate<20150501) tmp1;

drop table if exists mergedaccounts1;"

