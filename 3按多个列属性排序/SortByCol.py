import sys
import re
import os
import csv

    
      
def MapInFile(filein,fileout):
        with open(filein,'r') as FILEIN:
                data = csv.reader(FILEIN, delimiter=' ')
                sortedlist = sorted(data, key = lambda x:(int(x[0]), int(x[3])) )  
  
        with open(fileout,'w') as FILEOUT:
                fileWriter = csv.writer(FILEOUT, delimiter=' ')
                for row in sortedlist:
                        fileWriter.writerow(row)


def MapOutFile(filein,fileout):
        with open(filein,'r') as FILEIN:
                data = csv.reader(FILEIN, delimiter=' ')
                sortedlist = sorted(data, key = lambda x:(int(x[1]), int(x[3])) )  
  
        with open(fileout,'w') as FILEOUT:
                fileWriter = csv.writer(FILEOUT, delimiter=' ')
                for row in sortedlist:
                        fileWriter.writerow(row)

def RemoveSpace(filein,fileout):
        with open(filein,'r') as FILEIN:
                with open(fileout,'w') as FILEOUT:
                        for line in FILEIN.readlines():
                                if line:
                                        print>>FILEOUT, line.strip()
                
                        
if __name__ == '__main__':
        MapInFile('ResultIn.txt','SortedIn.txt')
        RemoveSpace('SortedIn.txt','SortedInNew.txt')
        MapOutFile('ResultOut.txt','SortedOut.txt')
        RemoveSpace('SortedOut.txt','SortedOutNew.txt')

 
        
