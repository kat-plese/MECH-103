% File Name: Ultrasonic 9
% Name: Katie Plese
% Date: 28 October 2020

clear all
close all
clc

sensyArduino = arduino('COM3','Uno','libraries','ultrasonic');

TRIG_PIN = 'D5';
ECHO_PIN = 'D10';

ultraSensor = ultrasonic(sensyArduino,TRIG_PIN,ECHO_PIN);

SPEAK_PIN = 'D9';
playTone(sensyArduino,SPEAK_PIN,440,1);
duty_cycle = 0.45;

% This while loop will run forever, so we will stick our distance reading,
% LED lighting, and noise making inside of here

while(1)
    % Read the distance from the ultrasonic sensor
    distance = readDistance(ultraSensor)
    
    % This PIN is shite
    configurePin(sensyArduino, SPEAK_PIN, 'PWM');
    
    % Use nested if statements to check distance and decide
    % which lights, if any, need to go on.
    if distance > 2
        writeDigitalPin(sensyArduino, 'D13', 1); % green on
        writeDigitalPin(sensyArduino, 'D12', 1); % green on
        writeDigitalPin(sensyArduino, 'D04', 0); % yellow off
        writeDigitalPin(sensyArduino, 'D07', 0); % red off
        writeDigitalPin(sensyArduino, 'D02', 0); % red off
    elseif distance <= 2 && distance > 1
        writeDigitalPin(sensyArduino, 'D13', 1); % green on
        writeDigitalPin(sensyArduino, 'D12', 0); % green off
        writeDigitalPin(sensyArduino, 'D04', 0); % yellow off
        writeDigitalPin(sensyArduino, 'D07', 0); % red off
        writeDigitalPin(sensyArduino, 'D02', 0); % red off
        if distance <= 1.25
            writeDigitalPin(sensyArduino, 'D13', 1); % green on
            writeDigitalPin(sensyArduino, 'D12', 0); % green off
            writeDigitalPin(sensyArduino, 'D04', 1); % yellow on
            writeDigitalPin(sensyArduino, 'D07', 0); % red off
            writeDigitalPin(sensyArduino, 'D02', 0); % red off
        end
    elseif distance <= 1 && distance > 0.75
        writeDigitalPin(sensyArduino, 'D13', 0); % green off
        writeDigitalPin(sensyArduino, 'D12', 0); % green off
        writeDigitalPin(sensyArduino, 'D04', 1); % yellow on
        writeDigitalPin(sensyArduino, 'D07', 1); % red on
        writeDigitalPin(sensyArduino, 'D02', 0); % red off
    elseif distance <= 0.75 && distance > 0
        writeDigitalPin(sensyArduino, 'D13', 0); % green off
        writeDigitalPin(sensyArduino, 'D12', 0); % green off
        writeDigitalPin(sensyArduino, 'D04', 0); % yellow off
        writeDigitalPin(sensyArduino, 'D07', 1); % red on
        writeDigitalPin(sensyArduino, 'D02', 1); % red on
        writePWMDutyCycle(sensyArduino, SPEAK_PIN, duty_cycle);
    end
    
    pause(0.5);
    
    writeDigitalPin(sensyArduino, 'D13', 0); 
    writeDigitalPin(sensyArduino, 'D12', 0); 
    writeDigitalPin(sensyArduino, 'D04', 0); 
    writeDigitalPin(sensyArduino, 'D07', 0); 
    writeDigitalPin(sensyArduino, 'D02', 0);
    playTone(sensyArduino,SPEAK_PIN,0,1);
end

conversion = 0.3048; % meters per foot

% Experimental Meters
D_1 = 1.6; % measured distance for 1 green light
D_2 = 1.15; % measured distance for 1 yellow light
D_3 = 0.95; % measured distance for 1 red light
D_4 = 0.7; % measured distance for  2 red lights

% Percent Error
E_1 = abs((2 - D_1)/2)*100;
E_2 = abs((1.25 - D_2)/1.25)*100;
E_3 = abs((1 - D_3)/1)*100;
E_4 = abs((0.75 - D_4)/0.75)*100;