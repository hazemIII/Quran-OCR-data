from scipy import  io as sio
import numpy as np
import features_test
import svmTest2
def main():
    page = sio.loadmat('page.mat')['page']
    page = np.asarray(page)
    x,y = page.shape
    column = 1
    labels = []
    for i in range(x):
        print i
        sec = page[i][column]
        k,l = sec.shape
        label = []
        for j in range(l):
            diac = sec[0][j]
            featureVector = features_test.getFeatures(255*diac)
            pred = svmTest2.classify(featureVector)
            label = np.append(label,pred,axis=0)
        if x == 1:
            sio.savemat('labels.mat',{'labels':label})
            return
        labels.append(label)

    sio.savemat('labels.mat',{'labels':labels})


