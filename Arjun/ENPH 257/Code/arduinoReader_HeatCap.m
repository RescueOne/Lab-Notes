% ENPH 257
% Stefan Sander-Green, Arjun Venkatesh
% Arduino interface to collect temperature data for an Aluminium Rod
% to measure specific heat Capacity

clc; close all; clear all;

a = arduino();

%mV to Celsius conversion factor
Celsius = 10e-3;

%define temperature sensors as analog inputs
waterTemp = 'A0';
hotWaterTemp = 'A1';
roomTemp= 'A2';

i=0;

tic;


while true
    i = i + 1;
    time(i) = toc;
    T_water(i) = a.readVoltage(waterTemp)/Celsius;
    T_hotWater(i) = a.readVoltage(hotWaterTemp)/Celsius;
    T_amb(i) = a.readVoltage(roomTemp)/Celsius;

    figure(1);
    plot(time, T_water, 'c', time, T_hotWater, 'r', time, T_amb, 'g');
    xlabel('Time (s)');
    ylabel('Temperature (C)');
    legend( 'Water Temp', 'Hot Water Temp', 'Room Temp', 'Location', 'northwest');
    axis([0 inf 0 inf]);
    
    pause(1);
end