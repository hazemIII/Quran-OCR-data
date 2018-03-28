########################### import modules needed ##############################
import cv2
import scipy.io as sio
import numpy as np
from skimage.measure import label
from skimage.measure import regionprops
from PIL import Image
################################################################################
######################  functions needed  ######################################
def plot_img(images):
          gg=Image.fromarray(images*255)
          gg.show()
################################################################################
################################################################################
def framextract(imageName,num):
        inputImage=cv2.imread(imageName,0)
        ret,inputImage = cv2.threshold(inputImage,127,255,cv2.THRESH_BINARY)
        kernel = np.ones((15,30),np.uint8)
        smer = cv2.erode(inputImage,kernel,iterations = 1)
        l=label(smer,background=255)
        l_pro=regionprops(l)
        areas=np.zeros(len(l_pro))
        i=0
        for reg in l_pro:
            areas[i]=reg.area
            i=i+1
        x,y=(l==areas.argmax()+1).nonzero()
        l=np.zeros(l.shape)
        l[x,y]=1
        temp=np.zeros(l.shape)
        temp[0:int(l.shape[0]/2),int(l.shape[1]/3):int(l.shape[1]/2)]=(l[0:int(l.shape[0]/2),int(l.shape[1]/3):int(l.shape[1]/2)])
        t,f=(temp.nonzero())
        t=max(t)
        temp=np.zeros(l.shape)
        temp[int(l.shape[0]/3):int(l.shape[0]/2),0:int(l.shape[1]/2)]=(l[int(l.shape[0]/3):int(l.shape[0]/2),0:int(l.shape[1]/2)])
        f,lf=(temp.nonzero())
        lf=max(lf)
        temp=np.zeros(l.shape)
        temp[int(l.shape[0]/3):int(l.shape[0]/2),int(l.shape[1]/2):l.shape[1]-1]=(l[int(l.shape[0]/3):int(l.shape[0]/2),int(l.shape[1]/2):l.shape[1]-1])
        f,r=(temp.nonzero())
        r=min(r)
        temp=np.zeros(l.shape)
        temp[int(l.shape[0]/2):l.shape[0]-1,int(l.shape[1]/3):int(l.shape[1]/2)]=(l[int(l.shape[0]/2):l.shape[0]-1,int(l.shape[1]/3):int(l.shape[1]/2)])
        b,f=(temp.nonzero())
        b=min(b)
        text=inputImage[t:b,lf:r]
        text = 255 - text
        return text