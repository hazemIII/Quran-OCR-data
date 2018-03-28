import matlab.engine
import scipy.io as sio
import numpy as np
from sklearn.externals import joblib
import time
import sklearn
###########################################################
#target = sio.loadmat('allTarget.mat')['Target']
data = sio.loadmat('dataSample.mat')['dataSample']
svm = joblib.load('svmModel.pkl')
###########################################################
t= time.time()
M  = matlab.engine.start_matlab()
print time.time() - t
labels = ['alf' ,'damma ', 'damma_hat', 'el geem', 'el wakf', 'fatha', 'hamza', 'hamza2' ,'hat',
'kelly', 'laa', 'mad', 'meem' ,'point','selly', 'shada', 'shape', 'skoon', 'skoon2' ,'three_points',
'tnween damma', 'tnween fatha shifted','tnween fatha straight', 'two_points']
count = 0
t=time.time()
for i in range(1,2):
    sample = M.getData(i,nargout=1)
    nnResult =  M.NN(sample , nargout=1)
    print time.time() - t
    svmResult =  svm.predict(np.transpose(np.asarray(sample)))
    svmResult = str(svmResult[0]).strip()
    '''if (labels[np.argmax(nnResult)] != svmResult):
        count += 1
print count'''
