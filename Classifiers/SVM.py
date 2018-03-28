import scipy.io as sio
import h5py
import numpy as np
from sklearn.svm import *
from sklearn.cross_validation import *
from sklearn.externals import joblib
import time
# #
# data = h5py.File('allData.mat')
# Data = np.array(data['Data']).transpose()
# #
# labels = sio.loadmat('allTarget.mat')['Target']
#
# trainData, testData, trainLabels, testLabels = train_test_split(Data, labels, test_size=.3, random_state=42)
#
# sio.savemat('trainData.mat', {'trainData': trainData})
# sio.savemat('testData.mat', {'testData': testData})
# sio.savemat('trainLabels.mat', {'trainLabels': trainLabels})
# sio.savemat('testLabels.mat', {'testLabels': testLabels})
#
trainLabels = sio.loadmat("trainLabels.mat")["trainLabels"]
trainData = sio.loadmat("trainData.mat")["trainData"]

#

testLabels = sio.loadmat("testLabels.mat")["testLabels"]
testData = sio.loadmat("testData.mat")["testData"]

startTime = time.time()
Clf = SVC(C=100, kernel='rbf', probability=True)
Clf.fit(trainData, trainLabels)

print time.time()-startTime

joblib.dump(Clf, 'svmModel.pkl')

#
result = Clf.score(testData, testLabels)
predLabels = Clf.predict(testData)

sio.savemat('predictedLabels.mat', {'predLabels': predLabels})

print result
