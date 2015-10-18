function [out] = counter(in)
%COUNTER Summary of this function goes here
%   Detailed explanation goes here

% Add [0,0,....,1] to the input
out_tmp=in+[zeros(1,length(in)-1),1];

if all(out_tmp==6)||all(in==6)
    
    out=6*ones(1,length(in));
    
else
    
    while any(out_tmp>6)

        ind=find(out_tmp>6,1,'last');
        out_tmp(ind)=1;
        out_tmp(ind-1)=out_tmp(ind-1)+1;

    end
    
    out=out_tmp;
    
end



end

