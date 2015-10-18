function [out,results]=dice_roll(objs)

% Set Miss Flag to zero and sum vector to [0,0,0]
miss_flag=0;
sum=[0,0,0];

% Loop for each die which is rolled
    for i=1:length(objs)
        
        % Roll die # i
        results{i}=rolldie(objs(i));

        % If the result is empty (miss), set the miss flag
        if isempty(results{i})
            
            miss_flag=1;
            
        end
        
        % If the miss flag is 0 (attack hasn't missed) go ahead and sum the
        % results of the roll.
        if ~miss_flag
            
            sum=sum+results{i};
            
        end
        
    end

% If the miss flag is set then set the output to be empty
if miss_flag

    out=[];
    results={};

else
    
    % Otherwise pass along the output and results
    out=sum;
    
end
        
        