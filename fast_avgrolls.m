%% Help
% Stuff
%
%%
clear all; close all; clc;
addpath('classes');
%% User Input
att_dice={'b','r'}; % Choose attack dice
def_dice={'k','gry','gry'}; % Choose defense dice

range=0;
att_mod=[0,0,0];  % [shield_mod,heart_mod,range_mod]
                % For pierce, set shield_mod negative

sorc=0;  % add sorcery to the attack 
surge_directives={}; % 1 surge = [shield_mod,heart_mod,range_mod]

%% Code

% Number of combinations
N_att=length(att_dice);
N_def=length(def_dice);
N_dice=N_att+N_def;
N=6^(N_dice);

% Create Attack Dice

for i=1:N_att
     
    d(i)=die(att_dice{i});
    
end

% Create Defense Dice

for i=N_att+1:N_dice     
    
    d(i)=die(def_dice{i-N_att});
    
end

% Pre-make results matrices

att_res=zeros(N,3);
def_res=zeros(N,3);
res=zeros(N,3);

% Make Inds list
inds=[ones(1,N_dice-1),0];
indslist(1,:)=counter(inds);

for i=2:N
    indslist(i,:)=counter(indslist(i-1,:));
end

% Now use a parfor loop to analyze all possibilities for those attack and
% defense rolls. Make a results tmp variable 

% if matlabpool('size')==0
%     matlabpool open 4
% end


% att_tmp=zeros(N,3);
% def_tmp=zeros(N,3);

%parfor i=1:N %commented so i can step through code
for i=1:N
    
    %% Roll Attack (Count up total hearts,surge,range)
    miss_flag=0;
    att_tmp=[0,0,0];
    for j=1:N_att
        
        if isempty(d(j).side{indslist(i,j)})
            % Attack misses
            att_tmp=[0,0,0];
            miss_flag=1;
            
        elseif ~miss_flag
            % Attack Hits
            att_tmp=att_tmp+d(j).side{indslist(i,j)};
        end

 
    end
    
    %% Roll Def (Count up total shields,~,~)
    def_tmp=[0,0,0];
    for j=N_att+1:N_dice
        
        def_tmp=def_tmp+d(j).side{indslist(i,j)}; %

    end
    
    %% Apply Attack Mods
    
    att_tmp=att_tmp+[att_mod(2),0,att_mod(3)];
    def_tmp=def_tmp+[att_mod(1),0,0];
    
    %% Check range of attack
    % If insufficient range, spend surges or use sorcery to increase attack
    % range. If rolled range exceeds the required range and you have 
    % sorcery, convert some range to damage.
    
    range_needed=0;
    surge_mod=[0,0,0];
    if att_tmp(3)<range && att_tmp(2)>0
        % if attack range is insufficient and you have surge to spend,
        % execute this code. Attack will miss unless surge is spent to add 
        % range, find if any surge directives have a range mod
        range_needed=1;
        
        for j=1:length(surge_directives)
            %loop over all surge directives
            
            if (surge_directives{j}(3)>0)&&(range_needed)&&(att_tmp(2)>0)
                % if this surge directive modifies range, you still need
                % range, and you still have surge left, then apply it
                
                surge_mod=surge_mod+surge_directives{j};       
                att_tmp(2)=att_tmp(2)-1; % Remove 1 fatigue
                
                % check if you need more range
                if att_tmp(3)+surge_mod(3)>=range
                    range_needed=0;
                end
                
            end
            
        end

    end
    
    range_needed=range-att_tmp(3)-surge_mod(3);
    
    if (att_tmp(3)+surge_mod(3)<range)&&att_tmp(1)>=range_needed&&(sorc>range-att_tmp(3)-surge_mod(3))
        % attack will miss unless sorcery is used to add range
        
        att_tmp(3)=att_tmp(3)+range_needed;
        att_tmp(1)=att_tmp(1)-range_needed;
    
    end
    
    if att_tmp(3)>range && sorc>0
        % you have sufficient range, so you should convert range to dmg

        converted=(att_tmp(3)-range)
        
        % att_tmp=att_tmp+[extradamage,0,-extradamage];
        
    end
    
    if att_tmp(3)+surge_mod(3)<range
        % attack misses due to insuff. range
        
        miss_flag=1;
        att_tmp=[0,0,0];
    end    
    
    %% Spend Surges
    % loop over surge directives while the attack still has surges. Apply
    % the surges to the surge_mod.
    
    for j=1:min(length(surge_directives),att_tmp(2))
       
        surge_mod=surge_mod+surge_directives{j};
        %att_tmp(2)=att_tmp(2)-1; % subtract 1 surge
           
    end
    
    att_tmp=att_tmp+[surge_mod(2),0,surge_mod(3)];
    def_tmp=def_tmp+[surge_mod(1),0,0];
    def_tmp(def_tmp<0)=0;
    
    %% Store Result
    % Save the results of the attack after checking to make sure everything
    % is kosher
    
    % Double-check we have the range required
    if att_tmp(3)<range
        error('This code sucks, the attack "passed" but doesnt have range')
    end
    
    att_res(i,:)=att_tmp;
    def_res(i,:)=def_tmp;
    res(i,:)=att_tmp-def_tmp;
   
end

%% Output
att_res(att_res<0)=0;
def_res(def_res<0)=0;
res(res<0)=0;

% Find average attack, def, damage, surge, and range
avg_dmg=mean(res(:,1));
avg_atk=mean(att_res(:,1));
avg_def=mean(def_res(:,1));
avg_surge=mean(res(:,2));
avg_range=mean(res(:,3));

avg_nmdmg=mean(res(N/6+1:end,1));
avg_nmatk=mean(att_res(N/6+1:end,1));
avg_nmdef=mean(def_res(N/6+1:end,1));
avg_nmsurge=mean(res(N/6+1:end,2));
avg_nmrange=mean(res(N/6+1:end,3));

% Display results
disp(['Overall'])
disp(['Average Attack Hearts   : ' num2str(avg_atk)])
disp(['Average Defense Shields : ' num2str(avg_def)])
disp(['Average Damage          : ' num2str(avg_dmg)])
disp(['Average Surge           : ' num2str(avg_surge)])
disp(['Average Range           : ' num2str(avg_range)])
disp(['Excluding Misses'])
disp(['Average Attack Hearts   : ' num2str(avg_nmatk)])
disp(['Average Defense Shields : ' num2str(avg_nmdef)])
disp(['Average Damage          : ' num2str(avg_nmdmg)])
disp(['Average Surge           : ' num2str(avg_nmsurge)])
disp(['Average Range           : ' num2str(avg_nmrange)])
    