//+------------------------------------------------------------------+
//|                                                   InvestBrothers |
//|                                      Copyright 2025, J&ABrothers |
//|                                         JPWarrior & AndrzWarrior |
//+------------------------------------------------------------------+
#ifndef ATOMS_IND_MAHANDLER_H
#define ATOMS_IND_MAHANDLER_H

//+------------------------------------------------------------------+
//| Clase: CMaHandler                                               |
//| Descripción: Gestiona la creación, lectura y liberación del      |
//| handle de la Media Móvil (MA), permitiendo múltiples instancias | 
//| para distintos símbolos, marcos temporales y periodos de cálculo.|
//+------------------------------------------------------------------+
class CMaHandler
  {
  private:
    string            _symbol;     // Símbolo a monitorear
    ENUM_TIMEFRAMES   _timeframe;  // Marco temporal en que se trabaja
    int               _period;     // Longitud de la media móvil
    ENUM_MA_METHOD    _maMethod;   // Tipo de media móvil (ej: MODE_SMA, MODE_EMA)
    int               _handle;     // Handle devuelto por iMA()

  public:
    //+----------------------------------------------------------------+
    //| Constructor: CMaHandler                                        |
    //| Inicializa _symbol, _period y _timeframe; setea _handle a      |
    //| INVALID_HANDLE.                                                |
    //+----------------------------------------------------------------+
    CMaHandler(const string symbol,
               const int period,
               const ENUM_TIMEFRAMES timeframe);

    //+----------------------------------------------------------------+
    //| Destructor: ~CMaHandler                                        |
    //| Libera recursos asociados al handle (si fuera necesario).      |
    //+----------------------------------------------------------------+
    ~CMaHandler();

    //+----------------------------------------------------------------+
    //| Firmas de métodos                                              |
    //+----------------------------------------------------------------+
    bool   Init();      // Crea el handle de la MA y verifica éxito
    double GetValue();  // Devuelve el valor más reciente de la MA

    //+----------------------------------------------------------------+
    //| Método: SetParams                                              |
    //| Permite reconfigurar los parámetros internos del MA handler.   |
    //+----------------------------------------------------------------+
    void SetParams(const string symbol,
                   const int period,
                   const ENUM_TIMEFRAMES timeframe,
                   const ENUM_MA_METHOD maMethod);
  };

#endif // ATOMS_IND_MAHANDLER_H
//+------------------------------------------------------------------+
