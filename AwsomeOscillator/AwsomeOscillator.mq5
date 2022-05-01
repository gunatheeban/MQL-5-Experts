//+------------------------------------------------------------------+
//|                                             AwsomeOscillator.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>
CTrade trade;

int handler_first;
int handler_secound;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   handler_first=iAO(_Symbol,PERIOD_CURRENT);
   handler_secound=iAO(_Symbol,PERIOD_CURRENT);

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
   double hf[],hs[];
   CopyBuffer(handler_first,0,0,1,hf);
   CopyBuffer(handler_secound,0,0,1,hs);

  }
//+------------------------------------------------------------------+
