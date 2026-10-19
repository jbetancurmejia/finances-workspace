# Product Requirement Document (PRD)
## MVP Lean - App de Finanzas Personales, Préstamos y Bolsillos Compartidos

---

## 1. Visión del Producto
Validar en el mercado la adopción de una aplicación móvil de finanzas personales que simplifique el registro diario, permita co-gestionar presupuestos compartidos en pareja sin fricción, proyecte deudas con tasas reales en Colombia (E.A. / M.V.) y concientice sobre el gasto mediante el indicador psicológico **"Costo en Horas de Vida"**.

---

## 2. Stack Tecnológico del MVP

| Capa | Tecnología | Librerías / Herramientas |
| :--- | :--- | :--- |
| **Mobile Client** | Flutter (Dart) | `easy_localization`, `http` / `dio`, `intl` |
| **Backend API** | .NET 8 Web API (C#) | Entity Framework Core, Swagger UI |
| **Base de Datos** | SQLite (Dev) / SQL Server (Prod) | Transición por `appsettings.json` (`ConnectionString`) |
| **i18n** | JSON centralizados | `assets/translations/es.json` y `en.json` |

---

## 3. Historias de Usuario (Gherkin)

### HU-01: Registro de Gasto con "Costo en Horas de Vida"
* **Como** Usuario,
* **Quiero** Ver cuántas horas de trabajo me cuesta un gasto antes de confirmarlo,
* **Para** Tomar conciencia y reducir mis compras impulsivas.

> **Criterios de Aceptación:**
> * **Given** un usuario con salario de $2.000.000 COP y 160 horas laborales mensuales ($12.500 COP/hora).
> * **When** ingresa un gasto de $300.000 COP en la app.
> * **Then** la app calcula y muestra la etiqueta: *"Este gasto equivale a 24 horas (3 días) de tu trabajo"*.

---

### HU-02: Co-gestión de Bolsillo Compartido (Pareja)
* **Como** Usuario Propietario,
* **Quiero** Vincular a mi pareja a un bolsillo con un solo clic,
* **Para** Compartir el saldo y registro de gastos del hogar sin manejar permisos complejos.

> **Criterios de Aceptación:**
> * **Given** que el usuario ingresa el nombre de usuario/email de su pareja.
> * **When** confirma la vinculación.
> * **Then** el backend otorga acceso simétrico directo en `workspace_members` y sincroniza las transacciones para ambos.

---

### HU-03: Módulo de Préstamos y Amortización
* **Como** Usuario endeudado,
* **Quiero** Ingresar el capital, plazo y tasa E.A.,
* **Para** Obtener el desglose de cuotas fijas mensuales con interés M.V.

> **Criterios de Aceptación:**
> * **Given** un crédito con tasa del 20% E.A.
> * **When** el backend en .NET procesa la creación.
> * **Then** convierte la tasa E.A. a M.V. ($i_{MV} = (1 + 0.20)^{1/12} - 1 \approx 1.53\%$) y genera la tabla de cuotas según el Sistema Francés.

---

### HU-04: Semáforo Visual de Cards
* **Como** Usuario,
* **Quiero** Ver mis cuentas/bolsillos codificados por color,
* **Para** Identificar alertas financieras sin leer reportes largos.

> **Criterios de Aceptación:**
> * **Given** un bolsillo o crédito.
> * **When** la fecha de vencimiento se acerca (1 a 5 días) o el saldo es crítico, la Card se vuelve **Amarilla**.
> * **And** si la cuota vence o el saldo es cero, se muestra en **Rojo**.
> * **And** si la cuenta está en rango seguro, se mantiene **Verde**.

---

## 4. Plan de Ejecución por Fases (Roadmap Lean)

### Fase 1: Backend .NET 8 + EF Core SQLite
1. Crear solución .NET 8 Web API.
2. Definir entidades: `User`, `Workspace`, `WorkspaceMember`, `Pocket`, `Loan`, `Transaction`.
3. Configurar `DbContext` sobre SQLite (`app.db`) y `DbInitializer` con datos de semilla.
4. Implementar servicio de conversión E.A. -> M.V. y generador de cuotas.
5. Implementar endpoint para cálculo de "Costo en Horas de Vida".

### Fase 2: Cliente Flutter + i18n
1. Crear proyecto Flutter e integrar `easy_localization` (`es.json` y `en.json`).
2. Diseñar pantallas de Login, Dashboard de Cards (Semáforo) y Formulario de Gastos con etiqueta de horas de vida.
3. Conectar cliente móvil con endpoints de .NET.

### Fase 3: Pruebas de Campo
1. Desplegar API en servidor/local e instalar app móvil.
2. Medir adherencia al registro durante 14 días y validar las 3 hipótesis Lean.