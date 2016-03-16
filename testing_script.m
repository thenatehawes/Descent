% testingscript.m
%
% N.B. Hawes - 02/20/2016
%
% This script tests out the classes made for descent dice roller

clear; close all; clc;
addpath('classes\')

disp('%%%%%%%%%%%%%%%%%%')
disp('% Checking attack modifier class')

amod1=att_mod(3,0,0,0,[]); % +3 shield attack modifier
amod2=att_mod(0,2,2,1,[]); % +2 heart, +2 range, +1 surge attack modifier
amod3=att_mod(-2,0,0,0,[]); % +2 pierce attack modifer

amods=[amod1,amod2,amod3]; % create a vector of 3 amods

amods=sum(amods); % create the sum of the attack mods

if amods.mod_shield==1&&amods.mod_heart==2&&amods.mod_range==2&&amods.mod_surge==1,
    disp('% ...Passed')
    disp('%%%%%%%%%%%%%%%%%%')
else
    disp('% ...Failed')
    disp('%%%%%%%%%%%%%%%%%%')
end

disp('%%%%%%%%%%%%%%%%%%')
disp('% Checking attack results class')

res=att_result;
res.raw_att=[3,0,0];
res.raw_def=[1,0,0];
res.att_mods=amod1;
res.att_mods=[res.att_mods,amod2,amod3];

chka=[5,1,2,2,3,3,0,0,1,2,1,2,1];
chka2=[res.hearts,res.surge,res.range,res.shields,res.damage,res.raw_hearts,res.raw_surge,res.raw_range,res.raw_shields,res.mod_hearts,res.mod_shield,res.mod_range,res.mod_surge];

smod1=surge_ability(1,2,0,0,[]);
smod2=surge_ability(1,0,0,3,[]);
res.att_mods(end+1)=convert(smod1);

chkb=[0,5,1,2,0,5,3,0,0,1,2,-1,2,1];
chkb2=[res.spent_surge,res.hearts,res.surge,res.range,res.shields,res.damage,res.raw_hearts,res.raw_surge,res.raw_range,res.raw_shields,res.mod_hearts,res.mod_shield,res.mod_range,res.mod_surge];

if all(chka==chka2)&&all(chkb==chkb2)
    disp('% ...Passed')
    disp('%%%%%%%%%%%%%%%%%%')
else
    disp('% ...Failed')
    disp('%%%%%%%%%%%%%%%%%%')
end

att_1=attack({'b','y','y'},{'k','k'},4,[],[smod1,smod2],[]);
rollattack(att_1,[5,5,5,2,2]);