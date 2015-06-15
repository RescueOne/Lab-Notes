% Arjun Venkatesh, Stefan Sander-Green
% ENPH 257 - Lab 
% June 12, 2015

m_H2O = 1; %kg
dm_H2O = 0.010; %kg, uncertainty
m_Al = 0.32125; %kg

Cp_H2O = 4.183e3; %J/(kg*K)
T_0_Al = mean(T_hotWater(505:531))
T_0_H2O = mean(T_water(84:496))
T_f = mean(T_water(1321:1600))

Q = -Cp_H2O*m_H2O*(T_f - T_0_H2O)

Cp_Al = Q/(m_Al*(T_f - T_0_Al))