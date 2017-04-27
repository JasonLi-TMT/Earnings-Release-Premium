# -*- coding: utf-8 -*-
"""
Created on Sun Apr 16 12:55:36 2017

@author: ZISHUO LI
"""
import numpy as np
import pandas as pd
import os

os.getcwd()
os.chdir('C:\\Users\\ZISHUO LI\\Downloads\\project\\data\\observation\\')
obser_list=os.listdir()
num_c=len(obser_list)

DY=pd.read_csv(obser_list[0],header=None)
DY.shape
EBITG=pd.read_csv(obser_list[1],header=None)
EV2EBITDA=pd.read_csv(obser_list[2],header=None)
MARKET2BOOK=pd.read_csv(obser_list[3],header=None)
MOMENTUM=pd.read_csv(obser_list[4],header=None)
P2B=pd.read_csv(obser_list[5],header=None)
P2EARNINGSBEFOREABNORM=pd.read_csv(obser_list[6],header=None)
P2F=pd.read_csv(obser_list[7],header=None)
P2S=pd.read_csv(obser_list[8],header=None)
RETURN=pd.read_csv(obser_list[9],header=None)

file_name=[DY,EBITG,EV2EBITDA,MARKET2BOOK,MOMENTUM,P2B,P2EARNINGSBEFOREABNORM,P2F,P2S,RETURN]
file_str=['DY','EBITG','EV2EBITDA','MARKET2BOOK','MOMENTUM','P2B','P2EARNINGSBEFOREABNORM','P2F','P2S','RETURN']


for x in file_name:
    print (x.shape)

r=MOMENTUM.shape[0]


obser=[]
for i in range(r):
    for j in range(6):
        inter=[]
        for x in file_name:
            inter.append(x.iloc[i,j])
        obser.append(inter)


obser2=pd.DataFrame(obser)
obser2.shape

obser3=obser2.dropna(axis=0,how='any')

for i in range(obser3.shape[1]):
    obser3.iloc[:,i]=obser3.iloc[:,i]/sum(obser3.iloc[:,i].values)



obser3.columns=file_str
obser3.index=range(obser3.shape[0])

obser3.to_csv('long_before_earning.csv')

model=LinearRegression(fit_intercept=True)
model.fit(obser3.iloc[:,0:9],obser3.iloc[:,-1])
model.coef_

file_str

list(zip(model.coef_,file_str[0:9]))

''' the following is the 20 stocks '''
















