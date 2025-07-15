# MQL5-InvestBrothers

---

# Atoms – Librería Modular para Bots MQL5

## Autores

JPWarrior
AndrzWarrior
Todos los derechos reservados © 2025

---

## Filosofía de Diseño

### Small inline, complex external

Cada átomo expone una interfaz mínima en su archivo `.mqh` (header), delegando toda lógica compleja a un archivo de implementación `_impl.mqh`.
Esto mejora la legibilidad, favorece el mantenimiento y permite reuso en distintos contextos.

### Separación de Archivos

- `*.mqh`: declara atributos, constructor, destructor y métodos públicos.
- `*_impl.mqh`: contiene la implementación concreta.
- `index.mqh`: archivo opcional para importar todos los componentes del dominio.

### Átomos vírgenes

Cada átomo es funcionalmente puro y:

- No contiene lógica de estrategia.
- Es reutilizable en distintos EAs sin modificación.
- Puede instanciarse múltiples veces con diferentes configuraciones.

### Configuración por constructor o setParams

Los parámetros clave pueden definirse:

- En el constructor para inicialización fija.
- Mediante `setParams()` para flexibilidad dinámica.

### Desacoplamiento estructural

Cada átomo:

- Vive en su propia carpeta.
- No depende de ningún otro átomo.
- Es completamente autónomo.

---

## Estructura del Proyecto

```
Atoms/
├── Flow/
│   ├── NewBarDetector.mqh
│   ├── NewBarDetector_impl.mqh
│   └── index.mqh
├── Indicators/
│   ├── MaHandler.mqh
│   ├── MaHandler_impl.mqh
│   └── index.mqh
├── Risk/
│   ├── PositionSizer.mqh
│   ├── PositionSizer_impl.mqh
│   └── index.mqh
├── Trade/
│   ├── OrderManager.mqh
│   ├── OrderManager_impl.mqh
│   └── index.mqh
├── Utils/
│   └── TimeUtils.mqh
└── README.md
```

---

## Convenciones

- Toda clase comienza con `C` (por ejemplo, `CNewBarDetector`).
- La lógica compleja se escribe en `_impl.mqh`.
- Las subcarpetas representan dominios: Flow, Indicators, Risk, Trade, Utils.

---

## Componentes Disponibles

### Flow / NewBarDetector

**Funcionalidad:** Detecta la formación de nuevas velas.
**Problema que resuelve:** Sincroniza la lógica del EA con eventos de nueva vela, evitando evaluaciones en curso de vela.
**Analogía:** Como un trader que espera que cierre la vela antes de actuar.

**Atributos:** `_symbol`, `_timeframe`, `_lastBarTime`
**Métodos:**

- `IsNewBar() → bool`
- `Reset()`
- `setParams(symbol, timeframe)`

**Ejemplo:**

```mql5
CNewBarDetector barDetector(_Symbol, PERIOD_M5);
if(barDetector.IsNewBar()) {
    // Ejecutar lógica de barra nueva
}
```

---

### Indicators / MaHandler

**Funcionalidad:** Gestión de medias móviles con `iMA()`.
**Problema que resuelve:** Crea y consulta un handle de media móvil de forma eficiente.
**Analogía:** Como tener un asistente que consulta por ti el valor actual de la media móvil.

**Atributos:** `_symbol`, `_timeframe`, `_period`, `_handle`
**Métodos:**

- `Init() → bool`
- `GetValue() → double`
- `setParams(symbol, period, timeframe)`

**Ejemplo:**

```mql5
CMaHandler ma(_Symbol, 20, PERIOD_M15);
ma.Init();
double valorMA = ma.GetValue();
```

---

### Risk / PositionSizer

**Funcionalidad:** Calcula el tamaño de posición ideal según riesgo fijo.
**Problema que resuelve:** Determina automáticamente el número de lotes permitidos según SL y saldo.
**Analogía:** Como un gestor de riesgo que te dice cuánto puedes arriesgar sin romper tu cuenta.

**Atributos:** `_riskPercent`, `_accountBalance`, `_slPoints`
**Métodos:**

- `setParams(riskPercent)`
- `CalculateLots(slPoints) → double`

---

### Trade / OrderManager

**Funcionalidad:** Abstracción para órdenes de compra/venta.
**Problema que resuelve:** Simplifica la interacción con `CTrade` mediante una interfaz más declarativa.
**Analogía:** Como un bróker automático al que solo le das instrucciones claras y ejecuta por ti.

**Atributos:** `_symbol`, `_magic`, `_slippage`, `_lastTicket`
**Métodos:**

- `OpenBuy(lots, sl, tp) → ulong`
- `OpenSell(lots, sl, tp) → ulong`

**Ejemplo:**

```mql5
OrderManager manager(_Symbol, 3, 10001);
manager.OpenBuy(0.1, 100, 200);
```

---

## Ejemplo de Integración

```mql5
#include <Atoms/Flow/index.mqh>
#include <Atoms/Indicators/index.mqh>
#include <Atoms/Trade/index.mqh>

CNewBarDetector barDetector(_Symbol, PERIOD_M1);
CMaHandler      ma(_Symbol, 20, PERIOD_M1);
OrderManager    trader(_Symbol, 3, 123456);

int OnInit()
  {
   ma.Init();
   return INIT_SUCCEEDED;
  }

void OnTick()
  {
   if(barDetector.IsNewBar())
     {
      double maValue = ma.GetValue();
      if(Close[1] > maValue)
         trader.OpenBuy(0.1, 100, 200);
     }
  }
```

---

## Buenas Prácticas

**Qué hacer:**

- Crear siempre `.mqh` (header) + `_impl.mqh` (lógica).
- Declarar claramente los métodos públicos.
- Diseñar sin lógica de estrategia.
- Configurar vía constructor o `setParams()`.

**Qué evitar:**

- No usar variables globales.
- No acoplar un átomo a otro.
- No hardcodear valores como símbolos, SL, TP, lots.
- No saturar el header con lógica interna.

**¿Cuándo usar `_impl.mqh`?**

- Siempre que un método supere 1–2 líneas.
- Si se hacen llamadas a la API (`iMA`, `CopyBuffer`, etc.).
- Para mejorar la organización general del código.

---

## Licencia

Esta librería es de uso estrictamente privado y con derechos reservados.
Queda prohibida su reproducción, modificación o distribución sin consentimiento explícito de sus autores.
