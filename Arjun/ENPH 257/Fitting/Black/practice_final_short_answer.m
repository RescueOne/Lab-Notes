% SHORT ANSWER

% Q3
% rxn: C + O2 -> C02 
enthalpy_CO2 = -393.51/1000; %MJ/mol
M_C = 18/1000; % kg/mol
H_rxn_kg = enthalpy_CO2 / M_C

% Q4
carbon_tax = 30; % $/(tonne CO2e)
% FIND:
% Price of 1 GJ of Natural Gas
% 1 tonne of coal
mass_coal = 1000; %kg
energy_natural_gas = 1; %GJ
M_CH4 = 16; % g/mol
M_CO2 = 44; % g/mol
enthalpy_CH4 = -74.81/1000; %MJ/mol

% Natural Gas rnx: CH4 + 2O2 -> CO2 + 2H2O
H_rxn_mol = (enthalpy_CO2 - enthalpy_CH4) / 1000; % GJ/mol
mol_CH4 = energy_natural_gas / H_rxn_mol; % mol
mol_CO2 = mol_CH4; % mol
mass_CO2 = mol_CO2 * M_CO2 / 1e6; % tonne of CO2e
cost_natural_gas = carbon_tax * mass_CO2 % $

% Coal rxn: C + O2 -> C02
mol_C = mass_coal / M_C; % mol
mol_C02 = mol_C; % mol
mass_CO2 = mol_CO2 * M_CO2 / 1e6; % tonne of CO2e
cost_coal = carbon_tax * mass_CO2 % $