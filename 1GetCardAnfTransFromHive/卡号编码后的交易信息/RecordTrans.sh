hive -e"create table if not exists allaccounts(account string);
load data local inpath 'AllCards.txt' into table allaccounts;

insert overwrite local directory 'RelatedAsIn'
select t1.tfr_in_acct_no, t1.tfr_out_acct_no, t1.trans_at, t1.source_region_cd, t1.pdate
from tbl_common_his_trans t1
left semi join allaccounts t2
on t1.tfr_in_acct_no=t2.account
where t1.trans_id='S33' and t1.pdate>'20150301' and pdate<'20150501';

insert overwrite local directory 'RelatedAsOut'
select t1.tfr_in_acct_no, t1.tfr_out_acct_no, t1.trans_at, t1.source_region_cd, t1.pdate
from tbl_common_his_trans t1
left semi join allaccounts t2
on t1.tfr_out_acct_no=t2.account
where t1.trans_id='S33' and t1.pdate>'20150301' and pdate<'20150501';

drop table if exists allaccounts;"
