import sys
import re
import os

def main():
    Cards=[]
    r = re.compile('\s+')
    CardSet = set()
    with open("tbl_arsvc_sus_card_trans.csv","r") as FILEIN:
            for line in FILEIN:
                ItemList = r.split(line)
		if len(ItemList)>2:
                	CardSet.add(ItemList[2][3:])
	
    with open("cardsout.csv","w") as FILEOUT:
	for card in CardSet:
		print>>FILEOUT,card 
    
if __name__ == "__main__":
    main()
