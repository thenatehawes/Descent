clear all; close all; clc;

a=[0,3,1,2,1,1];
b=[3,2,4,2,2,0];
k=1;

for i=1:length(a),
    for j=1:length(b),
        t(k)=a(i)+b(j);
        k=k+1;
    end
end

for i=1:5
    pct(i)=length(find(t<=i))/36*100;
end