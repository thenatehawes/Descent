classdef surge_ability<att_mod
    %SURGE_ABILITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=private)
        cost
    end
    
    methods
        
        function obj=surge_ability(cost,pierce,heart,range,condition)
            
            obj=obj@att_mod(-pierce,heart,range,0,condition);
            obj.cost=cost;
            
        end
        
        function objout=convert(obj)
            
            objout=att_mod(obj.mod_shield,obj.mod_heart,obj.mod_range,obj.mod_surge,obj.mod_condition);
            
        end
        
    end
    
end

