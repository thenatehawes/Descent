classdef hero < handle
    %HERO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=Private)
        name
        speed
        maxhp
        maxfatigue
        hp
        fatigue
        equipment
        attributes
        conditions
    end
    
    methods
        
        function obj=hero(name,speed,maxhp,maxfatigue,equipment,attributes)
            
            if nargin==0
                
                obj.name='default';
                obj.speed=[];
                obj.maxhp=[];
                obj.maxfatigue=[];
                obj.hp=[];
                obj.fatigue=[];
                obj.equipment=[];
                obj.attributes=[];
                obj.conditions=[];
                
            else
                
                obj.name=name;
                obj.speed=speed;
                obj.maxhp=maxhp;
                obj.maxfatigue=maxfatigue;
                obj.hp=0;
                obj.fatigue=0;
                obj.equipment=[];
                obj.attributes=attributs;
                obj.conditions=[];
            end
            
        end
        
        function takedamage
            
            
        
    end
    
end

