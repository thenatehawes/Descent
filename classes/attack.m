classdef attack
    %ATTACK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=private)
        att_dice
        def_dice
        range
        att_mod
        surge_dir
        special
        result
    end
    
    methods
        
        function obj=attack(att_dice,def_dice,range,att_mod,surge_dir,special)
           
            obj.att_dice=att_dice;
            obj.def_dice=def_dice;
            obj.range=range;
            obj.att_mod=att_mod;
            obj.surge_dir=surge_dir;
            obj.special=special;
            
        end
        
        function out=avg_val(obj)
            
            N_att=length(obj.att_dice);
            N_def=length(obj.def_dice);
            N_dice=N_att+N_def;
            N=6^(N_dice);
            
            % Make Inds list
            inds=[ones(1,N_dice-1),0];
            indslist(1,:)=counter(inds);
            
            %% Premake Results
            blank=cell(N,1);
            res=att_result(blank,blank,blank);
            
            for i=1:N,        
            %% Roll Attack
            
            res(i).miss=0;
            res(i).raw_att=[0,0,0];
            for j=1:N_att
        
                if isempty(obj.att_dice(j).side{indslist(i,j)})
                    % Attack misses
                    res(i).raw_att=[0,0,0]; % Raw attack Results stored to result
                    res(i).miss=1;
            
                elseif ~res(i).miss
                    % Attack Hits, keep counting
                    res(i).raw_att=res(i).raw_att+obj.att_dice(j).side{indslist(i,j)};
                end

 
            end
            
            %% Roll Def
            
            res(i).raw_def=[0,0,0];
            for j=1:N_def

                res(i).raw_def=res(i).raw_def+obj.def_dice(j).side{indslist(i,j)}; %

            end
            
            %% Apply Attack Mods
            
            %% Check Range
            
            %% Surge
            
            end
            
            obj.result=result;
            disp(obj)
            out=1;
        end
        
    end
    
end

