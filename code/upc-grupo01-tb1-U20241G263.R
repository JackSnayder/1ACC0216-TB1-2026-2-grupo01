# ==============================================================================
# PROYECTO: FUNDAMENTOS DE DATA SCIENCE (TB1)
# CASO: HOTEL BOOKING DEMAND
# AUTOR: GRUPO 01
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. PREPARACION DEL ENTORNO Y LIBRERIAS
# ------------------------------------------------------------------------------
rm(list = ls())
graphics.off()
cat("\014")

library(tidyverse)
library(lubridate)
library(moments)
library(scales)

# ------------------------------------------------------------------------------
# 1. IMPORTACION DEL DATASET
# ------------------------------------------------------------------------------
# Se importan los datos estandarizando textos vacios y nulos a NA
hotel_original <- read_csv(
  "data/hotel_bookings_original.csv",
  na = c("", "NA", "NULL"),
  show_col_types = FALSE
)

# ==============================================================================
# 2. EVALUACION DE LA CALIDAD DE LOS DATOS
# ==============================================================================

# 2.1 COMPLETITUD --------------------------------------------------------------
tabla_faltantes <- tibble(
  variable = names(hotel_original),
  cantidad = colSums(is.na(hotel_original)),
  porcentaje = round(colMeans(is.na(hotel_original)) * 100, 3)
) %>%
  filter(cantidad > 0) %>%
  arrange(desc(porcentaje))

tabla_faltantes

# 2.2 UNICIDAD -----------------------------------------------------------------
tabla_unicidad <- tibble(
  indicador = c(
    "Registros totales",
    "Filas duplicadas exactas",
    "Porcentaje de duplicados",
    "Registros distintos"
  ),
  resultado = c(
    nrow(hotel_original),
    sum(duplicated(hotel_original)),
    round(mean(duplicated(hotel_original)) * 100, 2),
    nrow(distinct(hotel_original))
  )
)

tabla_unicidad

# 2.3 CONSISTENCIA -------------------------------------------------------------
# Deteccion de inconsistencias en composicion de reservas
inconsistencia_menores <- hotel_original %>% 
  filter(adults == 0 & (children > 0 | babies > 0))

inconsistencia_cero_total <- hotel_original %>% 
  filter((adults + children + babies) == 0)

tabla_composicion_huespedes <- tibble(
  Tipo_Inconsistencia = c(
    "Menores (ninos/bebes) sin adultos responsables",
    "Aforo total nulo (0 personas en la reserva)"
  ),
  Cantidad_Casos = c(
    nrow(inconsistencia_menores),
    nrow(inconsistencia_cero_total)
  ),
  Criterio_Negocio = c(
    "Violacion de norma de seguridad hotelera",
    "Incoherencia logica de transaccion vacia"
  )
)

tabla_composicion_huespedes

# Deteccion de estancias con duracion nula
total_estancias_cero <- sum(
  hotel_original$stays_in_weekend_nights == 0 & hotel_original$stays_in_week_nights == 0, 
  na.rm = TRUE
)

tabla_estancias_inconsistentes <- tibble(
  Tipo_de_comprobacion = c("Estancias con duracion de cero noches (ambas variables en 0)"),
  Cantidad_de_Casos = c(total_estancias_cero)
)

tabla_estancias_inconsistentes

# Deteccion de categorias Undefined en canales comerciales
market_undef <- sum(hotel_original$market_segment == "Undefined", na.rm = TRUE)
dist_undef   <- sum(hotel_original$distribution_channel == "Undefined", na.rm = TRUE)

tabla_ambiguedades_cat <- tibble(
  Variable = c(
    "Segmento de mercado (market_segment)",
    "Canal de distribucion (distribution_channel)"
  ),
  Categoria_Evaluada = c("Undefined", "Undefined"),
  Cantidad_de_Casos = c(market_undef, dist_undef)
)

tabla_ambiguedades_cat

# 2.4 VALIDEZ ------------------------------------------------------------------
validez_cn           <- sum(hotel_original$country == "CN", na.rm = TRUE)
validez_adr_negativa <- sum(hotel_original$adr < 0, na.rm = TRUE)
validez_adr_extrema  <- sum(hotel_original$adr > 1000, na.rm = TRUE)
validez_adr_cero     <- sum(hotel_original$adr == 0, na.rm = TRUE)

tabla_validez_completa <- tibble(
  Problema_Identificado = c(
    "Codigo de pais con formato alpha-2 (CN)",
    "Tarifa diaria promedio (adr) negativa",
    "Tarifa diaria promedio (adr) extrema (> 1000)",
    "Tarifas de alojamiento en cero (adr = 0)"
  ),
  Variable = c("country", "adr", "adr", "adr"),
  Cantidad_Casos = c(validez_cn, validez_adr_negativa, validez_adr_extrema, validez_adr_cero)
)

tabla_validez_completa

# ==============================================================================
# 3. ANALISIS UNIVARIADO Y OUTLIERS
# ==============================================================================

# 3.1 ANALISIS DE TARIFA DIARIA PROMEDIO (adr) ----------------------------------
desc_adr <- hotel_original %>%
  summarise(
    Variable = "adr",
    Media    = mean(adr, na.rm = TRUE),
    Mediana  = median(adr, na.rm = TRUE),
    Desv_Est = sd(adr, na.rm = TRUE),
    Minimo   = min(adr, na.rm = TRUE),
    Maximo   = max(adr, na.rm = TRUE)
  )

desc_adr

# Tabla de frecuencias agrupadas por rangos de tarifa
tabla_freq_adr <- hotel_original %>%
  mutate(adr_categoria = cut(
    adr,
    breaks = c(-Inf, 0, 50, 100, 150, 200, 500, Inf),
    labels = c("Negativo / Cero (<= 0)", "0.01 - 50.00", "50.01 - 100.00", 
               "100.01 - 150.00", "150.01 - 200.00", "200.01 - 500.00", "Mas de 500.00")
  )) %>%
  count(adr_categoria) %>%
  mutate(Porcentaje = (n / sum(n)) * 100)

tabla_freq_adr

# Histograma de distribucion de ADR
hist_adr_original <- ggplot(hotel_original, aes(x = adr)) +
  geom_histogram(bins = 60, fill = "#1f77b4", color = "black", alpha = 0.85) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Analisis Univariado: Histograma de Tarifa Diaria Promedio (ADR)",
    x = "Tarifa Diaria Promedio (ADR)",
    y = "Frecuencia (Numero de Reservas)"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    axis.title = element_text(face = "bold", size = 10)
  )

hist_adr_original

# Boxplot de deteccion de outliers en ADR
boxplot_adr <- ggplot(hotel_original, aes(y = adr)) +
  geom_boxplot(fill = "indianred", color = "black") +
  labs(
    title = "Deteccion de Outliers: Tarifa Diaria (adr)",
    subtitle = "Identificacion de valores atipicos extremos (inferiores y superiores)",
    y = "ADR (Unidades Monetarias)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    plot.subtitle = element_text(size = 10, color = "gray30")
  )

boxplot_adr

# 3.2 ANALISIS DE TIEMPO DE ANTICIPACION (lead_time) ---------------------------
desc_lead <- hotel_original %>%
  summarise(
    Variable = "lead_time",
    Media    = mean(lead_time, na.rm = TRUE),
    Mediana  = median(lead_time, na.rm = TRUE),
    Desv_Est = sd(lead_time, na.rm = TRUE),
    Minimo   = min(lead_time, na.rm = TRUE),
    Maximo   = max(lead_time, na.rm = TRUE)
  )

desc_lead

# Tabla de frecuencias agrupadas por rangos de anticipacion
tabla_freq_lead <- hotel_original %>%
  mutate(lead_categoria = cut(
    lead_time,
    breaks = c(-Inf, 0, 30, 90, 180, 365, Inf),
    labels = c("Mismo dia (0)", "1 a 30 dias", "31 a 90 dias", 
               "91 a 180 dias", "181 a 365 dias", "Mas de 1 ano")
  )) %>%
  count(lead_categoria) %>%
  mutate(Porcentaje = (n / sum(n)) * 100)

tabla_freq_lead

# Histograma de distribucion de lead_time
hist_lt_original <- ggplot(hotel_original, aes(x = lead_time)) +
  geom_histogram(bins = 50, fill = "#2b8cbe", color = "black", alpha = 0.85) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Analisis Univariado: Histograma de Tiempo de Anticipacion (lead_time)",
    x = "Tiempo de Anticipacion (Dias)",
    y = "Frecuencia (Numero de Reservas)"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    axis.title = element_text(face = "bold", size = 10)
  )

hist_lt_original

# Boxplot de deteccion de outliers en lead_time
boxplot_lead <- ggplot(hotel_original, aes(y = lead_time)) +
  geom_boxplot(fill = "lightblue", color = "black") +
  labs(
    title = "Deteccion de Outliers: Tiempo de Anticipacion (lead_time)",
    subtitle = "Identificacion de valores atipicos superiores por reservas a largo plazo",
    y = "Dias de Anticipacion"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    plot.subtitle = element_text(size = 10, color = "gray30")
  )

boxplot_lead

# ==============================================================================
# 4. PROCESO DE LIMPIEZA Y PREPARACION DE DATOS (hotel_preparado)
# ==============================================================================

hotel_preparado <- hotel_original %>%
  # Unicidad: Eliminacion de filas duplicadas exactas
  distinct() %>%
  # Validez: Exclusion de valores atipicos e invalidos criticos en adr
  filter(adr >= 0 & adr < 5000)

# Consistencia: Recodificar Undefined a NA en canales clave
hotel_preparado <- hotel_preparado %>%
  mutate(
    market_segment = na_if(market_segment, "Undefined"),
    distribution_channel = na_if(distribution_channel, "Undefined")
  )

# Tipos de datos: Conversion de variables a factor y formato de fecha
hotel_preparado <- hotel_preparado %>%
  mutate(
    hotel = as.factor(hotel),
    is_canceled = as.factor(is_canceled),
    meal = as.factor(meal),
    market_segment = as.factor(market_segment),
    distribution_channel = as.factor(distribution_channel),
    reservation_status = as.factor(reservation_status),
    customer_type = as.factor(customer_type),
    deposit_type = as.factor(deposit_type),
    arrival_date_month = factor(
      arrival_date_month,
      levels = c("January", "February", "March", "April", "May", "June", 
                 "July", "August", "September", "October", "November", "December"),
      ordered = TRUE
    ),
    reservation_status_date = as.Date(reservation_status_date)
  )

# Exportacion del dataset preparado a la carpeta data/
write.csv(hotel_preparado, "data/hotel_bookings_preparado.csv", row.names = FALSE)

# ==============================================================================
# 5. ANALISIS BIVARIADO Y RESPUESTA A PREGUNTAS ANALITICAS
# ==============================================================================

# 5.1 PREGUNTA ANALITICA 1: CANCELACIONES SEGUN TIPO DE HOTEL ------------------
df_p1 <- hotel_preparado %>%
  group_by(hotel, is_canceled) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(hotel) %>%
  mutate(
    total_hotel = sum(n),
    pct = (n / total_hotel) * 100,
    hotel_label = paste0(hotel, "\n(n = ", comma(total_hotel), " | ", 
                         round(total_hotel / nrow(hotel_preparado) * 100, 1), "%)")
  )

grafico_p1 <- ggplot(df_p1, aes(x = hotel_label, y = pct, fill = is_canceled)) +
  geom_bar(stat = "identity", position = "stack", width = 0.5, color = "white") +
  geom_text(
    aes(label = paste0(ifelse(is_canceled == "0", "No Cancelado\n", "Cancelado\n"),
                       round(pct, 1), "% (", comma(n), ")")),
    position = position_stack(vjust = 0.5),
    color = "white", fontface = "bold", size = 3.6
  ) +
  scale_fill_manual(
    name = "Estado de Reserva",
    values = c("0" = "#2b83ba", "1" = "#d7191c"),
    labels = c("0 = No Cancelado", "1 = Cancelado")
  ) +
  scale_y_continuous(labels = function(x) paste0(x, "%"), limits = c(0, 100)) +
  labs(
    title = "Proporcion de Cancelaciones segun Tipo de Hotel",
    subtitle = "Comparativa relativa y distribucion del volumen total (N = 87,394)",
    x = "Tipo de Hotel y Participacion de Mercado",
    y = "Proporcion de Reservas (%)"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    axis.title = element_text(face = "bold", size = 10),
    legend.position = "top"
  )

grafico_p1

# Tabla de contingencia y resumen analitico de la Pregunta 1
tabla_p1_resumen <- hotel_preparado %>%
  group_by(hotel, is_canceled) %>%
  summarise(n = n(), .groups = "drop") %>%
  pivot_wider(names_from = is_canceled, values_from = n, values_fill = 0) %>%
  rename(No_Cancelado = `0`, Cancelado = `1`) %>%
  mutate(
    Total_Reservas = No_Cancelado + Cancelado,
    Participacion_Mercado_Pct = round((Total_Reservas / sum(Total_Reservas)) * 100, 2),
    Tasa_Cancelacion_Pct = round((Cancelado / Total_Reservas) * 100, 2)
  )

fila_total_p1 <- tibble(
  hotel = "Total General",
  No_Cancelado = sum(tabla_p1_resumen$No_Cancelado),
  Cancelado = sum(tabla_p1_resumen$Cancelado),
  Total_Reservas = sum(tabla_p1_resumen$Total_Reservas),
  Participacion_Mercado_Pct = 100.00,
  Tasa_Cancelacion_Pct = round((sum(tabla_p1_resumen$Cancelado) / sum(tabla_p1_resumen$Total_Reservas)) * 100, 2)
)

tabla_pregunta1_final <- bind_rows(tabla_p1_resumen, fila_total_p1)
tabla_pregunta1_final

# 5.2 PREGUNTA ANALITICA 2: DISTRIBUCION MENSUAL DE LA DEMANDA -----------------
demanda_mensual <- hotel_preparado %>%
  group_by(arrival_date_month, hotel) %>%
  summarise(reservas = n(), .groups = "drop")

grafico_p2 <- ggplot(demanda_mensual, aes(x = arrival_date_month, y = reservas, 
                                          group = hotel, color = hotel)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  scale_color_manual(
    name = "Tipo de Hotel",
    values = c("City Hotel" = "#1b9e77", "Resort Hotel" = "#7570b3")
  ) +
  scale_y_continuous(labels = comma, limits = c(1500, 7000), breaks = seq(2000, 7000, by = 1000)) +
  labs(
    title = "Evolucion de la Demanda de Reservas a lo largo del Ano",
    subtitle = "Distribucion cronologica mensual segun tipo de establecimiento (N = 87,394)",
    x = "Mes de Llegada",
    y = "Numero de Reservas"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    axis.title = element_text(face = "bold", size = 10),
    axis.text.x = element_text(angle = 35, hjust = 1),
    legend.position = "top"
  )

grafico_p2

# Tabla de evolucion mensual cronologica
tabla_p2_resumen <- hotel_preparado %>%
  group_by(arrival_date_month, hotel) %>%
  summarise(reservas = n(), .groups = "drop") %>%
  pivot_wider(names_from = hotel, values_from = reservas, values_fill = 0) %>%
  arrange(arrival_date_month) %>%
  mutate(
    Total_Cadena = `City Hotel` + `Resort Hotel`,
    Participacion_Anual_Pct = round((Total_Cadena / sum(Total_Cadena)) * 100, 2)
  )

fila_total_p2 <- tibble(
  arrival_date_month = "Total Anual",
  `City Hotel` = sum(tabla_p2_resumen$`City Hotel`),
  `Resort Hotel` = sum(tabla_p2_resumen$`Resort Hotel`),
  Total_Cadena = sum(tabla_p2_resumen$Total_Cadena),
  Participacion_Anual_Pct = 100.00
)

tabla_pregunta2_final <- bind_rows(tabla_p2_resumen, fila_total_p2)
tabla_pregunta2_final

# ==============================================================================
# 6. EXPORTACION DE GRAFICOS A LA CARPETA OUTPUT
# ==============================================================================

# 1. Histograma de ADR
ggsave(
  filename = "output/graficos/histograma_adr.png",
  plot = hist_adr_original,
  width = 8,
  height = 5,
  dpi = 300
)

# 2. Boxplot de ADR
ggsave(
  filename = "output/graficos/boxplot_adr.png",
  plot = boxplot_adr,
  width = 6,
  height = 6,
  dpi = 300
)

# 3. Histograma de lead_time
ggsave(
  filename = "output/graficos/histograma_lead_time.png",
  plot = hist_lt_original,
  width = 8,
  height = 5,
  dpi = 300
)

# 4. Boxplot de lead_time
ggsave(
  filename = "output/graficos/boxplot_lead_time.png",
  plot = boxplot_lead,
  width = 6,
  height = 6,
  dpi = 300
)

# 5. Grafico Bivariado: Cancelaciones segun Tipo de Hotel 
ggsave(
  filename = "output/graficos/bivariado_cancelaciones_hotel.png",
  plot = grafico_p1,
  width = 7.5,
  height = 5.5,
  dpi = 300
)

# 6. Grafico Temporal: Demanda Mensual Cronologica 
ggsave(
  filename = "output/graficos/evolucion_temporal_demanda.png",
  plot = grafico_p2,
  width = 8.5,
  height = 5,
  dpi = 300
)