## Pronostico de Precipitación usando una Red Neuronal Recurrente Apilada

### Descripción del Problema

#### Pronosticar las precipitaciones (RR), podrían ayudar a disminuir la incertidumbre de lo que podría pasar en las actividades económicas, como la agricultura, gestión de riesgos, eh incluso anticiparse a los brotes de enfermedades como el Dengue y la malaria. A una escala mensual, se obtendría un pronóstico a largo plazo (12 meses), incluso conocer si los posibles impactos del Fenómeno del Niño, que podrían afectar a nuestra región. Por tanto, de ahí la necesidad de tener un producto confiable, basado en los medios técnicos más avanzados y en la experiencia y profesionalidad de meteorólogos calificados que puedan interpretar mejor los resultados. 
#### Para esto se usa el predictor de Temperatura Superficial del mar (TSM), por dos aspectos, primero porque cumple con la información retrospectiva necesaria Para aprovechar la información climática que se tiene, y segundo porque tiene una correlación fuerte y positiva en el pacífico Tropical, y una correlación Negativa en el Pacifico Norte.  
#### Se cuenta con información climática desde enero de 1915 hasta la actualidad, en la estación convencional ubicada en el Aeropuerto Simón Bolívar de Guayaquil. La información es provista por el Instituto Nacional de Meteorología eh Hidrología del Ecuador. Y una fuente de datos libre y depurada para la obtención de imágenes satelitales de TSM, en un mismo periodo desde enero de 1915 hasta la actualidad. Provista por la Oficina Nacional de Administración Oceánica y Atmosférica (NOAA), en una resolución de 100 km cada pixel por imagen [1].

### Objetivos
#### Calibrar un modelo de aprendizaje automático, haciendo uso del vector de TSM obtenido de la información de las imágenes satelitales, se evalúa el modelo en los últimos 12 meses observados. Y por consiguiente se toma toda la información para correr el modelo ajustado, y hacer un pronóstico extendió de los siguiente 12 meses.

### Solución
#### Las imágenes de satélite se tienen que llevar a un proceso de transformación, para convertir la información más relevante a las precipitaciones, en series de tiempo. La metodología para la obtención del vector TSM, se expone en un repositorio libre en GitHub. El modelo propuesto y su respectiva calibración se encuentran en el mismo repositorio.
#### Los datos se presentan de una forma visual en la plataforma de Power BI, para el indicado análisis estadístico interactivo, y se automatiza las metodologías en R y python, para tener el proyecto en producción.

#### [1] Huang, B., P. W. Thorne, V. F. Banzon, T. Boyer, G. Chepurin, J. H. Lawrimore, M. J. Menne, T. M. Smith, R. S. Vose, and H.-M. Zhang, 2017: Extended Reconstructed Sea Surface Temperature, version 5 (ERSSTv5): Upgrades, validations, and intercomparisons. J. Climate, 30, 8179-8205, http://dx.doi.org/10.1175/JCLI-D-16-0836.1.
