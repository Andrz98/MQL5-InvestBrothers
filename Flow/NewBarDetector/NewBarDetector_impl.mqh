//+------------------------------------------------------------------+
//|                                                   InvestBrothers |
//|                                      Copyright 2025, J&ABrothers |
//|                                         JPWarrior & AndrzWarrior |
//+------------------------------------------------------------------+
#include "NewBarDetector.mqh"

//+------------------------------------------------------------------+
//| Constructor: CNewBarDetector                                     |
//| Inicializa símbolo y timeframe definidos por el usuario.         |
//| Carga el tiempo de la última vela conocida.                      |
//+------------------------------------------------------------------+
CNewBarDetector::CNewBarDetector(const string symbol, const ENUM_TIMEFRAMES timeframe)
  {
   _symbol        = symbol;
   _timeframe     = timeframe;
   _lastBarTime   = iTime(_symbol, _timeframe, 0);
  }

//+------------------------------------------------------------------+
//| Constructor por defecto                                          |
//| Utiliza el símbolo y periodo del gráfico activo.                 |
//+------------------------------------------------------------------+
CNewBarDetector::CNewBarDetector()
  {
   _symbol        = _Symbol;
   _timeframe     = PERIOD_CURRENT;
   _lastBarTime   = iTime(_symbol, _timeframe, 0);
  }

//+------------------------------------------------------------------+
//| Destructor: ~CNewBarDetector                                     |
//| Destructor vacío. Se mantiene por coherencia estructural.        |
//+------------------------------------------------------------------+
CNewBarDetector::~CNewBarDetector()
  {
   // No hay recursos que liberar.
  }

//+------------------------------------------------------------------+
//| Método: Reset                                                    |
//| Fuerza que la próxima llamada a IsNewBar() devuelva true.        |
//+------------------------------------------------------------------+
void CNewBarDetector::Reset()
  {
   _lastBarTime = 0;
  }

//+------------------------------------------------------------------+
//| Método: IsNewBar                                                 |
//| Devuelve true si hay nueva vela en el símbolo/timeframe.        |
//+------------------------------------------------------------------+
bool CNewBarDetector::IsNewBar()
  {
   MqlRates rates[1];

   // Intentar obtener la última vela
   if(CopyRates(_symbol, _timeframe, 0, 1, rates) != 1)
     {
      Print(__FUNCTION__,
            ": CopyRates failed for symbol=", _symbol,
            " timeframe=", EnumToString(_timeframe),
            ", error code=", GetLastError());
      return false;
     }

   // Comparar con la última vela registrada
   if(rates[0].time != _lastBarTime)
     {
      _lastBarTime = rates[0].time;
      return true;
     }

   return false;
  }

//+------------------------------------------------------------------+
//| Método: SetParams                                                |
//| Permite reconfigurar símbolo y timeframe sin reinstanciar.       |
//+------------------------------------------------------------------+
void CNewBarDetector::SetParams(const string symbol, const ENUM_TIMEFRAMES timeframe)
  {
   _symbol        = symbol;
   _timeframe     = timeframe;
   _lastBarTime   = iTime(_symbol, _timeframe, 0);
  }

//+------------------------------------------------------------------+
//| Método: GetLastBar                                               |
//| Devuelve la última vela cerrada como MqlRates.                  |
//+------------------------------------------------------------------+
MqlRates CNewBarDetector::GetLastBar() const
  {
   MqlRates bar[1];
   if(CopyRates(_symbol, _timeframe, 1, 1, bar) != 1)
     {
      Print(__FUNCTION__, ": Error al obtener la última vela cerrada.");
      // Devolver objeto vacío si falla
      MqlRates empty = {};
      return empty;
     }

   return bar[0];
  }
