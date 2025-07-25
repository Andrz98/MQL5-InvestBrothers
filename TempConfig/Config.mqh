//+------------------------------------------------------------------+
//|                                                   InvestBrothers |
//|                                      Copyright 2025, J&ABrothers |
//|                                         JPWarrior & AndrzWarrior |
//+------------------------------------------------------------------+

// #include "Atoms/TempConfig/Config.mqh" -> Para incluirlo en el EA principal.

// Para evitar duplicados de código ya activo en el EA, usamos #ifdef y #ifndef y el código solo se procesa una sola vez.

#ifndef ATOMS_TEMPCONFIG_CONFIG_H    // 1. Comprueba si NO está definido todavía
#define ATOMS_TEMPCONFIG_CONFIG_H    // 2. Lo define para evitar inclusiones posteriores

// Estructura de configuración global
struct SConfig
  {
   double            lotSize;      // Tamaño de lote por operación
   int               stopLoss;     // Stop Loss en puntos
   int               takeProfit;   // Take Profit en puntos
   ENUM_TIMEFRAMES   timeframe;   // Marco temporal (e.g. PERIOD_M5)
  };

#endif // ATOMS_TEMPCONFIG_CONFIG_H    // 3. Fin del include-guard


//+------------------------------------------------------------------+
