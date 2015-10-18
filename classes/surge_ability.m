classdef surge_ability
    %SURGE_ABILITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=private)
        cost
        hearts
        pierce
        range
        conditions
    end
    
    methods
        
        function obj=surge_ability(cost,hearts,pierce,range,condition)
            
            obj.cost=cost;
            obj.hearts=hearts;
            obj.pierce=pierce;
            obj.range=range;
            obj.conditions=condition;
            
        end
        
    end
    
end

