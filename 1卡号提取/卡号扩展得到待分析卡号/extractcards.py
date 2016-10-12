import sys
import re
import os


def ScanCards(filedir,times):
        NoneCRCpt =  re.compile('^((?!crc).)*$')
        CardSet = set()
        r = re.compile('\001')
        fileList = os.listdir(filedir)
        
        for filename in fileList:
                s1 = NoneCRCpt.search(filename)
                if s1:
                        with open(filedir+filename,'r') as FILEIN:
                                for line in FILEIN.readlines():
                                        Pair = r.split(line)
                                        if Pair[0].strip() not in CardSet:
                                                CardSet.add(Pair[0].strip())
                                        if Pair[1].strip() not in CardSet:
                                                CardSet.add(Pair[1].strip())
                        FILEIN.close()
                                                        
        with open("Single"+"MergedCards"+times,'w') as FILEOUT:
                for card in CardSet:
                        print >>FILEOUT, card
        
        FILEOUT.close()

def createHqlSh(hqlname,date_start,date_end):
        i = hqlname[-4]
        hqlstr = r'''hive -e"
create table if not exists mergedaccounts%s (account string);
load data local inpath 'SingleMergedCards%s' into table mergedaccounts%s;  

insert overwrite local directory 'round%s'
select * from(  
select t1.tfr_in_acct_no, t1.tfr_out_acct_no
from tbl_common_his_trans t1
left semi join mergedaccounts%s t2
on t1.tfr_in_acct_no=t2.account
where t1.trans_id='S33' and t1.pdate>%s and t1.pdate<%s
union all
select t1.tfr_in_acct_no, t1.tfr_out_acct_no
from tbl_common_his_trans t1
left semi join mergedaccounts%s t2
on t1.tfr_out_acct_no=t2.account
where t1.trans_id='S33' and t1.pdate>%s and t1.pdate<%s) tmp%s;

drop table if exists mergedaccounts%s;"
''' %(i,i,i,i,i,date_start,date_end,i,date_start,date_end,i,i)

        with open(hqlname,'w') as FILEOUT:
                print >>FILEOUT, hqlstr

        FILEOUT.close()

if __name__ == '__main__':
        try:
                os.system('mkdir -p IniMergedCards')
                os.system('chmod 777 IniMergedCards.sh')
                print "Executing IniMergedCards.sh."
                os.system('./IniMergedCards.sh') 
                print "Execute IniMergedCards.sh successfully." 
                filedir= os.path.abspath('.') + "/IniMergedCards/"
                ScanCards(filedir,"1")
                print "ScanCards IniMergedCards successfully."

                        
                N = 10                                 
                for i in range(1,N):
                        hqlname = "hql%d.sh"%(i)
                        createHqlSh(hqlname,'20150301','20150501')
                        print "Create hql%d.sh File successfully."%(i)
                        
                        os.system('mkdir -p round%d'%(i))
                        os.system('chmod 777 hql%d.sh'%(i))
                        print "Executing hql%d.sh."%(i)
                        os.system('./hql%d.sh'%(i))
                        print "Execute hql%d.sh successfully."%(i)
                        
                        filedir = os.path.abspath('.') + "/round%d/"%(i)
                        ScanCards(filedir,"%d"%(i+1))
                        print "ScanCards round%d successfully."%(i)

                os.system('mv SingleMergedCards%d AllCards.txt'%(N))
                print "Create AllCards.txt successfully."
                                

                                                
                                                
        except Exception,e:
                print 'Error occurs.'
                print Exception,":",e

        finally:
                #os.system('rm -rf hql*.sh')
                #os.system('rm -rf round*')
                print 'Delete temp files.'
