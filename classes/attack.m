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
            
            % Premake result and attach to attack
            res=att_result;
            obj.results=res;
            
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
            
            att_res.att_mod=obj.att_mods;
            
            %% Check Range
            
            if res.range<obj.range
                % Attack will miss unless surge is used
                rangeneeded=obj.range-res.range;
                rangeabilities=find([obj.surge_dir.range]>0); % find all surge abilities that grant enough range
                affordable=find([obj.surge_dir.cost]<=res.surge); % find all affordable surge abilities
                
                helpfullist=intersect(rangeabilities,affordable); % ability is helpful if it gives range & is affordable

                if isempty(helpfullist)
                    % Attack will miss
                    res.miss=1;
                     
                else
                    % Abilities can help
                    
                    % now, I have a list of abilities that can grant range and are affordable
                    helpfulabilities=obj.surge_dir(obj.surge_dir(helpfullist)); % list of helpful abilities
                    
                    while rangeneeded>0||res.surge==0, % loop until you have enough range or you're out of surge
                        
                        % NOTE! Must update helpfulabiliities here
                        
                        % are there any single abilities which grant sufficient range?
                        singleability=find([helpfulabilities.range]==rangeneeded,1,'first');
                        
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
                        
                        rangeneeded=obj.range-res.range;
                    end %endwhile
                    
                end %endif
                
            end    
            
            %% Spend Surge
            
            pierce=1; % allow pierce abilities to be used
            while res.surge>0
                
                affordable=find([obj.surge_dir.cost]<=res.surge); % find all affordable surge abilities
                affordableabilities=obj.surge_dir(affordable);
                
                if res.shield<=0
                    pierce=0; % disallow pierce abilities from being used
                end
                
                % spend the first affordable
                if affordableabilities(1).mod_shield<0&&pierce==0
                   % You shouldn't spend this ability
                   
                else
                    spendsurge(obj,affordableabilities(1));
                end
                
            end % end while
            
        end
        
        function spendsurge(attackobj,surgeability)
            
            % Check cost
            if surgeability.cost>attackobj.results.surge
                error('Surge ability costs more than available surge')
            end
            
            % Add the surge cost to results.spent_surge, results.surge will auto update
            attackobj.results.spent_surge=attackobj.results.spent_surge+surgeability.cost;
            % Add the surge ability to results.att_mod (hidden), this will
            % auto update the modifiers
            attackobj.results.att_mod=[attackobj.results.att_mod,convert(surgeability)];
            % Remove the surge directive from the list of available surge
            % directives.
            attackobj.surge_dir(attackobj.surge_dir==surgeability)=[];
            
        end
    end
    
end

