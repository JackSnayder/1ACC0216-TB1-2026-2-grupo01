# 1ACC0216 - Fundamentos de Data Science (TB1)
## Análisis Exploratorio, Calidad de Datos y Visualización: Hotel Booking Demand

* **Institución:** Universidad Peruana de Ciencias Aplicadas (UPC)
* **Carrera:** Facultad de Ingeniería
* **Ciclo:** 2026-02 | **NRC:** 4879
* **Docente:** Nérida Isabel Manrique Tunque
* **Grupo:** Grupo 01

---

## 1. Integrantes del Equipo

| Nombres y Apellidos | Código de Estudiante |
| :--- | :---: |
| Addy Valentina Pinedo Saldaña | U20241D259 |
| Edson Jair Ramos Vásquez | U20241F442 |
| Jack Snayder Lima Huamani | U20241G263 |
| Noelia Paquiyauri Tumbay | U20241F592 |
| Tony Montesinos Condori | U20241F805 |

---

## 2. Objetivo del Trabajo

Evaluar rigurosamente la calidad de datos del dataset *Hotel Booking Demand*, ejecutar las transformaciones y preparación de la muestra bajo criterios de negocio, y desarrollar un análisis exploratorio univariado y bivariado que responda a las preguntas analíticas sobre la concentración de reservas, el comportamiento de las cancelaciones y la estacionalidad de la demanda en ambos tipos de hotel.

---

## 3. Breve Descripción del Dataset

El dataset analizado contiene registros transaccionales de reservas hoteleras entre julio de 2015 y agosto de 2017 para dos establecimientos en Portugal: un hotel urbano (City Hotel) y un hotel vacacional (Resort Hotel).

* **Dimensión original:** 119,390 registros y 32 variables.
* **Dimensión preparada (`hotel_preparado.csv`):** 87,394 registros y 32 variables tras remover 31,994 duplicados exactos y excluir 2 errores de tarifa diaria (`adr < 0` y `adr > 5000`).
* **Variables críticas:** `hotel`, `is_canceled`, `lead_time`, `arrival_date_month` y `adr`.

---

5. Principales ConclusionesMayor volumen en el hotel urbano: El City Hotel concentra el 61.1% de las reservas totales ($53,427$), superando al Resort Hotel que abarca el 38.9% ($33,967$).Mayor riesgo de cancelación en City Hotel: El City Hotel presenta una tasa de cancelación del 30.0% ($16,048$ cancelaciones), frente a un 23.5% ($7,976$ cancelaciones) en el Resort Hotel.Hiperestacionalidad en Resort Hotel: El Resort Hotel incrementa su demanda en un +137.7% entre enero ($1,963$ reservas) y su pico estival de agosto ($4,666$ reservas), mientras que el City Hotel sostiene una afluencia superior a 4,200 reservas mensuales en la mayor parte del año.Calidad de datos: Se identificaron 31,994 registros duplicados (26.8%) provenientes de reservas masivas en bloque de agencias. Su depuración fue indispensable para no sobreestimar la tasa global de cancelaciones.
