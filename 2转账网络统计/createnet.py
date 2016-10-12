import sys
import re
import os

def GetInOut(filein,fileout):
        r = re.compile('\s')
        with open(filein,'r') as FILEIN:
                with open(fileout,'w') as FILEOUT:
                        for line in FILEIN.readlines():
                                ItemList = r.split(line)  #in, out, money, location, date
                                print>>FILEOUT,ItemList[0],ItemList[1]

def createNet(filein,fileout):
        bset = set()
        r = re.compile('\s')
        with open(filein,'r') as FILEIN:    
                        for line in FILEIN.readlines():
                                ItemList = r.split(line)
                                ItemPair = (ItemList[0], ItemList[1])
                                if ItemPair not in bset:
                                        bset.add(ItemPair)
                                        
                                
        with open(fileout,'w') as FILEOUT:
                for x in bset:
                        print>>FILEOUT,x[0]," ",x[1]
        
if __name__ == '__main__':
        GetInOut('MappedInOut.txt','GetInOut.txt')
        createNet('GetInOut.txt','Net.txt')
        

 
        
