# Especificación de Requisitos de Software (SRS)
## Sistema de Control Financiero Personal, Préstamos y Bolsillos Compartidos (Colombia)

---

## 1. Introducción y Dominio del Problema

### 1.1 Alcance y Objetivos
El proyecto consiste en el desarrollo de una solución integral de gestión financiera personal adaptada al contexto colombiano bajo el enfoque **Lean Startup**. Permite a los usuarios llevar un registro preciso de sus ingresos (salario, honorarios), gastos diarios, administración de préstamos con cálculo de intereses (conversión de Efectiva Anual a Mensual Vencida) y alertas para pagos de facturas.

La solución incluye soporte para **Bolsillos Compartidos** (sincronizados entre usuarios con acceso simétrico simple, ideal para parejas) y la función psicológica **"Costo en Horas de Vida"** para concientización de gastos.

### 1.2 Glosario de Términos
* **E.A. (Efectiva Anual):** Tasa de interés expresada de forma anualizada, estándar en el sistema financiero colombiano.
* **M.V. (Mensual Vencida):** Tasa de interés aplicada al final de cada periodo mensual.
* **Sistema Francés de Amortización:** Método de liquidación de créditos caracterizado por cuotas periódicas constantes.
* **Bolsillo (Workspace/Pocket):** Subcuenta lógica utilizada para agrupar ingresos, presupuestos y gastos con un objetivo específico.
* **Card de Alerta:** Componente de interfaz de usuario en la aplicación móvil cuyos colores (Verde, Amarillo, Rojo, Púrpura) varían dinámicamente según el estado de mora, vencimiento o proximidad al saldo cero.
* **Costo en Horas de Vida:** Relación matemática que convierte el monto de un gasto en el número de horas de trabajo requeridas para pagarlo (`Monto / Valor Hora`).
* **i18n (Easy Localization):** Gestión de internacionalización centralizada en archivos JSON (`es.json` y `en.json`).

---

## 2. Necesidades del Negocio (Lean Startup)

### 2.1 Objetivos del Negocio
* Validar en un ciclo rápido *Construir-Medir-Aprender* las 3 hipótesis clave de valor:
  1. Adherencia al registro manual rápido.
  2. Reducción de fricción en la co-gestión de finanzas en pareja.
  3. Efecto disuasorio del indicador "Costo en Horas de Vida".

### 2.2 Actores del Sistema
* **Usuario (Cliente Móvil):** Usuario registrado en la app móvil con permisos simétricos para gestionar sus bolsillos individuales o co-gestionar bolsillos compartidos.

### 2.3 Procesos del Negocio
[Ingreso (Salario) + Horas Trabajo] ──> [Cálculo Valor/Hora]
│
[Bolsillos (Hogar / Personal)] ◄────────────────┴──> [Gasto Registrado ("Equivale a X Horas")]
│
├──> [Crédito (Tasa E.A. -> M.V. -> Tabla Amortización)]
└──> [Semáforo Visual: Verde / Amarillo / Rojo]
---

## 3. Casos de Uso Principales (MVP Lean)

### CU-01: Creación y Vinculación Directa a Bolsillo Compartido
* **Actor Principal:** Usuario.
* **Precondición:** Ambos usuarios registrados en la app.
* **Flujo Principal:**
  1. El usuario crea o selecciona un bolsillo ("Gastos de Hogar").
  2. Ingresa el usuario/email de su pareja.
  3. El backend asigna acceso simétrico directo en `workspace_members`.
  4. Ambos usuarios consultan y registran transacciones en tiempo real.

### CU-02: Registro de Crédito con Amortización E.A. -> M.V.
* **Actor Principal:** Usuario.
* **Flujo Principal:**
  1. El usuario ingresa: Capital, Tasa % E.A., Plazo en meses y Fecha de Inicio.
  2. El backend calcula $i_{MV} = (1 + i_{EA})^{1/12} - 1$.
  3. El backend genera la tabla de cuotas fijas (Sistema Francés).
  4. Se proyectan las fechas de pago en la UI.

### CU-03: Visualización de "Costo en Horas de Vida"
* **Actor Principal:** Usuario.
* **Flujo Principal:**
  1. El usuario configura en su perfil: `Salario Mensual` y `Horas Trabajadas al Mes`.
  2. Al ingresar un monto de gasto (ej. $300.000 COP), la app calcula: $\text{Horas} = \text{Monto} / (\text{Salario} / \text{Horas})$.
  3. La UI muestra la etiqueta: *"Este gasto equivale a X Horas de tu vida"*.

---

## 4. Requisitos Funcionales

* **RF-01:** Autenticación directa por usuario/contraseña vía API .NET (JWT).
* **RF-02:** Gestión de bolsillos individuales y compartidos entre usuarios.
* **RF-03:** Módulo de préstamos con conversión de E.A. a M.V. y amortización.
* **RF-04:** Configuración de perfil laboral (`Salario` / `Horas`) y cálculo automático de "Costo en Horas de Vida".
* **RF-05:** Cards con semáforo dinámico de colores (Verde, Amarillo, Rojo, Púrpura).
* **RF-06:** Soporte multilenguaje con `easy_localization` (JSON `es.json` y `en.json`).
* **RF-07:** Formateo COP en UI sin decimales (`$ 1.500.000`) y precisión `DECIMAL(18,2)` en BD.

---

## 5. Requisitos No Funcionales y Arquitectura

* **Cliente Móvil:** Flutter (Dart) para iOS y Android.
* **Backend:** .NET 8 Web API (C#).
* **Base de Datos:** Entity Framework Core sobre **SQLite** (`app.db`) en desarrollo local, configurable hacia **SQL Server** en producción mediante `ConnectionString`.
* **Pruebas de API:** Swagger UI.