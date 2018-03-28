import cv2
import numpy as np
from scipy import ndimage
from skimage.measure import label
from skimage.measure import regionprops
################################################################################
def structure_features(image):
    ret,thresh1 = cv2.threshold(image,127,255,cv2.THRESH_BINARY)
    aspctraio=.0
    aspctraio=thresh1.shape[0]/thresh1.shape[1]
    labels,num=label(thresh1==255,background=0,return_num =True)
    prop=regionprops(thresh1==255)
    F=[]
    F.append(num)
    F.append(aspctraio)
    F.append(prop[0].extent)
    F.append(prop[0].solidity )
    F.append(prop[0].equivalent_diameter )
    F.append(prop[0].euler_number)
    F.append(prop[0].perimeter)
    return F
################################################################################
def trans(img):
    F=[]
    for i in range(0,img.shape[0]):
        F.append(np.sum(np.diff(img[0][i:])!=0))
    for i in range(0,img.shape[1]):
        F.append(np.sum(np.diff(img[0][:i])!=0))
    m=0
    for k in range(0,max(F)+1):
        if(m<np.sum(np.asarray(F)==k)):
            m=k
    return F
################################################################################
def RP_CP(sample,R,C):
    theta=np.linspace(0,6.283,C)
    RP=np.zeros([R,1])
    CP=np.zeros([len(theta),1])
    cent=ndimage.measurements.center_of_mass(sample)
    for i in range(1,R):
        for k in range(0,sample.shape[0]-1):
            for j in range(0,sample.shape[1]-1):
                r=((j - round(cent[1]))**2 + (k - round(cent[0]))**2 )
                if r<= i**2 and r>=(i-1)**2:
                        RP[i]=RP[i]+sample[k,j]
    ############################################################################
    for i in range(1,len(theta)-1):
        for k in range(0,sample.shape[0]-1):
            for j in range(0,sample.shape[1]-1):
                cc=round((j - cent[1])*np.tan(theta[i])+  cent[0])
                if k==cc:
                        CP[i]=CP[i]+sample[k,j]
    f=list(RP)
    f.extend(CP)
    return f
################################################################################
def features(data_sample):
    F=structure_features(data_sample)
    test=cv2.resize(data_sample,(50,50))
    ret,thresh1 = cv2.threshold(test,127,255,cv2.THRESH_BINARY)
    hpp=np.sum(thresh1==255,axis=1)
    vpp=np.sum(thresh1==255,axis=0)
    F.extend(trans(thresh1==255))
    F.extend(vpp)
    F.extend(hpp)
    f=RP_CP(thresh1==255,25,25)
    F.extend(f)
    return F

def getFeatures(x):
    F_list=[]
    F_list.append(features(x))
    featureVector=np.asmatrix(F_list)
    return featureVector
