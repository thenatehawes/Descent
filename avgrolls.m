%% Help

% att_dice: cell array of attacking dice colors
% def_dice: cell array of defending dice colors
% att_mod: 1x2 array of attack modifiers which are always applied to the
%        : attack in the form of [shield modifier,heart mod]
%        : e.g. if attack always has +1 heart pierce 3 then enter:
%        : att_mod=[-3,1]

% surge_directives: cell array of attack modifiers in the form
%                 : {attackmod1,attackmod2,....}
%                 : This tells the tool how to spend your surges. Input
%                 : highest priority first. e.g.
%                 : surge_directives={[0,1],[-1,0]} will trade 1 surge for
%                 : 1 heart first, then if there is another surge left to
%                 : spend it will add pierce 1 to the attack.
%%
clear all; close all; clc;
addpath('classes');
%% User Input
tic
att_dice={'b','r','r'}; % Choose attack dice
def_dice={'gry','gry'}; % Choose defense dice

att_mod=[0,0];  % [shield_mod,heart_mod]
                % For pierce, set shield_mod negative

surge_directives={[0,1],[-1,0]}; % 1 surge = [shield_mod,heart_mod]
%surge_directives={[-1,0],[0,1]}; % 1 surge = [shield_mod,heart_mod]
%surge_directives={};

% Solver
N=3e5; % Maximum # of times to roll
tol=1e-6; % Relative tolerance to solve to
min_iter=1000; % Minimum number of iterations before checking for convergence

%% Code
% Create Attack Dice

for i=1:length(att_dice)
     
    a(i)=die(att_dice{i});
    
end

% Create Defense Dice

for i=1:length(def_dice)
     
    d(i)=die(def_dice{i});
    
end

% Pre-make results matrices

att_res=zeros(N,3);
def_res=zeros(N,3);
res=zeros(N,3);

% Loop until convergence or a max of N times
stop=0;
count=0;
avg_res=0;

while ~stop
 
   % Roll att_dice
   out_tmp=dice_roll(a);
   
   if isempty(out_tmp)
       
       % If a dice roll is empty -> Attack Missed
       % Just set this roll's att_res, def_res, and res to [0,0,0]
       
       att_res(count+1,:)=[0,0,0];
       def_res(count+1,:)=[0,0,0];
       res(count+1,:)=[0,0,0];
       
   else
       
       % Otherwise the Attack hit, Check surge directives
       surge_mod=[0,0];
       
       for i=1:min(length(surge_directives),out_tmp(2))
       
            surge_mod=surge_mod+surge_directives{i};
           
       end
       
       % Add Base Heart Modifier
       out_tmp=out_tmp+[att_mod(2),0,0];
       
       % Add Surge Heart Modifier
       out_tmp=out_tmp+[surge_mod(2),0,0];
       
       % Save the attack result
       att_res(count+1,:)=out_tmp;
       
       % Roll def_dice
       out_tmp=dice_roll(d); % Defense Roll
       
       % Add Base Shield Modifier
       out_tmp=out_tmp+[att_mod(1),0,0]; 
       
       % Add Surge Shield Modifier
       out_tmp=out_tmp+[surge_mod(1),0,0];
       
       out_tmp(out_tmp<0)=0; % If more pierce than shields rolled, cap at 0
       
       % Save the defense results
       def_res(count+1,:)=out_tmp; 
       
       % Save to temporary results variable
       res_tmp=att_res(count+1,:)-def_res(count+1,:);
       
       % If any of damage, surge, or range are negative, cap it at zero
       res_tmp(res_tmp<0)=0;
       
       % Save results to results variable
       res(count+1,:)=res_tmp;
       
   end
   
   % Check for convergence
   
   avg_resprev=avg_res;
   avg_res=mean(res(1:count,1));
   
   if count>min_iter
       
       if ~max(avg_res,avg_resprev)
           
           stop=1;
           
       elseif count>N
           
           disp('Did Not Converge')
           disp(['Rel Error: ' num2str(100*abs((avg_res-avg_resprev))/abs(max(avg_res,avg_resprev))) ' %'])
           stop=1;
           
       elseif (abs((avg_res-avg_resprev))/abs(max(avg_res,avg_resprev)))<tol
           
           disp(['Converged in ' num2str(count) ' iterations'])
           stop=1;
           
       end  
       
   end
   
   count=count+1;
   
end

att_res(count:end,:)=[];
def_res(count:end,:)=[];
res(count:end,:)=[];

% Find average attack, def, damage, surge, and range
avg_dmg=mean(res(:,1));
avg_atk=mean(att_res(:,1));
avg_def=mean(def_res(:,1));
avg_surge=mean(res(:,2));
avg_range=mean(res(:,3));

% Display results
disp(['Average Attack Hearts   : ' num2str(avg_atk)])
disp(['Average Defense Shields : ' num2str(avg_def)])
disp(['Average Damage          : ' num2str(avg_dmg)])
disp(['Average Surge           : ' num2str(avg_surge)])
disp(['Average Range           : ' num2str(avg_range)])
toc

