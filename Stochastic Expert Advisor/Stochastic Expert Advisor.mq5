//+------------------------------------------------------------------+
//|                                    Stochastic Expert Advisor.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>

input int k=5;
input int d=3;
input int s=3;

CTrade trade;
int totalBars;

input double lots = 0.1;

input int StochHireBound = 80;
input int StochLoverBound = 30;

input ENUM_MA_METHOD Ma = MODE_SMA;
input ENUM_STO_PRICE St = STO_LOWHIGH;

input int tp = 40;
input int sp = 20;

int handle;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
      handle = iStochastic(_Symbol,PERIOD_CURRENT,k,d,s,Ma,St);
      totalBars = iBars(_Symbol,PERIOD_CURRENT);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      double stoch[], signal[];
      CopyBuffer(handle,0,1,2,stoch); 
      CopyBuffer(handle,1,1,2,signal);
      
      double bars = iBars(_Symbol,PERIOD_CURRENT);
      
      if(totalBars != bars){
         totalBars = bars;
         
         if(stoch[1] > signal[1] && stoch[0] < signal[0]){
         
            if(stoch[1] <= StochLoverBound || signal[1] <= StochLoverBound){
            
               printf("Buy");
               
               double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
               ask = NormalizeDouble(ask,_Digits);
               
               double spPoint = ask - (sp * _Point);
               spPoint = NormalizeDouble(spPoint,_Digits);
               
               double tpPoint = ask + (tp * _Point);
               spPoint = NormalizeDouble(tpPoint,_Digits);
               
               trade.Buy(lots,_Symbol,ask,spPoint,spPoint,"ask\n"+ask+"\nTP:-\n"+tpPoint+"\nSP:-\n"+spPoint);
            
            }
         
         }else if(stoch[1] < signal[1] && stoch[0] > signal[0]){
         
            if(stoch[1] >= StochHireBound || signal[1] >= StochHireBound){
               printf("Sell");
               
               double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
               bid = NormalizeDouble(bid,_Digits);
               
               double spPoint = bid + sp * _Point;
               spPoint = NormalizeDouble(spPoint,_Digits);
               
               double tpPoint = bid - tp * _Point;
               tpPoint = NormalizeDouble(tpPoint,_Digits);
               
               trade.Sell(lots,_Symbol,bid,spPoint,tpPoint,"sell"+bid+"\nTP:- "+tpPoint+"\nSP:- "+spPoint);
               
            }
            
         }
      
      }
      
  }
//+------------------------------------------------------------------+
