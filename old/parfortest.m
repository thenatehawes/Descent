clear all; close all; clc;

if matlabpool('size')==0
    matlabpool open 4
end

parfor i=1:50
    
    a=i;
    
    b(i)=a.^2;
    
end