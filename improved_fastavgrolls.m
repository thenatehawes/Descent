% improved_fastavgrolls.m
% N.B. Hawes
% 10/17/2015
%
% This script has been written to take advantage of the new attack class
% and to find the average attack value for several given inputs.

%% Setup
clear; close all; clc;
addpath('classes');
%% User Input
att_dice={'b','r'}; % Choose attack dice
def_dice={'k','gry','gry'}; % Choose defense dice

range=0;
atk_mod=[0,0,0];  % [shield_mod,heart_mod,range_mod]
                % For pierce, set shield_mod negative

sorc=0;  % add sorcery to the attack 
surge_directives={}; % 1 surge = [shield_mod,heart_mod,range_mod]
special={};
%% Code

% Create Attack Dice

for i=1:length(att_dice)
     
    ad(i)=die(att_dice{i});
    
end

% Create Defense Dice

for i=1:length(def_dice)    
    
    dd(i)=die(def_dice{i});
    
end

% Create attack modifier

mod=att_mod(atk_mod(1),atk_mod(2),atk_mod(3),[]);% [shield_mod,heart_mod,range_mod]

% Create Attack Object & Run avg Val

att=attack(ad,dd,range,mod,surge_directives,special);
avgout=avg_val(att);
disp(att);



