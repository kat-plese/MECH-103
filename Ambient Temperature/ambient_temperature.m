clear
clc
close all

% Connect to the Arduino. Specify which pins you connected the
% thermometer output voltage to, and which pin has your LED.
spicyArduino = arduino('COM3','Uno');
tmp36Pin = 'A0';
ledPin = 'D13';

disp('Starting Reading...');
% How to get threshold? read a few voltages from pin from command window
threshold = 0.7; % threshold to turn on LED
dataPoints = 20; % number of data points to capture

% Enter in how long you want the delay to be between readings
delayTime = 0.5;

% This gets the voltage from the arduino
voltage(1) = readVoltage(spicyArduino,tmp36Pin);

for j = 2:dataPoints
    % Read the voltage from the arduino
    voltage(j) = readVoltage(spicyArduino,tmp36Pin);
    
    % Maybe you want to write out the voltage to the computer?
    disp(voltage);
    
    % Check if the temperature being read is greater than threshold
    if voltage(j) >= threshold
        % if above the threshold, turn on the light
        writeDigitalPin(spicyArduino, ledPin, 1);
        
    else
        % or else, turn it off
        writeDigitalPin(spicyArduino, ledPin, 0);

    end
    
    % Pause for delayTime
    pause(delayTime);
    
    % Turns off LED in preparation for the next round
    % If loop is finished, the LED will end OFF
    writeDigitalPin(spicyArduino, ledPin, 0);
    
end

disp('Done reading voltages!');

temperature_c = (1000*voltage-500)/10;

% Figure out how to create a "time" array cooresponding to their delay
time = [delayTime:delayTime:dataPoints*delayTime];

% Plot the temperature data
plot(time, temperature_c, 'b');
axis([delayTime dataPoints*delayTime 0 80]);
title('TMP36');
xlabel('Time (s)');
ylabel('Temperature (C)');

% Convert from C to F
temperature_f = (9/5)*temperature_c + 32;