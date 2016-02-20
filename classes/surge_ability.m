classdef surge_ability<att_mod
    %SURGE_ABILITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=private)
        cost
    end
    
    methods
        
        function obj=surge_ability(cost,hearts,pierce,range,condition)
            
            obj=obj@att_mod(-pierce,hearts,range,0,condition);
            obj.cost=cost;
            
        end
        
    end
    
end

