hive -e"
create table if not exists mergedaccounts (account string);
load data local inpath 'cardsoutlen.txt' into table mergedaccounts;  

insert overwrite local directory 'Cards'
select arlab.hmacmd5(reverse(account)) from mergedaccounts;


drop table if exists mergedaccounts;"

