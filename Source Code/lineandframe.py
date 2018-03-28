########################### import modules needed ##############################
import cv2
import math
import scipy.io as sio
import numpy as np
from scipy import signal
from matplotlib import pyplot as plt
from skimage.measure import label
from skimage.measure import regionprops
import glob, os
import time
from PIL import Image
import mat4py
#from sklearn.externals import joblib
import features_test
import SVMtest
################################################################################
######################  functions needed  ######################################
def plot_img(images):
          gg=Image.fromarray(images*255)
          gg.show()
################################################################################
################################################################################
def framextract(imageName):
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
        return text==0
################################################################################
################################################################################
def find_wa2f_shapes(shape):
    #plot_img(shape)
    features = features_test.getFeatures(255*np.asarray(shape,dtype='uint8'))
    [predict,labels] = SVMtest.classify(features)
    labels=labels[[9,3,8,13,12]]
    if predict in labels:
        return True
    else :
        return False
################################################################################
def souraNameFrameExtraction(textImage,numberOfLines,lineHight,souraNameFrameLength):
    flag=0
    delRaws=[]
    count=0
    for i in range(0,textImage.shape[0]):
        numberOfLabels=sum(np.diff(textImage[i][:])!=0)
        if numberOfLabels==2 and (sum(textImage[i][:]==1)>(.5*textImage.shape[1])):
            if flag==0:
                count+=1
            flag=1
        elif numberOfLabels==0:
            flag=0
        if flag==1:
            delRaws.append(i)
    textImage=np.delete(textImage,delRaws,0)
    numberOfLines=numberOfLines-count
    return numberOfLines,textImage
################################################################################
################################################################################
def find_peaks(image,numberOfLines):
    deleRaws=[]
    for i in range(0,image.shape[0]):
        if (sum(image[i][:])==0) or (sum(image[i][:])==image.shape[1]):
            deleRaws.append(i)
        else: break
    list1= range(0,image.shape[0])
    list1.reverse()
    for i in list1:
        if (sum(image[i][:])==0) or (sum(image[i][:])==image.shape[1]):
            deleRaws.append(i)
        else: break
    image=np.delete(image,deleRaws,0)
    lines_hieght=int(round(image.shape[0]/numberOfLines))
    baseLines1=[]
    section=np.linspace(0, image.shape[0], num=numberOfLines+1)
    section=map(int,section)
    section2=section[1:]
    for i,k in zip(section[0:len(section)-1],section2):
        profile=np.sum(image[i:k,:],axis=1)
        baseline=np.argmax(profile)
        baseLines1.append(i+baseline)
    separationLine=np.zeros(numberOfLines-1)
    for i in range(0,numberOfLines):
            if(i!=numberOfLines-1):
                separationLine[i]=int((baseLines1[i+1]-baseLines1[i])/2)+baseLines1[i]
    return [baseLines1,separationLine],image
################################################################################
################################################################################
def lineSegmantation(inputText,basicsLines):
    baseLines1=basicsLines[0]
    numberOfLines=len(baseLines1)
    spearationLines=basicsLines[1]
    labeledImage,numberOfLabels=label(inputText,background=0,return_num =True)
    labeledImageProperties=regionprops(labeledImage+1)
    componentList=np.zeros(numberOfLabels)
    k=-1
    for comp in labeledImageProperties:
        k+=1
        up=comp.bbox[0]
        down=comp.bbox[2]
        left=comp.bbox[1]
        right=comp.bbox[3]
        w=right-left
        h=down-up
        if (h<2 or w<2):
            continue
        cent=comp.centroid
        cent_y=int(cent[0])
        cent_x=int(cent[1])
        dis=[]
        ccImage=comp.image
        for line in baseLines1:
            dis.append(abs(cent_y-line))
        ind=np.argmin(dis)
        if(ind!=numberOfLines-1):
            if(abs(cent_y-spearationLines[ind])>abs(cent_y-baseLines1[ind])):
                componentList[k]=ind+1
            elif(find_wa2f_shapes(np.asmatrix(ccImage))):
                componentList[k]=ind+2
            else:
                upcount=0
                downcount=0
                for i in range(down,baseLines1[ind+1]):
                    if(np.sum(np.asmatrix(inputText)[i,left:right],axis=1)==0):
                        downcount+=1
                    else:
                        break
                list1= range(baseLines1[ind],up)
                list1.reverse()
                for i in list1:
                    if(np.sum(np.asmatrix(inputText)[i,left:right],axis=1)==0):
                        upcount+=1
                    else:
                        break
                if(upcount<downcount):
                    componentList[k]=ind+1
                else:
                    componentList[k]=ind+2
        else:
            componentList[k]=ind+1
    lines=[]
    for i in range(1,numberOfLines+1):
        temp=np.zeros(inputText.shape,dtype=np.int8)
        j=-1
        for c in componentList:
            j=j+1
            if(c==i):
                temp[labeledImageProperties[j].coords[:,0],labeledImageProperties[j].coords[:,1]]=1
        [raw,col]=np.nonzero(temp)
        lines.append(temp[min(raw):max(raw),:])
    return lines
################################################################################
def main(pageNumberOfLines,pageName,souraNameHeight):
    inputImage=framextract(pageName)
    lineHeight=int(np.asarray(inputImage).shape[0]/pageNumberOfLines)
    N,text=souraNameFrameExtraction(np.asarray(inputImage),pageNumberOfLines,lineHeight,souraNameHeight)
    bases,image= find_peaks(np.asarray(text),N)
    lines=lineSegmantation(np.asarray(image),bases)
    sio.savemat("lines.mat",mdict={"lines":np.asarray(lines)})

