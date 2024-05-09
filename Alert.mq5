
int barsTotal1,barsTotal5,barsTotal15,barsTotal30,barsTotal60;
double currentPrice;
bool signal; 
int maHandle;
int atrHandle;
double atr[];
int currentBars1;
int currentBars5;
int stoch1Handle;
double stoch1[], dline[];
int id;
datetime eventTime;
bool send;


int OnInit(){
   barsTotal1 = iBars(_Symbol,PERIOD_M1);
   barsTotal5 = iBars(_Symbol,PERIOD_M5);
   barsTotal15 = iBars(_Symbol,PERIOD_M15);
   barsTotal30 = iBars(_Symbol,PERIOD_M30);
   barsTotal60 = iBars(_Symbol,PERIOD_H1);
   currentBars1 = 0;
   id = 0;
   eventTime = TimeCurrent();
   send = false;
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason){
   Comment("Disconnected");
  }

void OnTick(){
     int currentBars15 = 0;
     int currentBars30 = 0;
     int currentBars60 = 0;
     
     double candleLow1 = iLow(_Symbol,PERIOD_M1,0);
     double candleHigh1 = iHigh(_Symbol,PERIOD_M1,0);
     double candleLow5 = iLow(_Symbol,PERIOD_M5,0);
     double candleHigh5 = iHigh(_Symbol,PERIOD_M5,0);
     double candleLow15 = iLow(_Symbol,PERIOD_M15,0);
     double candleHigh15 = iHigh(_Symbol,PERIOD_M15,0);
     double candleLow30 = iLow(_Symbol,PERIOD_M30,0);
     double candleHigh30 = iHigh(_Symbol,PERIOD_M30,0);
     double candleLow60 = iLow(_Symbol,PERIOD_H1,0);
     double candleHigh60 = iHigh(_Symbol,PERIOD_H1,0);
     double candleLow240 = iLow(_Symbol,PERIOD_H4,0);
     double candleHigh240 = iHigh(_Symbol,PERIOD_H4,0);
         
       crossOver();
       datetime currentTime = TimeCurrent();
       int timeDifference = (int)(currentTime - eventTime);
       int minutesPassed = timeDifference / 60;
       if(minutesPassed >= 5){
          OnInit();
       }
}

double getEma(int timeFrame,int count, int position) {
   double ma[];
   if (timeFrame == 1){
      maHandle = iMA(_Symbol,PERIOD_M1,count,0,MODE_EMA,PRICE_CLOSE);
   }
   if (timeFrame == 5){
      maHandle = iMA(_Symbol,PERIOD_M5,count,0,MODE_EMA,PRICE_CLOSE);
   }
   if (timeFrame == 10){
      maHandle = iMA(_Symbol,PERIOD_M10,count,0,MODE_EMA,PRICE_CLOSE);
   }
   if (timeFrame == 15){
      maHandle = iMA(_Symbol,PERIOD_M15,count,0,MODE_EMA,PRICE_CLOSE);
   }
   if (timeFrame == 30){
      maHandle = iMA(_Symbol,PERIOD_M30,count,0,MODE_EMA,PRICE_CLOSE);
   }
   if (timeFrame == 60){
      maHandle = iMA(_Symbol,PERIOD_H1,count,0,MODE_EMA,PRICE_CLOSE);
   }
   if (timeFrame == 240){
      maHandle = iMA(_Symbol,PERIOD_H4,count,0,MODE_EMA,PRICE_CLOSE);
   }
    CopyBuffer(maHandle,MAIN_LINE,0,3,ma);
    return ma[position];
}

bool isBullish(int count){
   double close = iClose(_Symbol,PERIOD_M5,count);
   double open = iOpen(_Symbol,PERIOD_M5,count);
   return close > open;
}

bool isBearish(int count){
   double close = iClose(_Symbol,PERIOD_M5,count);
   double open = iOpen(_Symbol,PERIOD_M5,count);
   return open > close;
}

void buy(){
   if(isBearish(2) && isBearish(1) && isBullish(0)){
      Print(_Symbol + " is possibly ready for buy");
      if(currentBars1 != barsTotal1){
           barsTotal1 = currentBars1;
           PlaySound("alert.wav");
           SendNotification(_Symbol + " is possibly ready for buy");
        }
   }
   if(isBullish(2) && isBearish(1) && isBullish(0)){
      Print(_Symbol + " is possibly ready for buy");
      if(currentBars1 != barsTotal1){
           barsTotal1 = currentBars1;
           PlaySound("alert.wav");
           SendNotification(_Symbol + " is possibly ready for buy");
        }
   }
}

void sell(){
   if(isBullish(2) && isBullish(1) && isBearish(0)){
      Print(_Symbol + " is possibly ready for sell");
      if(currentBars1 != barsTotal1){
           barsTotal1 = currentBars1;
           PlaySound("alert.wav");
           SendNotification(_Symbol + " is possibly ready for sell");
        }
   }
   if(isBearish(2) && isBullish(1) && isBearish(0)){
       Print(_Symbol + " is possibly ready for sell");
      if(currentBars1 != barsTotal1){
           barsTotal1 = currentBars1;
           PlaySound("alert.wav");
           SendNotification(_Symbol + " is possibly ready for sell");
        }
   }
}

void alert(){
   if(getEma(5,21,0) > getEma(5,50,0)){
      if(isBearish(1)){
         send = true;
         Print(_Symbol + " is possibly ready for buy");
         if(currentBars5 != barsTotal5){
              barsTotal5 = currentBars5;
              PlaySound("alert.wav");
              SendNotification(_Symbol + " is possibly ready for buy");
           }
      }
   } else {
      if(isBullish(1)){
         send = true;
         Print(_Symbol + " is possibly ready for sell");
         if(currentBars5 != barsTotal5){
              barsTotal5 = currentBars5;
              PlaySound("alert.wav");
              SendNotification(_Symbol + " is possibly ready for sell");
           }
      }
   }
}

void crossOver(){
     //15 minutes 
     if(getEma(15,14,1) < getEma(15,21,1) && getEma(15,14,0) > getEma(15,21,0)){
         Print(_Symbol + " moving averages is crossing over on the 1 minute");
         if(currentBars5 != barsTotal5){
              barsTotal5 = currentBars5;
              PlaySound("alert.wav");
              SendNotification(_Symbol + " moving averages is crossing over on the 1 minute");
           }
         }
         
      if(getEma(15,14,1) > getEma(15,21,1) && getEma(15,14,0) < getEma(15,21,0)){
         Print(_Symbol + " moving averages is crossing under on the 1 minute");
         if(currentBars5 != barsTotal5){
              barsTotal5 = currentBars5;
              PlaySound("alert.wav");
              SendNotification(_Symbol + " moving averages is crossing under on the 1 minute");
           }
         }
         //1 hour 
     if(getEma(60,14,1) < getEma(60,21,1) && getEma(60,14,0) > getEma(60,21,0)){
         Print(_Symbol + " moving averages is crossing over on the 1 minute");
         if(currentBars5 != barsTotal5){
              barsTotal5 = currentBars5;
              PlaySound("alert.wav");
              SendNotification(_Symbol + " moving averages is crossing over on the 1 minute");
           }
         }
         
      if(getEma(60,14,1) > getEma(60,21,1) && getEma(60,14,0) < getEma(60,21,0)){
         Print(_Symbol + " moving averages is crossing under on the 1 minute");
         if(currentBars5 != barsTotal5){
              barsTotal5 = currentBars5;
              PlaySound("alert.wav");
              SendNotification(_Symbol + " moving averages is crossing under on the 1 minute");
           }
         }
}

