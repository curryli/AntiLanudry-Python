import sys
import re
import os
import datetime


def createPeriodDicts(PeriodDicts):
        n=0
        for i in range(0,365):
                PeriodDicts[n] = i/10 + 1
                n = n+1
                
                

def static(filein,fileout,PeriodDicts):
        r = re.compile('\s')
        with open(filein,'r') as FILEIN:
                with open(fileout,'w') as FILEOUT:
                        
                        count = 0
                        moneysum = 0
                        lastCardId = 0
                        lastPeriod = 0
                        lastCount = 0
                        lastMoneysum = 0
                        
                        for line in FILEIN.readlines():
                                ItemList = r.split(line)  #in, out, money, date, src, des
                                if filein == "SortedIn.txt":
                                        cardId = int(ItemList[0].strip())
                                else:
                                        cardId = int(ItemList[1].strip())
                                        
                                money = int(ItemList[2].strip())
                                dateId = int(ItemList[3].strip())
                                period = PeriodDicts[int(dateId)]

                                if cardId == lastCardId:
                                        if period == lastPeriod:
                                                count = count+1
                                                moneysum = moneysum + money
                                                
                                        else:
                                                print>>FILEOUT, lastCardId, lastPeriod, moneysum, count   #卡号, 时间段，金额，次数
                                                count = 1
                                                moneysum = money
                                     

                                else:
                                        print>>FILEOUT, lastCardId, lastPeriod, lastMoneysum, lastCount
                                        count = 1
                                        moneysum = money
                                        
                                lastCardId = cardId
                                lastPeriod = period
                                lastMoneysum = moneysum
                                lastCount = count
                                        
                                        
                                        

if __name__ == '__main__':
        PeriodDicts = {}
        createPeriodDicts(PeriodDicts)
        static("SortedIn.txt","NewSortedIn.txt",PeriodDicts)
        static("SortedOut.txt","NewSortedOut.txt",PeriodDicts)


        

 
        
