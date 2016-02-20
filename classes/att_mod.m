classdef att_mod
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mod_shield
        mod_heart
        mod_range
        mod_surge
        mod_condition
    end
    
    methods
        function obj=att_mod(shield,heart,range,surge,condition)
            
            if nargin==0,
                shield=0;
                heart=0;
                range=0;
                surge=0;
                condition=[];
            end
            
            obj.mod_shield=shield;
            obj.mod_heart=heart;
            obj.mod_range=range;
            obj.mod_surge=surge;
            obj.mod_condition=condition;
        end
        
        function obj=plus(moda,modb)
            shield=moda.mod_shield+modb.mod_shield;
            heart=moda.mod_heart+modb.mod_heart;
            range=moda.mod_range+modb.mod_range;
            surge=moda.mod_surge+modb.mod_surge;
            condition=[moda.condition,modb.condition];
            obj=att_mod(shield,heart,range,surge,condition);
        end
        
        function obj=sum(mods)
            
            tmp=att_mod;
            
            for i=1:length(mods)
                tmp=tmp+mods(i);
            end
            
            obj=tmp;
            
        end
           
    end
    
end


