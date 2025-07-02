
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#property indicator_chart_window

#property indicator_buffers 6
#property indicator_plots   3

#property indicator_type1 DRAW_LINE
#property indicator_type2 DRAW_LINE
#property indicator_type3 DRAW_LINE
#property indicator_type4 DRAW_NONE
#property indicator_type5 DRAW_NONE
#property indicator_type6 DRAW_NONE

#property indicator_color1 clrSlateGray
#property indicator_color2 clrDodgerBlue
#property indicator_color3 clrFireBrick

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double buffer0[], buffer1[], buffer2[], buffer3[], buffer4[], buffer5[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int OnInit() {

   SetIndexBuffer(0, buffer0);
   SetIndexBuffer(1, buffer1);
   SetIndexBuffer(2, buffer2);
   SetIndexBuffer(3, buffer3);
   SetIndexBuffer(4, buffer4);
   SetIndexBuffer(5, buffer5);

   return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void OnDeinit(const int reason) {
   //---
   //---
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void OnChartEvent(const int id, const long &lparam,
                  const double &dparam, const string &sparam) {
   //---
   //---
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[], const double &open[],
                const double &high[], const double &low[],
                const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[]) {

   if (!prev_calculated) {

      double val = (high[0] + low[0] + close[0]) / 3.0;
      double vol = (double)fmax(tick_volume[0], 1);

      buffer3[0] = vol * val * val;
      buffer4[0] = vol * val;
      buffer5[0] = vol;

      buffer0[0] = buffer4[0] / buffer5[0];

      double dev = sqrt(fmax((buffer3[0] / buffer5[0]) - (buffer0[0] * buffer0[0]), 0));

      buffer1[0] = buffer0[0] + dev;
      buffer2[0] = buffer0[0] - dev;

   }

   for (int i = (prev_calculated ? prev_calculated - 1 : 1); rates_total > i; i++) {

      double val = (high[i] + low[i] + close[i]) / 3.0;
      double vol = (double)fmax(tick_volume[i], 1);

      if (TimeDay(time[i - 1]) != TimeDay(time[i])) {

         buffer3[i] = vol * val * val;
         buffer4[i] = vol * val;
         buffer5[i] = vol;

         PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, i);
         PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, i);
         PlotIndexSetInteger(2, PLOT_DRAW_BEGIN, i);

      } else {

         buffer3[i] = buffer3[i - 1] + (vol * val * val);
         buffer4[i] = buffer4[i - 1] + (vol * val);
         buffer5[i] = buffer5[i - 1] + vol;

      }

      buffer0[i] = buffer4[i] / buffer5[i];

      double dev = sqrt(fmax((buffer3[i] / buffer5[i]) - (buffer0[i] * buffer0[i]), 0));

      buffer1[i] = buffer0[i] + dev;
      buffer2[i] = buffer0[i] - dev;
   }

   return (rates_total);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int TimeDay(datetime dt) {

   MqlDateTime dt_struct;
   TimeToStruct(dt, dt_struct);

   return (dt_struct.day);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
