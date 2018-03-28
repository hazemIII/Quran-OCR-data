function [ output_args ] = NN( input_args )
%NN calls the nueral network module. 
%   input_args is the transposed data from allData.mat (2500*1) single
%   coulmn 2500 row !!
load('all_in_one_network.mat');
output_args = net(input_args);
end

