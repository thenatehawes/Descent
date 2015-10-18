classdef die
    %DIE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=private)
        color
        side % [a,b,c]; a=hearts, b=surge, c=range
    end
    
    methods
        
        function obj=die(color)
            
           if nargin>0,
              
               obj.color=color;

               switch color

                   case 'r'

                       obj.side{1}=[2,0,0];
                       obj.side{2}=[4,1,0];
                       obj.side{3}=[1,0,0];
                       obj.side{4}=[2,0,0];
                       obj.side{5}=[2,0,0];
                       obj.side{6}=[3,0,0];

                   case 'b'

                       obj.side{1}=[];
                       obj.side{2}=[2,1,2];
                       obj.side{3}=[2,0,4];
                       obj.side{4}=[1,1,6];
                       obj.side{5}=[1,0,5];
                       obj.side{6}=[2,0,3];

                   case 'y'

                       obj.side{1}=[1,0,2];
                       obj.side{2}=[0,1,1];
                       obj.side{3}=[1,1,0];
                       obj.side{4}=[2,0,0];
                       obj.side{5}=[2,1,0];
                       obj.side{6}=[1,0,1];

                   case 'br'

                       obj.side{1}=[0,0,0];
                       obj.side{2}=[1,0,0];
                       obj.side{3}=[1,0,0];
                       obj.side{4}=[0,0,0];
                       obj.side{5}=[0,0,0];
                       obj.side{6}=[2,0,0];

                   case 'gry'

                       obj.side{1}=[1,0,0];
                       obj.side{2}=[2,0,0];
                       obj.side{3}=[1,0,0];
                       obj.side{4}=[3,0,0];
                       obj.side{5}=[0,0,0];
                       obj.side{6}=[1,0,0];

                   case 'k'

                       obj.side{1}=[3,0,0];
                       obj.side{2}=[2,0,0];
                       obj.side{3}=[4,0,0];
                       obj.side{4}=[0,0,0];
                       obj.side{5}=[2,0,0];
                       obj.side{6}=[2,0,0];

                   case 'empty'

                       obj.side{1}=[0,0,0];
                       obj.side{2}=[0,0,0];
                       obj.side{3}=[0,0,0];
                       obj.side{4}=[0,0,0];
                       obj.side{5}=[0,0,0];
                       obj.side{6}=[0,0,0];

               end
           
           else
               
               obj.color=[];
               obj.side=[];
               
           end
           
        end
        
        function out=rolldie(obj)
            
           out=obj.side{ceil(6*rand)};
            
        end
        
    end
    
end

