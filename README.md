# 1ACC0216 - Fundamentos de Data Science (TB1)
## Hotel Booking Demand: Análisis de Calidad, Exploración y Visualización

---

## 1. Objetivo del trabajo

Evaluar la calidad de los datos del conjunto *Hotel Booking Demand*, aplicar procedimientos de preparación y limpieza bajo criterios estadísticos y reglas de negocio, y desarrollar un análisis exploratorio univariado y bivariado que responda a las preguntas analíticas sobre volumen de reservas, tasas de cancelación y estacionalidad de la demanda en ambos tipos de hotel.

---

## 2. Nombre de los alumnos participantes

| Nombres y Apellidos | Código de Estudiante |
| :--- | :---: |
| Addy Valentina Pinedo Saldaña | U20241D259 |
| Edson Jair Ramos Vásquez | U20241F442 |
| Jack Snayder Lima Huamani | U20241G263 |
| Noelia Paquiyauri Tumbay | U20241F592 |
| Tony Montesinos Condori | U20241F805 |

---

## 3. Breve descripción del dataset

El conjunto de datos analizado contiene registros transaccionales de reservas hoteleras entre julio de 2015 y agosto de 2017 para dos establecimientos en Portugal: un hotel urbano (City Hotel) y un hotel vacacional (Resort Hotel).

* **Volumen original:** 119,390 filas y 32 variables.
* **Volumen preparado:** 87,394 filas y 32 variables depuradas tras eliminar 31,994 registros duplicados exactos y excluir 2 errores de tarifa diaria (`adr < 0` y `adr > 5000`).
* **Variables principales:** `hotel`, `is_canceled`, `lead_time`, `arrival_date_month` y `adr`.
* **Referencia bibliográfica:** Antonio, N., Almeida, A., & Nunes, L. (2019). Hotel booking demand datasets. *Data in Brief*, 22, 41–49.

📄 **Informe completo del proyecto:** [Descargar Informe en PDF](./upc-grupo01-tb1-informe.pdf)

---

## 4. Conclusiones

| Dimensión Analizada | Conclusión |
| :--- | :--- |
| **Participación de Mercado** | El City Hotel concentra la mayor parte de las operaciones de la cadena al absorber el **61.1% de la demanda global ($53,427$ reservas)**, superando al Resort Hotel que abarca el **38.9% ($33,967$ reservas)**. |
| **Riesgo por Cancelaciones** | El City Hotel asume una mayor vulnerabilidad operativa con una **tasa de cancelación del 30.0% ($16,048$ cancelaciones)**, frente a un comportamiento más estable en el Resort Hotel, cuya tasa de cancelación es de **23.5% ($7,976$ cancelaciones)**. |
| **Comportamiento Estacional** | La demanda del Resort Hotel depende críticamente del verano boreal, creciendo un **+137.7%** entre su punto más bajo en enero ($1,963$ reservas) y su pico en agosto ($4,666$ reservas). Por el contrario, el City Hotel sostiene una afluencia superior a las 4,200 reservas mensuales durante la mayor parte del año. |
| **Calidad y Depuración de Datos** | La base en crudo presentaba un **26.8% de redundancias exactas ($31,994$ registros)** por reservas en bloque de agencias de viaje. Su eliminación fue determinante para reflejar decisiones independientes de los clientes y evitar la sobreestimación de la tasa general de cancelaciones. |

---

## 5. Licencia

Este proyecto se distribuye bajo los términos de la Licencia MIT. Para mayor información, consulte el archivo `LICENSE` en este repositorio.
