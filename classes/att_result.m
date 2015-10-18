classdef att_result
    %ATT_RESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        miss
        hearts
        surge
        range
        shields
        damage
        raw_hearts
        raw_surge
        raw_range
        raw_shields
        spent_surge
        mod_hearts
        mod_pierce
        mod_range
        mod_condition
        
        
    end
    
    properties(Hidden)
       
        raw_att
        raw_def
        
    end
    
    methods
        
        function obj=att_result(miss,raw_att,raw_def)
            
            if nargin ~=0,
                m=size(raw_att,1);
                n=size(raw_att,2);

                obj(m,n)=att_result;
                for i=1:m
                    for j=1:n
                        obj(i,j).miss=miss{i,j};
                        obj(i,j).raw_att=raw_att{i,j};
                        obj(i,j).raw_def=raw_def{i,j};
                    end
                end
            end
            
        end
        
        function obj=set.raw_att(obj,input)
            
            obj.raw_hearts=input(1);
            obj.raw_surge=input(2);
            obj.raw_range=input(3);
            
        end
        
        function obj=set.raw_def(obj,input)
            
            obj.raw_shields=input(1);
            
        end
        
    end
    
end
