%% Help
% Stuff I added some help to this file now.
%
%%
clear; close all; clc;
addpath('classes');
%% User Input
att_dice={'b','r'}; % Choose attack dice
def_dice={'k','gry','gry'}; % Choose defense dice

range=0;
att_mod=[0,0,0];  % [shield_mod,heart_mod,range_mod]
                % For pierce, set shield_mod negative

sorc=0;  % add sorcery to the attack 
surge_directives={}; % 1 surge = [shield_mod,heart_mod,range_mod]
special={};

%% New stuff

%% Code

% Create Attack Dice

for i=1:length(att_dice)
     
    ad(i)=die(att_dice{i});
    
end

% Create Defense Dice

for i=1:length(def_dice)    
    
    dd(i)=die(def_dice{i});
    
end

% Create Attack Object & Run avg Val

att=attack(ad,dd,range,att_mod,surge_directives,special);
avg_val(att);
disp(att);



