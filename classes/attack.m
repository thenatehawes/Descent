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
        
        function out=avg_val(obj)
            
            N_att=length(obj.att_dice);
            N_def=length(obj.def_dice);
            N_dice=N_att+N_def;
            N=6^(N_dice);
            
            % Make Inds list (this creates a list [0,0,...,0 ; 0,0...,1 ; 0,0..1,0])
            inds=[ones(1,N_dice-1),0];
            indslist(1,:)=counter(inds);
            for i=2:N
                indslist(i,:)=counter(indslist(i-1,:));
            end
            
            %% Premake Results
            blank=cell(N,1);
            res=att_result(blank,blank,blank);
            
            for i=1:N,        
            
                %rollattack(obj)
            
            end
            
            out=1;
        end
        
        function out=rollattack(obj,sides)
            
            %% Setup
            
            N_att=length(obj.att_dice);
            N_def=length(obj.def_dice);
            N_dice=N_att+N_def;
            N=6^(N_dice);
            
            % If the sides are specified beforehand, roll all the die now
            % and record the sides
            if nargin==1,
                dice=[obj.att_dice,obj.def_dice];
                for i=N,
                    [~,tmp]=rolldie(dice(i));
                    sides(i)=tmp;
                end
            end
            
            % Premake result
            res=att_result;
            
            %% Roll Attack
            
            res.miss=0;
            res.raw_att=[0,0,0];
            for j=1:N_att
        
                if isempty(obj.att_dice(j).side{sides(j)})
                    % Attack misses
                    res.raw_att=[0,0,0]; % Raw attack Results stored to result
                    res.miss=1;
            
                elseif ~res(i).miss
                    % Attack Hits, keep counting
                    res.raw_att=res.raw_att+obj.att_dice(j).side{sides(j)};
                end

 
            end
            
            %% Roll Def
            
            res.raw_def=[0,0,0];
            for j=1:N_def

                res.raw_def=res.raw_def+obj.def_dice(j).side{sides(N_att+j)}; %

            end
            
            %% Apply Attack Mods
            
            res.mod_hearts=obj.atk_mod.mod_hearts;
            res.mod_shield=obj.atk_mod.mod_shield;
            res.mod_range=obj.atk_mod.mod_range;
            res.mod_surge=obj.atk_mod.mod_surge;
            res.mod_condition=obj.atk_mod.mod_condition;
            
            obj=update(obj);
            
            %% Check Range
            
            if res.range<obj.range
                % Attack will miss unless surge is used
                rangeneeded=obj.range-res.range;
                rangeabilities=find([obj.surge_dir.range]>0); % find all surge abilities that grant enough range
                affordable=find([obj.surge_dir.cost]<=res.surge); % find all affordable surge abilities
                
                helpfullist=intersect(rangeabilities,affordable); % ability is helpful if it gives range & is affordable

                if ~isempty(helpfullist)
                    % Abilities can help
                    
                    % now, I have a list of abilities that can grant range and are affordable
                    helpfulabilities=obj.surge_dir(obj.surge_dir(helpfullist)); % list of helpful abilities
                    
                    while rangeneeded>0||res.surge==0, % loop until you have enough range or you're out of surge
                        
                        % are there any single abilities which grant sufficient range?
                        singleability=find([helpfulabilities.range]==rangeneeded,1,'first');
                        
                        if ~isempty(singleability)
                            % yes, a single ability grants enough range,
                            % pick the first one that does so
                            
                            spend=helpfulabilities(singleability);
                            
                            res.mod_hearts=
                            res.mod_shield=
                            res.mod_range=
                            res.mod_condition=
                            
                            
                            
                        else
                            % no, a single ability cannot grant enough range
                        end
                        
                    end
                    
                    
                    
                    %    if multiple, pick the cheapest, spend that surge
                    % if no
                    % pick the one that gives the most range, spend that surge
                    % repeat the previous steps
                    
                
                
                ind=1;
                min=1000;
                for i=1:length(helpfullist)
                    if helpfullist(i).cost<min,
                        min=helpfullist(i).cost;
                        ind=i;
                    end 
                end
                
                else
                    % Attack will miss
                    res.miss=1;
                    
                end
            end
                
                % if there's more than one choose the cheapest, otherwise
                % choose the first
                
                    
                    
            
            %% Surge
            
        end
        
    end
    
end

