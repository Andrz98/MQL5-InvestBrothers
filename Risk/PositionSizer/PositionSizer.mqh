//+------------------------------------------------------------------+
//|                                                   InvestBrothers |
//|                                      Copyright 2025, J&ABrothers |
//|                                         JPWarrior & AndrzWarrior |
//+------------------------------------------------------------------+

#ifndef Atoms_RISK_POSITIONSIZER_H
#define Atoms_RISK_POSITIONSIZER_H

//+------------------------------------------------------------------+
//| Clase: PositionSizer                                             |
//| Descripción: Calcula el tamaño de posición basado en el riesgo   |
//| porcentual, el SL y el capital disponible.                       |
//| Modular y reutilizable para cualquier símbolo o timeframe.       |
//+------------------------------------------------------------------+
class PositionSizer
  {
private:
   string            _symbol;          // Símbolo a monitorear
   double            _balance;         // Para saber cúanto dinero hay disponible para calcular el riesgo
   double            _riskPercent;     // Por ejemplo: 1%, 2%, 0.5%
   double            _stopLossPoint;   // Para controlar el riesgo monetario con SL
   double            _tickValue;       // Para saber cuanto se gana o se pierde por punto
   double            _tickSize;        // Cuantos puntos conforma el tick
   double            _contractSize;    // Por ejemplo: 100.000 para forex, 100 para oro


public:
   //+------------------------------------------------------------------+
   //| Constructor: PositionSizer                                       |
   //| Inicializa símbolo, balance, % de riesgo y SL; obtiene datos     |
   //| del instrumento (tickSize, tickValue, contractSize) con API.     |
   //+------------------------------------------------------------------+

                     PositionSizer(const string symbol,
                 const double balance,
                 const double riskPercent,
                 const double stopLossPoints);


   //+----------------------------------------------------------------+
   //| Destructor:   ~ PositionSize                                   |
   //| Libera recursos asociados al handle (si fuera necesario).      |
   //+----------------------------------------------------------------+
                    ~ PositionSizer();


   //+------------------------------------------------------------------+
   //| Método: CalculateLotSize                                         |
   //| Calcula y devuelve el tamaño de lote ideal en base al SL y al    |
   //| riesgo permitido.                                                |
   //+------------------------------------------------------------------+
   double            CalculateLoteSize();


   //+------------------------------------------------------------------+
   //| Método: SetParams                                                |
   //| Permite reconfigurar los parámetros clave del objeto.            |
   //| Útil para reutilizar la instancia con otros símbolos o valores.  |
   //+------------------------------------------------------------------+
   void              SetParams(const string symbol,
                               const double balance,
                               const double riskPercent,
                               const double stopLossPoints);


  };

#endif //Atoms_RISK_POSITIONSIZER_H
//+------------------------------------------------------------------+
