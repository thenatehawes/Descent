classdef att_result<handle
    %ATT_RESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    % ...hmm, perhaps att_result should just hold att_mods, raw rolls, etc.
    % with additional display properties miss, hearts, etc..
    
    properties(SetAccess=public) % Displayed properties
        miss=0;
        hearts=0;
        surge=0;
        spent_surge=0;
        range=0;
        shields=0;
        damage=0;
        raw_hearts=0;
        raw_surge=0;
        raw_range=0;
        raw_shields=0;
        mod_hearts=0;
        mod_shield=0;
        mod_range=0;
        mod_surge=0;
        mod_condition=[];   
    end
    
    properties(Hidden) % Editted properties
        
        att_mods
        raw_att % hearts, surge, range
        raw_def
        
    end
    
    methods
        
        function obj=att_result(miss,raw_att,raw_def)
            
           if nargin~=0 % if nargin isn't empty
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
            
            obj=update(obj);
            
            end
            
        end
        
        function obj=set.raw_def(obj,input)
            
            if length(input)==3,
                
                obj.raw_def=input;
                obj.raw_shields=input(1);
                
                obj=update(obj);
            
            end
                
        end
        
        function obj=set.spent_surge(obj,input)
           
            obj.spent_surge=input;
            obj=update(obj);
            
        end
        
        function obj=set.att_mods(obj,input)
            
            if ~isempty(input)
            obj.att_mods=input;
            input=sum(input);
            
            obj.mod_hearts=input.mod_heart;
            obj.mod_shield=input.mod_shield;
            obj.mod_range=input.mod_range;
            obj.mod_surge=input.mod_surge;
            
            obj=update(obj);
            end
            
        end
        
        function obj=update(obj)
           
            obj.hearts=obj.raw_hearts+obj.mod_hearts;
            obj.shields=obj.raw_shields+obj.mod_shield;
            obj.range=obj.raw_range+obj.mod_range;
            obj.surge=obj.raw_surge+obj.mod_surge-obj.spent_surge;
            obj.damage=max(obj.hearts-obj.shields,0);
            
        end
                
    end
    
end

