## Precipitation Forecasting Using a Stacked Recurrent Neural Network

### Problem Description

#### Accurate, long-term (12-month) rainfall predictions are crucial for mitigating uncertainty in agriculture, risk management, and disease outbreak forecasting, especially in regions vulnerable to El Niño. Leveraging advanced technology and expert meteorologists, we can deliver reliable monthly forecasts that empower proactive decision-making. 
#### Sea Surface Temperature (SST) is utilized as a predictor due to its dual advantages: it provides essential retrospective climate data and exhibits strong, predictable correlations—positive in the Tropical Pacific and negative in the North Pacific—allowing for robust forecasting.  
#### Climate data, spanning from January 1915 to the present, is sourced from the Simón Bolívar Airport station in Guayaquil, provided by the National Institute of Meteorology and Hydrology of Ecuador. Additionally, 100km-resolution Sea Surface Temperature (SST) satellite imagery for the same period is available from the National Oceanic and Atmospheric Administration (NOAA) [1].

### Objectives: 
#### 1. Calibrate a machine learning model using Sea Surface Temperature (SST) vectors derived from satellite imagery. 2. Evaluate the model's performance over the preceding 12 observed months. 3. Apply the calibrated model to generate a 12-month extended forecast.

### Solution
#### Satellite imagery is processed to extract rainfall-relevant information as time series data. The methodology for deriving Sea Surface Temperature (SST) vectors is publicly available on GitHub, along with the proposed machine learning model and its calibration code..


#### [1] Huang, B., P. W. Thorne, V. F. Banzon, T. Boyer, G. Chepurin, J. H. Lawrimore, M. J. Menne, T. M. Smith, R. S. Vose, and H.-M. Zhang, 2017: Extended Reconstructed Sea Surface Temperature, version 5 (ERSSTv5): Upgrades, validations, and intercomparisons. J. Climate, 30, 8179-8205, http://dx.doi.org/10.1175/JCLI-D-16-0836.1.
