//+------------------------------------------------------------------+
//|                                                   InvestBrothers |
//|                                      Copyright 2025, J&ABrothers |
//|                                         JPWarrior & AndrzWarrior |
//+------------------------------------------------------------------+
#ifndef ATOMS_FLOW_NEWBARDETECTOR_H
#define ATOMS_FLOW_NEWBARDETECTOR_H

//+------------------------------------------------------------------+
//| Clase: CNewBarDetector                                           |
//| Descripción: Detecta la formación de nuevas velas de forma       |
//| aislada, permitiendo múltiples instancias para distintos         |
//| símbolos y marcos temporales.                                    |
//+------------------------------------------------------------------+
class CNewBarDetector
  {
private:
   datetime           _lastBarTime; // Hora de apertura de la última vela
   string             _symbol;      // Símbolo a monitorear
   ENUM_TIMEFRAMES    _timeframe;   // Marco temporal en que se trabaja (Scalping M5)

public:
   //+------------------------------------------------------------------+
   //| Constructor por defecto                                          |
   //+------------------------------------------------------------------+
                     CNewBarDetector();

   //+------------------------------------------------------------------+
   //| Constructor personalizado                                        |
   //+------------------------------------------------------------------+
                     CNewBarDetector(const string symbol,
                   const ENUM_TIMEFRAMES timeframe);

   //+------------------------------------------------------------------+
   //| Destructor                                                       |
   //+------------------------------------------------------------------+
                    ~CNewBarDetector();

   //+------------------------------------------------------------------+
   //| Método: Reset                                                    |
   //| Fuerza que la próxima vela sea considerada nueva.               |
   //+------------------------------------------------------------------+
   void              Reset();

   //+------------------------------------------------------------------+
   //| Método: IsNewBar                                                 |
   //| Devuelve true si hay nueva vela en el símbolo/timeframe.        |
   //+------------------------------------------------------------------+
   bool              IsNewBar();

   //+------------------------------------------------------------------+
   //| Método: SetParams                                                |
   //| Reconfigura símbolo y timeframe, reinicializando el reloj.      |
   //+------------------------------------------------------------------+
   void              SetParams(const string symbol,
                               const ENUM_TIMEFRAMES timeframe);

   //+------------------------------------------------------------------+
   //| Método: GetLastBar                                               |
   //| Devuelve la última vela cerrada como MqlRates.                  |
   //+------------------------------------------------------------------+
   MqlRates          GetLastBar() const;
  };


#endif // ATOMS_FLOW_NEWBARDETECTOR_H

//+------------------------------------------------------------------+
