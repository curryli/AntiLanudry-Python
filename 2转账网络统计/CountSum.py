import sys
import re
import os


def SumCount(filein,fileout):
        SumDict = {}
        CountDict = {}
        r = re.compile('\s')
        with open(filein,'r') as FILEIN:
##                n=0
                for line in FILEIN.readlines():
##                        print n
##                        n = n+1
                        ItemList = r.split(line)  #in, out, money, location, date
                        aIn = ItemList[0]
                        aOut = ItemList[1]
                        money = ItemList[2]
                        if aIn not in SumDict.keys():
                                SumDict[aIn] = int(money)
                        else:
                                SumDict[aIn] = SumDict[aIn] + int(money)
                        if aOut not in SumDict.keys():
                                SumDict[aOut] = int(money)
                        else:
                                SumDict[aOut] = SumDict[aOut] + int(money)

                        if aIn not in CountDict.keys():
                                CountDict[aIn] = 1
                        else:
                                CountDict[aIn] = CountDict[aIn] + 1
                        if aOut not in CountDict.keys():
                                CountDict[aOut] = 1
                        else:
                                CountDict[aOut] = CountDict[aOut] + 1
        print "Create Dict Done."
                                        
        with open(fileout,'w') as FILEOUT:
                for i in range (0,55455):
                        print >>FILEOUT, i, " ", SumDict[str(i)], " ", CountDict[str(i)]       
        print "Print File Done."        
        
if __name__ == '__main__':
        SumCount('MappedInOut.txt','SumCount.txt')

        

 
        
