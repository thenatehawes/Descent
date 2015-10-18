classdef weapon
    %WEAPON Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=private)
        
        name
        dice
        base_attack_mods
        surge_directives
        
    end
    
    methods
        
        function obj=weapon(name,dice,basemods,surgedirs)
            
            if nargin>0
                
                obj.name=name;
                
                for i=1:length(dice)
     
                    a(i)=die(dice{i});
    
                end
                
                obj.dice=a;
                obj.base_attack_mods=basemods;
                obj.surge_directives=surgedirs;
                
                
            else
                
                obj.name='default';
                obj.dice=[];
                obj.base_attack_mods=[];
                obj.surge_directives=[];
                
            end
            
        end
        
        function att_output=attack(weapon)
           
            % Roll Dice
            att_tmp=dice_roll(weapon.dice);
            
            if isempty(att_tmp)
                
                att_output=[0,0,0];
                
            else
            
                % Apply Base Modifications
                att_tmp=att_tmp+[weapon.base_attack_mods(2),0,0];

                % Spend Surges

                surge_mod=[0,0];

                for i=1:min(length(weapon.surge_directives),att_tmp(2))

                    surge_mod=surge_mod+weapon.surge_directives{i};

                end

                att_output=att_tmp+[surge_mod(2),0,0];
                disp(['Pierce: ' num2str(-(weapon.base_attack_mods(1)+surge_mod(1)))]);
                
            end
            
            
        end
        
    end
    
end

