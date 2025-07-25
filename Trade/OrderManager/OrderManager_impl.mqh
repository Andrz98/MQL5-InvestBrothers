//+------------------------------------------------------------------+
//|                                                   InvestBrothers |
//|                                      Copyright 2025, J&ABrothers |
//|                                         JPWarrior & AndrzWarrior |
//+------------------------------------------------------------------+
#include "OrderManager.mqh"
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

//+------------------------------------------------------------------+
//| Constante: INVALID_TICKET                                        |
//| Descripción: Valor de ticket inválido para indicar fallo.        |
//+------------------------------------------------------------------+
#define INVALID_TICKET 0

//+------------------------------------------------------------------+
//| Constructor: OrderManager                                        |
//| Inicializa _symbol, _slippage y _magic; setea _lastTicket a      |
//| INVALID_TICKET y prepara _trade para uso.                        |
//+------------------------------------------------------------------+
OrderManager::OrderManager(const string symbol,
                           const double slippage,
                           const ulong  magic)
  {
   _symbol     = symbol;            // Se guarda el símbolo en el atributo
   _slippage   = slippage;          // Se aplica el deslizamiento deseado
   _magic      = magic;             // Se define el número mágico de esta EA
   _lastTicket = INVALID_TICKET;    // No hay ticket inicial, lo marcamos como inválido
  }

//+------------------------------------------------------------------+
//| Método: OrderManager::OpenBuy                                    |
//| Descripción: Envía una orden de compra utilizando CTrade,        |
//|              aplicando símbolo, volumen, precio, SL, TP, magic   |
//|              y slippage configurados en la instancia.            |
//+------------------------------------------------------------------+
ulong OrderManager::OpenBuy(double volume,
                            double price,
                            double stopLoss,
                            double takeProfit)
  {
   // Se intenta abrir una orden de compra
   if(_trade.Buy(volume,           // Volumen de la operación
                 _symbol,          // Símbolo configurado
                 price,            // Precio (0 = mercado)
                 stopLoss,         // Stop Loss en puntos o precio
                 takeProfit,       // Take Profit en puntos o precio
                 ""))              // Comentario vacío
     {
      // Si hay éxito: se obtiene y se guarda el ticket
      _lastTicket = (ulong)_trade.ResultOrder();
      return(_lastTicket);
     }
   else
     {
      // Si hay fallo: se registra y printea el error
      Print(__FUNCTION__,
            ": Buy order failed for ", _symbol,
            ", volume=", volume,
            ", error=", GetLastError());
      return(INVALID_TICKET);
     }
  }

//+------------------------------------------------------------------+
//| Método: OrderManager::OpenSell                                   |
//| Descripción: Envía una orden de venta utilizando CTrade,         |
//|              aplicando símbolo, volumen, precio, SL, TP, magic   |
//|              y slippage configurados en la instancia.            |
//+------------------------------------------------------------------+
ulong OrderManager::OpenSell(double volume,
                             double price,
                             double stopLoss,
                             double takeProfit)
  {
   // Se intenta abrir una orden de venta
   if(_trade.Sell(volume,          // Volumen de la operación
                  _symbol,         // Símbolo configurado
                  price,           // Precio (0 = mercado)
                  stopLoss,        // Stop Loss en puntos o precio
                  takeProfit,      // Take Profit en puntos o precio
                  ""))             // Comentario vacío
     {
      // Si hay éxito: se obtiene y se guarda el ticket
      _lastTicket = (ulong)_trade.ResultOrder();
      return(_lastTicket);
     }
   else
     {
      // Si hay fallo: se registra y printea el error
      Print(__FUNCTION__,
            ": Sell order failed for ", _symbol,
            ", volume=", volume,
            ", error=", GetLastError());
      return(INVALID_TICKET);
     }
  }

//+------------------------------------------------------------------+
//| Método: OrderManager::CloseOrder                                 |
//| Descripción: Cierra la posición especificada por ticket,         |
//|              utilizando CTrade y gestionando slippage y magic.   |
//+------------------------------------------------------------------+
bool OrderManager::CloseOrder(ulong ticket)
  {
   // Intentar seleccionar la posición por su ticket
   if(!PositionSelectByTicket(ticket))
     {
      Print(__FUNCTION__,
            ": PositionSelectByTicket failed for ticket=", ticket,
            ", error=", GetLastError());
      return(false);
     }

   // Intentar cerrar la posición con CTrade::PositionClose
   if(!_trade.PositionClose(ticket))
     {
      Print(__FUNCTION__,
            ": PositionClose failed for ticket=", ticket,
            ", error=", GetLastError());
      return(false);
     }

   // Cierre exitoso: resetear el ticket si corresponde
   _lastTicket = INVALID_TICKET;
   return(true);
  }

//+------------------------------------------------------------------+
//| Método: OrderManager::ModifyOrder                                |
//| Descripción: Ajusta el Stop Loss y Take Profit de la orden       |
//|              identificada por su ticket, usando CTrade.          |
//+------------------------------------------------------------------+
bool OrderManager::ModifyOrder(ulong ticket,
                               double newStopLoss,
                               double newTakeProfit)
  {
   // Seleccionar la posición por ticket
   if(!PositionSelectByTicket(ticket))
     {
      Print(__FUNCTION__,
            ": PositionSelectByTicket failed for ticket=", ticket,
            ", error=", GetLastError());
      return(false);
     }

   // Intentar modificar Stop Loss y Take Profit
   if(!_trade.PositionModify(ticket,
                             newStopLoss,
                             newTakeProfit))
     {
      Print(__FUNCTION__,
            ": PositionModify failed for ticket=", ticket,
            ", SL=", newStopLoss,
            ", TP=", newTakeProfit,
            ", error=", GetLastError());
      return(false);
     }

   // Éxito en la modificación
   return(true);
  }

//+------------------------------------------------------------------+
//| Método: OrderManager::IsPositionClosed                           |
//| Descripción: Comprueba si la posición identificada por ticket ya |
//|              no está abierta en el libro de órdenes.             |
//+------------------------------------------------------------------+
bool OrderManager::IsPositionClosed(ulong ticket)
  {
   // Devuelve true si la posición ya NO existe (está cerrada)
   return(!PositionSelectByTicket(ticket));
  }

//+------------------------------------------------------------------+
//| Destructor: ~OrderManager                                        |
//| Descripción: Placeholder para liberar recursos si fuera necesario|
//+------------------------------------------------------------------+
OrderManager::~OrderManager()
  {
   // Actualmente no hay recursos a liberar
  }
//+------------------------------------------------------------------+
