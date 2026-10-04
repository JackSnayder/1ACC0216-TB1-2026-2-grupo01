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

## 4. Estructura del Repositorio

```text
1ACC0216-TB1-2026-2-grupo01/
├── README.md                       # Documentación principal
├── LICENSE                         # Licencia MIT
├── data/
│   ├── hotel_bookings_original.csv  # Muestra original (119,390 filas)
│   └── hotel_bookings_preparado.csv # Muestra limpia (87,394 filas)
├── code/
│   └── upc-grupo01-tb1-codigo.R     # Script reproducible en R
└── output/
    └── graficos/                   # Visualizaciones exportadas (300 DPI)
