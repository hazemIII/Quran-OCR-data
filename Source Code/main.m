clc;clear;close all;

% img=imread('images/img (1).jpg');
% [text,rect]=imcrop(img);
% len=rect(4)/2;
% width=rect(3)/2;

name = strcat('images/img (',int2str(1),').jpg');
img = imread(name);
binimg = im2bw(img,0.85);
conncomp = bwconncomp(binimg);
per = cell2mat(struct2cell(regionprops(conncomp,'Perimeter')));
req = per(305);


for i=1:602
    sent = strcat('page ',int2str(i));
    disp(sent);
    name=strcat('images/img (',int2str(i),').jpg');
    img=imread(name);
    binimg=im2bw(img,.85);
    binimg=tiltCorrect(~binimg);
    text=knn(binimg,req);
    name=strcat('imagesWithoutFrame/text (',int2str(i),').mat');
    save(name,'text');
end
