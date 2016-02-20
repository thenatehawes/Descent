% testingscript.m
%
% N.B. Hawes - 02/20/2016
%
% This script tests out the classes made for descent dice roller

clear all; close all; clc;
addpath('classes\')

amod1=att_mod(3,0,0,0,[]); % +3 shield attack modifier
amod2=att_mod(0,2,2,1,[]); % +2 heart, +2 range, +1 surge attack modifier
amod3=att_mod(-2,0,0,0,[]); % +2 pierce attack modifer

amods=[amod1,amod2,amod3]; % create a vector of 3 amods

amods=sum(amods); % create the sum of the attack mods
