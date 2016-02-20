classdef att_result
    %ATT_RESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    % ...hmm, perhaps att_result should just hold att_mods, raw rolls, etc.
    % with additional display properties miss, hearts, etc..
    
    properties(SetAccess=private) % Displayed properties
        miss
        hearts
        surge
        spent_surge
        range
        shields
        damage
        raw_hearts
        raw_surge
        raw_range
        raw_shields
        mod_hearts
        mod_shield
        mod_range
        mod_surge
        mod_condition   
    end
    
    properties(Hidden) % Editted properties
        
        att_mods
        raw_att % hearts, surge, range
        raw_def
        
    end
    
    methods
        
        function obj=att_result(miss,raw_att,raw_def)
            
            if nargin ~=0, % if nargin isn't empty
                m=size(raw_att,1); % m&n are rows/cols of raw_att, this will fail if all 3 inputs are not of same size
                n=size(raw_att,2);

                obj(m,n)=att_result; % premake a ton of empty attack results
                for i=1:m
                    for j=1:n
                        obj(i,j).miss=miss{i,j}; % populate the miss info
                        obj(i,j).raw_att=raw_att{i,j}; % populate the raw_attack info
                        obj(i,j).raw_def=raw_def{i,j}; % populate the raw def info
                    end
                end
            end
            
        end
        
        function obj=set.raw_att(obj,input)
            
            % if user/someone tries to set raw.attack, make sure the input
            % is of length 3
            if length(input)==3
            
                % set raw_att to input, then update raw_hearts, raw_surge,
                % raw_range
            obj.raw_att=input;
            obj.raw_hearts=input(1);
            obj.raw_surge=input(2);
            obj.raw_range=input(3);
            
            end
            
        end
        
        function obj=set.raw_def(obj,input)
            
            if length(input)==3,
                
                obj.raw_def=input;
                obj.raw_shields=input(1);
            
            end
                
        end
        
        function obj=set.att_mods(obj,input)
            
           obj=input+obj; % edit this line
            
        end
        
        function obj=update(obj)
           
            obj.hearts=obj.raw_hearts+obj.mod_hearts;
            obj.shields=obj.raw_shields+obj.mod_shield;
            obj.range=obj.raw_range+obj.mod_range;
            obj.surge=obj.raw_surge+obj.mod_surge;
            
        end
        
        
    end
    
end

