classdef att_mod
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        shield_mod
        heart_mod
        range_mod
        condition_mod
    end
    
    methods
        function obj=att_mod(shield,heart,range,condition)
            obj.shield_mod=shield;
            obj.heart_mod=heart;
            obj.range_mod=range;
            obj.condition_mod=condition;
    end
    
end

