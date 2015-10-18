classdef attack
    %ATTACK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=private)
        att_dice
        def_dice
        range
        atk_mod
        surge_dir
        special
        result
    end
    
    methods
        
        function obj=attack(att_dice,def_dice,range,atk_mod,surge_dir,special)
           
            obj.att_dice=att_dice;
            obj.def_dice=def_dice;
            obj.range=range;
            obj.atk_mod=atk_mod;
            obj.surge_dir=surge_dir;
            obj.special=special;
            
        end
        
        function out=perform(obj,override)
            
            % Setup
            N_att=length(obj.att_dice); % # of attack dice
            N_def=length(obj.def_dice); % # of def dice
            N_dice=N_att+N_def; % # of dice
            res=att_result(); % premake result
            
            if nargin==1,
               % If an override is not provided we randomly choose the dice
               % side results and store them in the "override" variable
               override=ceil(6*rand(1,N_dice)); 
                
            end
            
            %% Roll Attack
            
            res.miss=0;
            res.raw_att=[0,0,0];
            for j=1:N_att
                
                tmp=rolldie(obj.att_dice(j),override(j));
        
                if isempty(tmp)
                    % Attack misses
                    res.raw_att=[0,0,0]; % Raw attack Results stored to result
                    res.miss=1;
            
                elseif ~res.miss
                    % Attack Hits, keep counting
                    res.raw_att=res.raw_att+tmp;
                end

 
            end
            
            %% Roll Def
            
            res.raw_def=[0,0,0];
            for j=N_att+1:N_dice

                res.raw_def=res.raw_def+rolldie(obj.def_dice(j-N_att),override(j));

            end
            
            %% Apply Attack Mods
            
            attackmods=sum(obj.atk_mod);
            res.mod_hearts=attackmods.heart_mod; % Setting these will modify res.hearts and others
            res.mod_shield=attackmods.shield_mod;
            res.mod_range=attackmods.range_mod
            res.mod_condition=attackmods.condition_mod;
            
            %% Check Range
            
            if obj.range<res.range,
                % Attack will miss unless something happens
                
            else
                
            end
            
            %% Surge
            
            out=1;
        end
        
        function out=avg_val(obj)
            
            N_att=length(obj.att_dice);
            N_def=length(obj.def_dice);
            N_dice=N_att+N_def;
            N=6^(N_dice);
            
            % Make Inds list
            inds=[ones(1,N_dice-1),0];
            indslist(1,:)=counter(inds);
            for i=2:N
                indslist(i,:)=counter(indslist(i-1,:));
            end
            
            %% Premake Results
            blank=cell(N,1);
            res=att_result(blank,blank,blank);
                 
            
        end
        
    end
    
end

