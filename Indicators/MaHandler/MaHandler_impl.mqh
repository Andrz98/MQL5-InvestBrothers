//+------------------------------------------------------------------+
//|                                                   InvestBrothers |
//|                                      Copyright 2025, J&ABrothers |
//|                                         JPWarrior & AndrzWarrior |
//+------------------------------------------------------------------+
#include "MaHandler.mqh"

//+------------------------------------------------------------------+
//| Constructor: CMaHandler                                          |
//| Inicializa _symbol, _period y _timeframe; setea _handle a        |
//| INVALID_HANDLE.                                                  |
//+------------------------------------------------------------------+
CMaHandler::CMaHandler(const string symbol,
                       const int period,
                       const ENUM_TIMEFRAMES timeframe)
  {
   _symbol     = symbol;
   _period     = period;
   _timeframe  = timeframe;
   _maMethod   = MODE_SMA;        // Valor por defecto (configurable luego con SetParams)
   _handle     = INVALID_HANDLE;
  }

//+------------------------------------------------------------------+
//| Destructor: ~CMaHandler                                          |
//| Libera recursos asociados al handle (si fuera necesario).        |
//+------------------------------------------------------------------+
CMaHandler::~CMaHandler(void)
  {
   // Actualmente no hay recursos a liberar
  }

//+------------------------------------------------------------------+
//| Método: Init                                                     |
//| Descripción: Crea el handle de la MA y verifica éxito.           |
//+------------------------------------------------------------------+
bool CMaHandler::Init()
  {
   // Creo el handle con la MA con configuración interna
   _handle = iMA(_symbol,     // Símbolo configurado
                 _timeframe,  // ← corregido: nombre completo de la variable
                 _period,     // Período de la MA
                 0,           // Shift
                 _maMethod,   // Tipo de MA (ej. MODE_SMA, EMA, etc.)
                 PRICE_CLOSE  // Precio de cierre
                );

   // Comprobamos si hay fallo
   if(_handle == INVALID_HANDLE)
     {
      // Registro de "ERROR" detallado
      Print(__FUNCTION__,
            ": Failed to create MA handle for ",
            _symbol,
            " period=", _period,
            " tf=", EnumToString(_timeframe),
            ", error=", GetLastError());
      return(false);
     }

   // Retornamos valor exitoso
   return(true);
  }

//+------------------------------------------------------------------+
//| Método: GetValue                                                 |
//| Descripción: Copia el valor más reciente de la Media Móvil       |
//|              desde el buffer del indicador y lo devuelve.        |
//+------------------------------------------------------------------+
double CMaHandler::GetValue()
  {
   // Verificar que el handle sea válido
   if(_handle == INVALID_HANDLE)
     {
      // Registro de "ERROR" detallado
      Print(__FUNCTION__,
            ": Invalid handle. Cannot copy MA buffer for symbol=", _symbol,
            " period=", _period,
            " tf=", EnumToString(_timeframe));
      return(0.0);  // Valor de reserva en caso de fallo
     }

   // Copiamos el buffer de la MA
   double buf[1];                                    // Array para un único valor
   if(CopyBuffer(_handle, 0, 0, 1, buf) != 1)        // Intenta copiar 1 elemento
     {
      // Registro de error detallado si falla la copia
      Print(__FUNCTION__,
            ": Failed to copy MA buffer for symbol=", _symbol,
            " period=", _period,
            " tf=", EnumToString(_timeframe),
            ", error=", GetLastError());
      return(0.0);                                   // Reserva ante fallo
     }

   // Retornamos el valor exitoso
   return(buf[0]);
  }

//+------------------------------------------------------------------+
//| Método: SetParams                                                |
//| Permite reconfigurar los parámetros internos del MA handler.     |
//+------------------------------------------------------------------+
void CMaHandler::SetParams(const string symbol,
                           const int period,
                           const ENUM_TIMEFRAMES timeframe,
                           const ENUM_MA_METHOD maMethod)
  {
   _symbol     = symbol;
   _period     = period;
   _timeframe  = timeframe;
   _maMethod   = maMethod;
   _handle     = INVALID_HANDLE; // Requiere reinicialización con Init()
  }
//+------------------------------------------------------------------+
