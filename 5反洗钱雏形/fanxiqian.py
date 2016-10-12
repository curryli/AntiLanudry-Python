#coding=gbk
import networkx as nx
import math
#import matplotlib.pyplot as plt
from numpy import array,mean,std,exp
import re

N=55455
G=nx.Graph()
for i in range(0,N):   #�����ڵ�
    G.add_node(i)


r = re.compile('\s+')
ff=open('Net.txt','r')
for line in ff.readlines():
    ItemList = r.split(line)
    ItemList[0]=int(ItemList[0])
    ItemList[1]=int(ItemList[1])
    G.add_edge(ItemList[0],ItemList[1])   #�����ڵ�֮������ӱ�
ff.close()




r = re.compile('\s+')
ff=open('SumCount.txt','r')
money=[]
frequency=[]
for line in ff.readlines():
    ItemList = r.split(line)
    money.append(ItemList[1])          #���
    frequency.append(ItemList[2])      #����
ff.close()

#pos=nx.random_layout(G)
#nx.draw(G,pos,with_labels=False,node_size=1)
#plt.show()

for i in range(0,len(money)):
    money[i]=float(money[i])/100.0
    frequency[i]=float(frequency[i])

aver_money=mean(money)               #���ƽ��ֵ����׼�����ƽ��ֵ����׼��
aver_frequency=mean(frequency)
std_money=std(money)
std_frequency=std(frequency)

#for i in range(0,len(money)):
#    money[i]=money[i]/sum(money)
#    frequency[i]=frequency[i]/sum(frequency)

for i in range(0,N):
    G.add_node(i,money1=(money[i]-aver_money)/std_money)     #����׼��
    G.add_node(i,frequency1=(frequency[i]-aver_frequency)/std_frequency)   #������׼��
    money_frequency=-(money[i]*frequency[i])*math.log((money[i]*frequency[i]),2)
#    G.add_node(i,key1=(G.node[i]['money1']* G.node[i]['frequency1']))    #�ڵ�Ŀ��ɺ���ֵ
#    G.add_node(i,key1=money_frequency)    #�ڵ�Ŀ��ɺ���ֵ
    G.add_node(i,key1=(G.node[i]['money1']+ G.node[i]['frequency1']+G.node[i]['money1']* G.node[i]['frequency1']))    #�ڵ�Ŀ��ɺ���ֵ


k=range(0,N)
for i in range(0,N):
    k[i]= G.node[i]['key1']
key=list(k)
f=mean(key)                 #���ɺ���ƽ��ֵ
std_f=std(key)              #���ɺ�����׼��
#print f,std_f


X=range(0,N)    #����1
Social_number=0
Ck={}
NN=0



#while(X):
for cycle in range(0,N):
    if len(X)==0:
        break
    k=range(0,len(X))   #����2
    for i in range(0,len(X)):
        k[i]= G.node[X[i]]['key1']
    key=list(k)
    max_index=key.index(max(key))
    C=[X[max_index]]
    C=set(C).union(G.neighbors(X[max_index]))
    C=list(C)
    fc=0
    U=[]
    for i in C:
        U=set(U).union(G.neighbors(i))
    U=set(U)-set(C)
    U=list(U)
    for i in C:
        fc=fc+G.node[i]['key1']
    fc=fc/len(C)
    print fc-f
    if fc<f:
        X=set(X)-set(C)
        X=list(X)
        U=[]
        C=[]
    else:
        #print U
        if (not U):   #�������
            Social_number+=1
            Ck[Social_number]=C
            X=set(X)-set(C)
            X=list(X)
            C=list(C)
            C=[]          
        while(U):         #����4
            f_U=range(0,len(U))
            for j in range(0,len(U)):
                f_U[j]= G.node[U[j]]['key1']
            j_max=U[ f_U.index(max(f_U))]
            #print G.node[j_max]['key1'],f
            if G.node[j_max]['key1']<f:
                Social_number+=1
                Ck[Social_number]=C
                X=set(X)-set(U)-set(C)
                X=list(X)                   
                U=list(U)
                U=[]
                C=list(C)
                C=[]
            else:
                new_fc=(len(C)*fc+ G.node[j_max]['key1'])/(len(C)+1)
                #print new_fc,f
                if new_fc<f:           # ����5
                    Social_number+=1
                    Ck[Social_number]=C
                    X=set(X)-set(C)
                    X=list(X)
                    U=list(U)
                    U=[]
                    C=list(C)
                    C=[]         #���ز���2����ΪU=[]
                else:
                    #print j_max
                    #print abs(new_fc-fc)-std_f
                    if abs(new_fc-fc)>std_f:
                        jj_max=[j_max]
                        U=set(U)-set(jj_max)
                        U=list(U)    #�������
                        if ( not U):      # ����6
                            Social_number+=1
                            Ck[Social_number]=C
                            X=set(X)-set(C)
                            X=list(X)
                            C=list(C)
                            U=[]
                            C=[]     #���ز���2����ΪU=[]                       
                    else:
                        jj_max=[j_max]
                        C=set(C).union(set(jj_max))
                        C=list(C)
                        U=[]
                        for i in C:
                            U=set(U).union(G.neighbors(i))
                        U=set(U)-set(C)
                        U=list(U) 
                        #print len(U)
                        #print len(C)
                        #U=set(U)-set(jj_max)
                        #print len(U)
                        #U=list(U)                        
                        #U=set(U).union(G.neighbors(j_max))
                        #U=set(U)-set(jj_max)
                        #print G.neighbors(j_max)
                        #U=list(U)
                        #print len(U)
                        if ( not U):      # ����7
                            Social_number+=1
                            Ck[Social_number]=C
                            X=set(X)-set(C)
                            X=list(X)
                            C=list(C)
                            U=[]
                            C=[]     #���ز���2����ΪU=[]
    NN+=1
    #print X[1],X[2],len(X)
    print Social_number,NN
    #print Ck[2]

print Social_number
print Ck
