import sys
import re
import os



if __name__ == '__main__':
        try:
##                os.system('mkdir -p IniMergedCards')
##                os.system('chmod 777 IniMergedCards.sh')
##                print "Executing IniMergedCards.sh."
##                os.system('./IniMergedCards.sh') 
##                print "Execute IniMergedCards.sh successfully."
                os.system('chmod 777 hql1.sh')
                os.system('./hql1.sh') 
                print "Execute hql1.sh successfully." 
 
                os.system('python MapByDict.py') 
                print "Execute MapByDict.py successfully."                 

                                                
                                                
        except Exception,e:
                print 'Error occurs.'
                print Exception,":",e

        finally:
                print 'Delete temp files.'
