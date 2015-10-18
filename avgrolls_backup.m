%%
clear all; close all; clc;
addpath('classes');
%% User Input 

att_dice={'b','r'}; % Choose attack dice
def_dice={'gry','gry'}; % Choose defense dice

att_mod=[0,0];  % [shield_mod,heart_mod]
                % For pierce, set shield_mod negative

% Solver
N=1e5; % Maximum # of times to roll
tol=1e-6; % Relative tolerance to solve to
min_iter=100; % Minimum number of iterations before checking for convergence

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
       
       % Otherwise the Attack hit, save the attack results
       
       att_res(count+1,:)=out_tmp+[att_mod(2),0,0]; % Attack Roll + Heart Modifier
       
       % Roll def_dice
       out_tmp=dice_roll(d); % Defense Roll
       out_tmp=out_tmp+[att_mod(1),0,0]; % Shield Modifier
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

