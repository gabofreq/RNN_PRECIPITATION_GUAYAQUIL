from keras.models import Sequential
from keras.layers import Dense, Dropout, SimpleRNN
import pandas as pd
import numpy as np
import statsmodels.api as sm
from sklearn.metrics import mean_squared_error
import datetime
from dateutil.rrule import rrule, MONTHLY
from dateutil.relativedelta import relativedelta
from keras.layers import BatchNormalization
import tensorflow as tf

BASE = pd.read_excel('DATA.xlsx', engine='openpyxl')
BASE.Fecha = pd.to_datetime(BASE.Fecha)
BASE  = BASE.set_index('Fecha')

S = pd.DataFrame(BASE.SST)
S = S.rename(columns={'SST': "Xt"})
S['Xt-1'] = BASE.SST.shift(1)
S['Xt-2'] = BASE.SST.shift(2)
S['Xt-3'] = BASE.SST.shift(3)
S['Xt-4'] = BASE.SST.shift(4)
S['Xt-5'] = BASE.SST.shift(5)
S['Xt-6'] = BASE.SST.shift(6)
S['Xt-7'] = BASE.SST.shift(7)
S['Xt-8'] = BASE.SST.shift(8)
S['Xt-9'] = BASE.SST.shift(9)
S['Xt-10'] = BASE.SST.shift(10)
S['Xt-11'] = BASE.SST.shift(11)
S['Xt-12'] = BASE.SST.shift(12)
S = S.dropna()


Y_TRAIN = BASE[(BASE.index <= '2019-12-01') & (BASE.index  >= min(S.index))]["RR"]
X_TRAIN = np.array(S[S.index <= '2019-12-01'])
X_TRAIN = X_TRAIN.reshape(len(X_TRAIN), 1, X_TRAIN.shape[1])

Y_TEST  = BASE[BASE.index > '2019-12-01']["RR"]
X_TEST  = np.array(S[S.index > '2019-12-01'])
X_TEST  = X_TEST.reshape(len(X_TEST), 1, X_TEST.shape[1])

tf.random.set_seed(-13741)
model = Sequential()
model.add(SimpleRNN(128, return_sequences=True, input_shape = (X_TRAIN.shape[1:])))
model.add(SimpleRNN(128, activation = 'relu'))
model.add(Dropout(0.1))
model.add(Dense(64, activation = 'relu'))
model.add(BatchNormalization())
model.add(Dropout(0.1))
model.add(Dense(32, activation = 'relu'))
model.add(BatchNormalization())
model.add(Dropout(0.1))
model.add(Dense(16, activation = 'relu'))
model.add(Dense(1, activation = 'linear'))
model.compile(loss = 'mse',optimizer = 'adam')
model.fit(X_TRAIN, Y_TRAIN, epochs=100,batch_size = 100, verbose=False)

TRAIN = pd.DataFrame({'RR':Y_TRAIN})
TRAIN["Model"] = model.predict(X_TRAIN)
TRAIN.plot.line()

round(sm.OLS(TRAIN['RR'], TRAIN['Model']).fit().rsquared_adj,2)
round(np.sqrt(mean_squared_error(TRAIN['RR'], TRAIN['Model'])),0)


TEST = pd.DataFrame({'RR':Y_TEST})
TEST["Model"] = model.predict(X_TEST)
TEST.plot.line()


round(sm.OLS(TEST['RR'], TEST['Model']).fit().rsquared_adj,2)
round(np.sqrt(mean_squared_error(TEST['RR'], TEST['Model'])),0)
