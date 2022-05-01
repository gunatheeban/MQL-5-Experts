//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
CTrade trade;

int heandleTrandMaFast;
int heandleTrandMaSlow;

int heandleFast;
int heandleMiddle;
int heandleSlow;


input int TakeProfit = 40;
input int StopLoss = 20;
input double lots_point = 0.1;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   heandleTrandMaFast = iMA(_Symbol,PERIOD_H1,8,0,MODE_EMA,PRICE_CLOSE);
   heandleTrandMaSlow = iMA(_Symbol,PERIOD_H1,12,0,MODE_EMA,PRICE_CLOSE);

   heandleFast = iMA(_Symbol,PERIOD_M5,8,0,MODE_EMA,PRICE_CLOSE);
   heandleMiddle = iMA(_Symbol,PERIOD_M5,13,0,MODE_EMA,PRICE_CLOSE);
   heandleSlow = iMA(_Symbol,PERIOD_M5,21,0,MODE_EMA,PRICE_CLOSE);



   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {


  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

   double maFast[],maMiddle[],maSlow[];
   double maf[],mas[];


   CopyBuffer(heandleTrandMaFast,0,0,1,maf);
   CopyBuffer(heandleTrandMaSlow,0,0,1,mas);

   CopyBuffer(heandleFast,0,0,1,maFast);
   CopyBuffer(heandleMiddle,0,0,1,maMiddle);
   CopyBuffer(heandleSlow,0,0,1,maSlow);

   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   static double lastBid = bid;

   int trandDirection = 0;

   if(maf[0] > mas[0] && bid > maf[0])
     {
      trandDirection = 1;
     }
   else
      if(maf[0] < mas[0] && bid < maf[0])
        {
         trandDirection = -1;
        }

   if(trandDirection == 1)
     {

      if(maFast[0] > maMiddle[0] && maMiddle[0] > maSlow[0])
        {
         if(bid <= maFast[0] && lastBid > maFast[0])
           {
            Print("Buy");

            double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
            ask = NormalizeDouble(ask,_Digits);

            double spPoint = ask - (StopLoss * _Point);
            spPoint = NormalizeDouble(spPoint,_Digits);

            double tpPoint = ask + (TakeProfit * _Point);
            spPoint = NormalizeDouble(tpPoint,_Digits);

            trade.Buy(lots_point,_Symbol,ask,spPoint,spPoint,"ask\n"+ask+"\nTP:-\n"+tpPoint+"\nSP:-\n"+spPoint);

           }
        }
     }
   else
      if(trandDirection == -1)
        {
         if(maFast[0] < maMiddle[0] && maMiddle[0] < maSlow[0])
           {
            if(bid >= maFast[0] && lastBid < maFast[0])
              {
               Print("Sell");
               
               double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
               bid = NormalizeDouble(bid,_Digits);
               
               double spPoint = bid + StopLoss * _Point;
               spPoint = NormalizeDouble(spPoint,_Digits);
               
               double tpPoint = bid - TakeProfit * _Point;
               tpPoint = NormalizeDouble(tpPoint,_Digits);
               
               trade.Sell(lots_point,_Symbol,bid,spPoint,tpPoint,"sell"+bid+"\nTP:- "+tpPoint+"\nSP:- "+spPoint);
              }
           }
        }

   lastBid = bid;


   Comment("Fast MA:-"+DoubleToString(maf[0],_Digits),
           "\nSlow MA:-"+DoubleToString(mas[0],_Digits),
           "\nTrand Direction"+DoubleToString(trandDirection,_Digits),
           "\n",
           "\nFast MA",DoubleToString(maFast[0],_Digits),
           "\nMiddle MA",DoubleToString(maMiddle[0],_Digits),
           "\nSlow MA",DoubleToString(maSlow[0],_Digits));

  }
//+------------------------------------------------------------------+
