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
            
            if nargin<4,
                shield=0;
                heart=0;
                range=0;
                condition={};
            end
            obj.shield_mod=shield;
            obj.heart_mod=heart;
            obj.range_mod=range;
            obj.condition_mod=condition;
        end
        
        function obj_out=plus(in1,in2)
            
           obj_out=att_mod();
           obj_out.shield_mod=in1.shield_mod+in2.shield_mod;
           obj_out.heart_mod=in1.heart_mod+in2.heart_mod;
           obj_out.range_mod=in1.range_mod+in2.range_mod;
           obj_out.condition_mod=[in1.condition_mod,in2.condition_mod];
            
        end
        
        function obj_out=sum(in)
           
            obj_out=att_mod;
           for i=1:length(in)
              
               obj_out=obj_out+in(i);
               
           end
            
        end
        
    end
    
end

