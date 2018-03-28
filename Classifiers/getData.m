function [ output_args ] = getData(i)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load('allData.mat')
output_args = transpose(Data(i,:));
end

