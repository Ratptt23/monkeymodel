//+------------------------------------------------------------------+
//|                                             MonkeyModel.mq5      |
//|         Custom Indicator: Center & Gravity Lines (Clean)        |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 DodgerBlue
#property indicator_color2 Crimson

double centerBuffer[];
double gravityBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, centerBuffer);
   SetIndexLabel(0, "Center");

   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, gravityBuffer);
   SetIndexLabel(1, "Gravity");

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int start = MathMax(prev_calculated - 1, 0);

   for (int i = start; i < rates_total; i++)
     {
      centerBuffer[i] = (high[i] + low[i]) / 2.0;

      double body = MathAbs(close[i] - open[i]);
      double upper = high[i] - MathMax(open[i], close[i]);
      double lower = MathMin(open[i], close[i]) - low[i];
      double body_center = (open[i] + close[i]) / 2.0;
      double total_energy = body + upper + lower;

      double weighted_sum = high[i] * upper + low[i] * lower + body_center * body;
      gravityBuffer[i] = (total_energy > 0) ? weighted_sum / total_energy : centerBuffer[i];
     }

   return(rates_total);
  }
//+------------------------------------------------------------------+
