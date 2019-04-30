# Filtering_of_Correlation_Matrix
Methodology, Computing and proof of Goodness in order to derive the true Correlation Matrix from a small sample.

The Matlab scripts 'test_teoricoPRO.m' and 'test_praticoPRO.m' launch all the needed function and plot the results, size of stocks n and length of time series t can be changed. The first one generates random datas with given distribution, the second one uses true financial data from the stocks listed in 'tickers_list-txt'.

The four filtering functions 'filtraggio_MAX.m', 'filtraggio_MED.m', 'filtraggio_POT.m', 'filtraggio_ROS.m' do the actual filtering procedures.

The functions 'KL.m', 'Exp_KL1.m', 'Exp_KL2.m' do the computation regarding the Kullback-Leibler distance.

Auxiliary scripts 'hist_stock_data.m' and 'simulazione.m' help getting the data and launching the filtering procedures, respectively.
