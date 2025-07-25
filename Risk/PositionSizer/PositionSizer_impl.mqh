//+------------------------------------------------------------------+
//|                                                   InvestBrothers |
//|                                      Copyright 2025, J&ABrothers |
//|                                         JPWarrior & AndrzWarrior |
//+------------------------------------------------------------------+
#include "PositionSizer.mqh"

//+------------------------------------------------------------------+
//| Constructor: PositionSizer                                       |
//| Inicializa _symbol, _balance, _riskPercent y _stopLossPoint;     |
//| obtiene tickSize, tickValue y contractSize desde el símbolo.     |
//+------------------------------------------------------------------+
PositionSizer::PositionSizer(const string symbol,
                             const double balance,
                             const double riskPercent,
                             const double stopLossPoints)
  {
   _symbol           = symbol;
   _balance          = balance;
   _riskPercent      = riskPercent;
   _stopLossPoint    = stopLossPoints;

// Obtener tamaño de tick
   if(!SymbolInfoDouble(_symbol, SYMBOL_TRADE_TICK_SIZE, _tickSize))
      Print("Error: no se pudo obtener SYMBOL_TRADE_TICK_SIZE para ", _symbol);

// Obtener valor del tick
   if(!SymbolInfoDouble(_symbol, SYMBOL_TRADE_TICK_VALUE, _tickValue))
      Print("Error: no se pudo obtener SYMBOL_TRADE_TICK_VALUE para ", _symbol);

// Obtener tamaño del contrato
   if(!SymbolInfoDouble(_symbol, SYMBOL_TRADE_CONTRACT_SIZE, _contractSize))
      Print("Error: no se pudo obtener SYMBOL_TRADE_CONTRACT_SIZE para ", _symbol);
  }

//+------------------------------------------------------------------+
//| Destructor: ~PositionSizer                                       |
//| Destructor vacío. Estructura incluida por coherencia de diseño.  |
//+------------------------------------------------------------------+
PositionSizer::~PositionSizer()
  {
// No se requiere liberación de recursos.
  }

//+------------------------------------------------------------------+
//| Método: CalculateLotSize                                         |
//| Calcula el tamaño de lote ideal según el SL, el balance y el     |
//| % de riesgo permitido. Devuelve el lotaje como double.           |
//+------------------------------------------------------------------+
double PositionSizer::CalculateLotSize(void)
  {
// 1-> Calculamos el riesgo monetario permitido:
   double riskMoney = _balance * (_riskPercent / 100.0);

// 2-> Calculamos la perdida por lote si alcanza el SL
   double lossPerLot = (_stopLossPoint * _tickValue) / _tickSize;

// 2.1 -> Incluimos una validación defensiva para evitar división por cero
   if(lossPerLot <= 0.0)
     {
      Print("Error: pérdida por lote <= 0. Verifica tickValue, tickSize y SL.");
      return 0.0;
     }

// 3-> Dividir el riesgo monetario por la pérdida por lote
   double lotSize = riskMoney / lossPerLot;


   return lotSize;
  }


//+------------------------------------------------------------------+
//| Método: SetParams                                                |
//| Permite reconfigurar el objeto sin reinstanciarlo. Actualiza     |
//| símbolo, balance, riesgo y SL; consulta nuevamente propiedades.  |
//+------------------------------------------------------------------+
void PositionSizer::SetParams(const string symbol,
                              const double balance,
                              const double riskPercent,
                              const double stopLossPoints)
  {
   _symbol           = symbol;
   _balance          = balance;
   _riskPercent      = riskPercent;
   _stopLossPoint    = stopLossPoints;

// Actualización de propiedades del símbolo
   if(!SymbolInfoDouble(_symbol, SYMBOL_TRADE_TICK_SIZE, _tickSize))
      Print("Error: no se pudo obtener SYMBOL_TRADE_TICK_SIZE para ", _symbol);

   if(!SymbolInfoDouble(_symbol, SYMBOL_TRADE_TICK_VALUE, _tickValue))
      Print("Error: no se pudo obtener SYMBOL_TRADE_TICK_VALUE para ", _symbol);

   if(!SymbolInfoDouble(_symbol, SYMBOL_TRADE_CONTRACT_SIZE, _contractSize))
      Print("Error: no se pudo obtener SYMBOL_TRADE_CONTRACT_SIZE para ", _symbol);

  }

//+------------------------------------------------------------------+