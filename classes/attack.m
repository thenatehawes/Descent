classdef attack<handle
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
            
            
            attdie=[];
            for i=1:length(att_dice)
                attdie=[attdie,die(att_dice{i})];
            end
            defdie=[];
            for i=1:length(def_dice)
                defdie=[defdie,die(def_dice{i})];
            end

            obj.att_dice=attdie;
            obj.def_dice=defdie;
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
        
        function rollattack(obj,sides)
            
            %% Setup
            
            N_att=length(obj.att_dice);
            N_def=length(obj.def_dice);
            N_dice=N_att+N_def;
            N=6^(N_dice);
            nosurge=0;
            if isempty(obj.surge_dir)
                nosurge=1;
            end
            
            % If the sides are specified beforehand, roll all the die now
            % and record the sides
            if nargin==1,
                dice=[obj.att_dice,obj.def_dice];
                for i=1:N_dice,
                    [dc,tmp]=rolldie(dice(i));
                    sides(i)=tmp;
                end
            end
            
            % Premake result and attach to attack
            res=att_result;
            obj.result=res;
            
            %% Roll Attack
            
            res.miss=0;
            res.raw_att=[0,0,0];
            for j=1:N_att
        
                if isempty(obj.att_dice(j).side{sides(j)})
                    % Attack misses
                    res.raw_att=[0,0,0]; % Raw attack Results stored to result
                    res.miss=1;
            
                elseif ~res.miss
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
            
            res.att_mods=obj.att_mod;
            
            %% Check Range
            
            if res.range<obj.range&&~nosurge
                % Attack will miss unless surge is used
                rangeneeded=obj.range-res.range;
                % find all surge abilities that grant enough range
                rangeabilities=find([obj.surge_dir.mod_range]>0); 
                % find all affordable surge abilities
                affordable=find([obj.surge_dir.cost]<=res.surge); 
                
                helpfullist=intersect(rangeabilities,affordable); % ability is helpful if it gives range & is affordable

                if isempty(helpfullist)
                    % Attack will miss
                    res.miss=1;
                     
                else
                    % Abilities can help
                   
                    while rangeneeded>0&&res.surge<=0, % loop until you have enough range or you're out of surge
                        
                        % now, I have a list of abilities that can grant range and are affordable
                        helpfulabilities=obj.surge_dir(helpfullist); % list of helpful abilities
                        
                        % are there any single abilities which grant exactly the right range?
                        singleability=find([helpfulabilities.mod_range]==rangeneeded,1,'first');
                        
                        if ~isempty(singleability)
                            % yes, a single ability grants enough range,
                            % pick the first one that does so
                            
                            spendsurge(obj,helpfulabilities(singleability));
                            
                        else
                            % no, a single ability cannot grant enough range
                            % then spend the cheapest ability
                            
                            [val,ind]=min([helpfulabilities.cost]);
                            spendsurge(obj,helpfulabilities(ind));
                            
                        end
                        
                        % Update range needed & helpfullist
                        affordable=find([obj.surge_dir.cost]<=res.surge); % find all affordable surge abilities
                        rangeabilities=find([obj.surge_dir.mod_range]>0); % find all surge abilities that grant enough range
                        helpfullist=intersect(rangeabilities,affordable); % ability is helpful if it gives range & is affordable

                        rangeneeded=obj.range-res.range;
                    end %endwhile
                
                end %endif
                
            elseif res.range<obj.range&&nosurge    
                res.miss=1;
                
            else
                % attack hits, remove surge mods that ONLY provide range
                rangeonly=find([obj.surge_dir.mod_range]>0&[obj.surge_dir.mod_shield]==0&[obj.surge_dir.mod_heart]==0&[obj.surge_dir.mod_surge]==0&isempty([obj.surge_dir.mod_condition]));
                obj.surge_dir(rangeonly)=[];
                
            end    
            
            %% Spend Surge
            abort=0; % this stops us from spending more surge
            pierce=1; % allow pierce abilities to be used
            while res.surge>0&&~abort&&~nosurge
                
                affordable=find([obj.surge_dir.cost]<=res.surge); % find all affordable surge abilities
                
                if isempty(affordable)
                    abort=1;
                else

                    affordableabilities=obj.surge_dir(affordable);

                    if res.shields<=0
                        pierce=0; % disallow pierce abilities from being used
                    end


                    % spend the first affordable
                    k=1; % timeout variable
                    go=1;
                    while go

                        if affordableabilities(k).mod_shield<0&&pierce==0
                           % You shouldn't spend this ability
                           k=k+1;                    
                        elseif k>length(affordableabilities)
                            % haven't found a suitable ability to spend
                            go=0;
                            abort=1;
                        else
                            % found a good ability, spend it
                            spendsurge(obj,affordableabilities(1));
                            go=0;
                        end % endif

                    end % end while
                    
                end
                
            end % end while
            
        end
        
        function spendsurge(attackobj,surgeability)
            
            % Check cost
            if surgeability.cost>attackobj.result.surge
                error('Surge ability costs more than available surge')
            end
                
            % Add the surge cost to results.spent_surge, results.surge will auto update
            attackobj.result.spent_surge=attackobj.result.spent_surge+surgeability.cost;
            % Add the surge ability to results.att_mod (hidden), this will
            % auto update the modifiers
            attackobj.result.att_mods=[attackobj.result.att_mods,convert(surgeability)];
            % Remove the surge directive from the list of available surge
            % directives.
            attackobj.surge_dir(attackobj.surge_dir==surgeability)=[];
            
        end
    end
    
end

