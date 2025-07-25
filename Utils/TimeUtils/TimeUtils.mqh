//+------------------------------------------------------------------+
//|                                                   InvestBrothers |
//|                                      Copyright 2025, J&ABrothers |
//|                                         JPWarrior & AndrzWarrior |
//+------------------------------------------------------------------+
#ifndef ATOMS_UTILS_TIMEUTILS_H
#define ATOMS_UTILS_TIMEUTILS_H

//+------------------------------------------------------------------+
//| Módulo: TimeUtils                                                |
//| Descripción: Funciones auxiliares para manejo de tiempo y fechas |
//+------------------------------------------------------------------+

// Devuelve una cadena formateada de una fecha (ej: "2025.07.12 14:55")
string FormatDateTime(datetime dt)
  {
   return TimeToString(dt, TIME_DATE | TIME_MINUTES);
  }

// Devuelve solo la hora (ej: 14)
int GetHour(datetime dt)
  {
   return TimeHour(dt);
  }

// Devuelve solo el minuto (ej: 30)
int GetMinute(datetime dt)
  {
   return TimeMinute(dt);
  }

// Devuelve solo el segundo (ej: 45)
int GetSecond(datetime dt)
  {
   return TimeSeconds(dt);
  }

// Verifica si el tiempo actual está dentro de un rango horario dado
bool IsWithinTimeRange(int startHour, int startMinute, int endHour, int endMinute)
  {
   datetime now = TimeCurrent();
   int nowHour = TimeHour(now);
   int nowMin  = TimeMinute(now);

// Convertimos todo a minutos desde medianoche para comparar
   int nowTotal    = nowHour * 60 + nowMin;
   int startTotal  = startHour * 60 + startMinute;
   int endTotal    = endHour * 60 + endMinute;

   return (nowTotal >= startTotal && nowTotal <= endTotal);
  }

// Calcula la diferencia entre dos tiempos en segundos
int SecondsBetween(datetime t1, datetime t2)
  {
   return (int)MathAbs(t1 - t2);
  }

#endif // ATOMS_UTILS_TIMEUTILS_H
//+------------------------------------------------------------------+
