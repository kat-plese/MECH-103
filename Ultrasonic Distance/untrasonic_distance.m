% File Name: ultrasonic_distance
% Description: 
% Date of Last Modification: 28 October 2020

% MACHEN SIE SAUBER
clear all
close all
clc

% CREATE ARDUINO OBJECT
sensyArduino = arduino('COM3','Uno','libraries','ultrasonic');

TRIG_PIN = 'D5';
ECHO_PIN = 'D10';

ultraSensor = ultrasonic(sensyArduino,TRIG_PIN,ECHO_PIN);

SPEAK_PIN = 'D9';
playTone(sensyArduino,SPEAK_PIN,440,1);
duty_cycle = 0.45;

% INFINITE LOOP
while(1)
    % READ DISTANCE FROM ULTRASONIC SENSOR
    distance = readDistance(ultraSensor)
    
    configurePin(sensyArduino, SPEAK_PIN, 'PWM');
    
    % SERIES OF NESTED IF STATEMENTS DETERMINE LIGHT CONDITIONS
    if distance > 2
        writeDigitalPin(sensyArduino, 'D13', 1); % GREEN ON
        writeDigitalPin(sensyArduino, 'D12', 1); % GREEN ON
        writeDigitalPin(sensyArduino, 'D04', 0); % YELLOW OFF
        writeDigitalPin(sensyArduino, 'D07', 0); % RED OFF
        writeDigitalPin(sensyArduino, 'D02', 0); % RED OFF
    elseif distance <= 2 && distance > 1
        writeDigitalPin(sensyArduino, 'D13', 1);
        writeDigitalPin(sensyArduino, 'D12', 0);
        writeDigitalPin(sensyArduino, 'D04', 0);
        writeDigitalPin(sensyArduino, 'D07', 0);
        writeDigitalPin(sensyArduino, 'D02', 0);
        if distance <= 1.25
            writeDigitalPin(sensyArduino, 'D13', 1);
            writeDigitalPin(sensyArduino, 'D12', 0);
            writeDigitalPin(sensyArduino, 'D04', 1);
            writeDigitalPin(sensyArduino, 'D07', 0);
            writeDigitalPin(sensyArduino, 'D02', 0);
        end
    elseif distance <= 1 && distance > 0.75
        writeDigitalPin(sensyArduino, 'D13', 0);
        writeDigitalPin(sensyArduino, 'D12', 0);
        writeDigitalPin(sensyArduino, 'D04', 1);
        writeDigitalPin(sensyArduino, 'D07', 1);
        writeDigitalPin(sensyArduino, 'D02', 0);
    elseif distance <= 0.75 && distance > 0
        writeDigitalPin(sensyArduino, 'D13', 0);
        writeDigitalPin(sensyArduino, 'D12', 0);
        writeDigitalPin(sensyArduino, 'D04', 0);
        writeDigitalPin(sensyArduino, 'D07', 1);
        writeDigitalPin(sensyArduino, 'D02', 1);
        writePWMDutyCycle(sensyArduino, SPEAK_PIN, duty_cycle);
    end
    
    pause(0.5);
    
    % RESET LIGHTS
    writeDigitalPin(sensyArduino, 'D13', 0); 
    writeDigitalPin(sensyArduino, 'D12', 0); 
    writeDigitalPin(sensyArduino, 'D04', 0); 
    writeDigitalPin(sensyArduino, 'D07', 0); 
    writeDigitalPin(sensyArduino, 'D02', 0);
    playTone(sensyArduino,SPEAK_PIN,0,1);
end

% METERS PER FOOT
conversion = 0.3048;

% EXPERIMENTAL VALUES
D_1 = 1.6;  % GREEN LIGHT MEASURED DISTANCE 
D_2 = 1.15; % YELLOW LIGHT MEASURED DISTANCE
D_3 = 0.95; % 1 RED LIGHT MEASURED DISTANCE
D_4 = 0.7;  % 2 RED LIGHTS MEASURED DISTANCE

% TRUE PERCENT RELATIVE ERROR
E_1 = abs((2 - D_1)/2)*100;
E_2 = abs((1.25 - D_2)/1.25)*100;
E_3 = abs((1 - D_3)/1)*100;
E_4 = abs((0.75 - D_4)/0.75)*100;
