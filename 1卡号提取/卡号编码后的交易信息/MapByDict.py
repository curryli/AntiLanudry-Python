import sys
import re
import os
import datetime



def createCardDict(filein, fileout, CardDict):
        i = 0
        with open(filein,'r') as FILEIN:
                with open(fileout,'w') as FILEOUT:
                        for card in FILEIN.readlines():
                                print>>FILEOUT, card.strip(),"\t",i
                                CardDict[card.strip()] = i
                                i=i+1
                FILEOUT.close()                               
        FILEIN.close()


def createDateDict(start, end, fileout, DateDict):
    start_date = datetime.date(*start)
    end_date = datetime.date(*end)


    result = []
    curr_date = start_date
    while curr_date != end_date:
        result.append("%04d%02d%02d" % (curr_date.year, curr_date.month, curr_date.day))
        curr_date += datetime.timedelta(1)
    result.append("%04d%02d%02d" % (curr_date.year, curr_date.month, curr_date.day))

    i = 0
    with open(fileout,'w') as FILEOUT:
        for date in result:
            print>>FILEOUT, date,"\t",i
            DateDict[date] = i
            i=i+1

    FILEOUT.close()


def MergeTrans(filedir,fileoutname):
        NoneCRCpt =  re.compile('^((?!crc).)*$')
        fileList = os.listdir(filedir)

        os.system('rm -rf fileoutname')
        with open(fileoutname,'a+') as FILEOUT:
                for filename in fileList:
                        s1 = NoneCRCpt.search(filename)
                        if s1:
                                with open(filedir+filename,'r') as FILEIN:
                                        for line in FILEIN.readlines():
                                                print >>FILEOUT, line.strip()
                                
        
def MapFile(filein,fileout,CardDict,DateDict):
        r = re.compile('\001')
        with open(filein,'r') as FILEIN:
                with open(fileout,'w') as FILEOUT:
                        for line in FILEIN.readlines():
                                ItemList = r.split(line)  #in, out, money, location, date
                                dateId = DateDict[ItemList[4].strip()]
                                if CardDict.has_key(ItemList[0]):
                                        InId = CardDict[ItemList[0]]
                                        if CardDict.has_key(ItemList[1]):
                                                OutId = CardDict[ItemList[1]]
                                                print>>FILEOUT,InId,OutId,ItemList[2],ItemList[3],dateId
                                        

if __name__ == '__main__':
        filedirIN= os.path.abspath('.') + "/RelatedAsIn/"
        MergeTrans(filedirIN,"MergedIn.txt")
        filedirOUT= os.path.abspath('.') + "/RelatedAsIn/"
        MergeTrans(filedirOUT,"MergedOut.txt")
        CardDict = {}
        DateDict = {}
        
        createCardDict("AllCards.txt","AllCardDicts.txt",CardDict)
        createDateDict((2015, 3, 1), (2015, 5, 1),"DateDicts.txt",DateDict)
        
        MapFile('MergedIn.txt','MappedIn.txt',CardDict,DateDict)
        MapFile('MergedOut.txt','MappedOut.txt',CardDict,DateDict)

 
        
