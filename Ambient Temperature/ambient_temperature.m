% File Name: ambient_temperature
% Description: MATLAB script designed to utilize a temperature sensor to turn on an LED if abmient is greater than a predetermined threshold.
% Date of Last Modification: 13 October 2020

% MACHEN SIE SAUBER
clear
clc
close all

% CREATE ARDUINO OBJECT
spicyArduino = arduino('COM3','Uno');
tmp36Pin = 'A0';
ledPin = 'D13';

disp('Starting Reading...');
threshold = 0.7;
dataPoints = 20;
delayTime = 0.5;

voltage(1) = readVoltage(spicyArduino,tmp36Pin);

for j = 2:dataPoints
    % READ AND DISPLAY VOLTAGE
    voltage(j) = readVoltage(spicyArduino,tmp36Pin);
    disp(voltage);
    
    % IF TEMPERATURE IS GREATER THAN THRESHOLD, TURN ON LIGHT, ELSE TURN OFF
    if voltage(j) >= threshold
        writeDigitalPin(spicyArduino, ledPin, 1);
    else
        writeDigitalPin(spicyArduino, ledPin, 0);
    end
    
    % PAUSE FOR DELAY TIME 
    pause(delayTime);
    
    % TURN OFF LED
    writeDigitalPin(spicyArduino, ledPin, 0);
end

disp('Done reading voltages!');

temperature_c = (1000*voltage-500)/10;

% TIME ARRAY
time = [delayTime:delayTime:dataPoints*delayTime];

% PLOT TEMPERATURE DATA
plot(time, temperature_c, 'b');
axis([delayTime dataPoints*delayTime 0 80]);
title('TMP36');
xlabel('Time (s)');
ylabel('Temperature (C)');

% CONVERT C TO F
temperature_f = (9/5)*temperature_c + 32;
