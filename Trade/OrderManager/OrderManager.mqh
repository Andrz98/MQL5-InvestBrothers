//+------------------------------------------------------------------+
//|                                                   InvestBrothers |
//|                                      Copyright 2025, J&ABrothers |
//|                                         JPWarrior & AndrzWarrior |
//+------------------------------------------------------------------+
#ifndef ATOMS_TRADE_ORDERMANAGER_H
#define ATOMS_TRADE_ORDERMANAGER_H

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Clase: COrderManager                                             |
//| Descripción: Gestiona la apertura, modificación y cierre de      |
//| órdenes en la cuenta, encapsulando la API de trading (CTrade)   |
//| y asegurando un manejo uniforme de tickets, slippage y magic.   |
//+------------------------------------------------------------------+
class OrderManager
  {
private:
   CTrade            _trade;          // Nativo de MQL5, envuelve funciones trading (Buy(), Sell()).
   ulong             _magic;          // Número mágico opcional para distinguir operaciones de este EA de otras en la misma cuenta.
   string            _symbol;         // Símbolo a monitorear.
   double            _slippage;       // Deslizamiento tolerado al enviar órdenes.
   ulong             _lastTicket;     // Ticket de la última operación abierta, para poder referenciarla rápidamente.

public:

   //+------------------------------------------------------------------+
   //| Constructor: OrderManager                                        |
   //| Inicializa _symbol, _slippage y _magic; setea _lastTicket a      |
   //| INVALID_TICKET y prepara _trade para uso.                        |
   //+------------------------------------------------------------------+
                     OrderManager(const string symbol,
                const double slippage,
                const ulong magic);

   //+----------------------------------------------------------------+
   //| Destructor: ~OrderManager                                      |
   //| Libera recursos asociados al handle (si fuera necesario).      |
   //+----------------------------------------------------------------+
                    ~OrderManager();

   //+----------------------------------------------------------------+
   //| Firmas de métodos                                              |
   //+----------------------------------------------------------------+
   // Abre una orden de compra, devuelve ticket o INVALID_TICKET
   ulong             OpenBuy(double volume,
                             double price = 0.0,
                             double stopLoss = 0.0,
                             double takeProfit = 0.0);

   // Abre orden de venta, devuelve ticket o INVALID_TICKET
   ulong             OpenSell(double volume,
                              double price = 0.0,
                              double stopLoss = 0.0,
                              double takeProfit = 0.0);

   // Cierra la posición dada por ticket, devolviendo éxito/fallo
   bool              CloseOrder(ulong ticket);

   // Modificar stopLoss o takeProfit de la orden
   bool              ModifyOrder(ulong ticket,
                                 double newStopLoss,
                                 double newTakeProfit);

   // Comprueba si la posición ya esta cerrada
   bool               IsPositionClosed(ulong ticket);
  };


#endif // ATOMS_Trade_ORDERMANAGER_H
//+------------------------------------------------------------------+
