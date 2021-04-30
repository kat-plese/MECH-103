% File Name: Musical Buttons
% Creator: Katie Plese
% Date: 30 October 2020
% Last Modified: 4 November 2020

clear all; close all; clc;

musicalArduino = arduino('COM3','Uno');

green_button_pin = 'D13';
blue_button_pin = 'D12';
red_button_pin = 'D09';
yellow_button_pin = 'D10';

green_light = 'D07';
blue_light = 'D06';
red_light = 'D05';
yellow_light = 'D04';

MUSIC_PIN = 'D11';
configurePin(musicalArduino, MUSIC_PIN, 'PWM');

frequency = 4; % flashes per second

condition = 1;

while(condition == 1)
    
    green_button_state = readDigitalPin(musicalArduino, green_button_pin);
    blue_button_state = readDigitalPin(musicalArduino, blue_button_pin);
    red_button_state = readDigitalPin(musicalArduino, red_button_pin);
    yellow_button_state = readDigitalPin(musicalArduino, yellow_button_pin);
    
    if green_button_state == 1
        
        % MUSIC
        num = 0;
        while num < 500
            playTone(musicalArduino, MUSIC_PIN, num, 0.1);
            num = num + 20;
        end
        
        % LIGHTS
        for index = 1:5
            for j = 1:frequency
                writeDigitalPin(musicalArduino, green_light, 0);
                writeDigitalPin(musicalArduino, green_light, 1);
            end
        end
        
        % MUSIC AND LIGHTS ON UNTIL OFF
        while(green_button_state == 1)
            % MUSIC
            num = 0;
            while num < 500
                playTone(musicalArduino, MUSIC_PIN, num, 0.1);
                num = num + 20;
            end
            
            pause(0.25);
            green_button_state = readDigitalPin(musicalArduino, green_button_pin);
            
            if green_button_state ~= 1
                writeDigitalPin(musicalArduino, green_light, 0);
            end
        end
        
    elseif blue_button_state == 1
        
        % MUSIC
        num = 0;
        while num < 800
            playTone(musicalArduino, MUSIC_PIN, num, 0.1);
            num = num + 20;
        end
        while num > 100
            playTone(musicalArduino, MUSIC_PIN, num, 0.1);
            num = num - 15;
        end
        
        % LIGHTS
        for index = 1:5
            for j = 1:frequency
                writeDigitalPin(musicalArduino, blue_light, 0);
                writeDigitalPin(musicalArduino, blue_light, 1);
            end
        end
        
        % MUSIC AND LIGHTS ON UNTIL OFF
        while(blue_button_state == 1)
            % MUSIC
            num = 0;
            while num < 800
                playTone(musicalArduino, MUSIC_PIN, num, 0.1);
                num = num + 20;
            end
            while num > 100
                playTone(musicalArduino, MUSIC_PIN, num, 0.1);
                num = num - 15;
            end
            
            pause(0.25);
            blue_button_state = readDigitalPin(musicalArduino, blue_button_pin);
            
            if blue_button_state ~= 1
                writeDigitalPin(musicalArduino, blue_light, 0);
            end
        end

    elseif red_button_state == 1

        % MUSIC
        num = 500;
        while num > 0
            playTone(musicalArduino, MUSIC_PIN, num, 0.1);
            num = num - 20;
        end
        
        % LIGHTS
        for index = 1:5
            for j = 1:frequency
                writeDigitalPin(musicalArduino, red_light, 0);
                writeDigitalPin(musicalArduino, red_light, 1);
            end
        end
        
        % MUSIC AND LIGHTS ON UNTIL OFF
        while(red_button_state == 1)
            % MUSIC
            num = 500;
            while num > 0
                playTone(musicalArduino, MUSIC_PIN, num, 0.1);
                num = num - 20;
            end
            
            pause(0.25);
            red_button_state = readDigitalPin(musicalArduino, red_button_pin);
            
            if red_button_state ~= 1
                writeDigitalPin(musicalArduino, red_light, 0);
            end
        end
            
    elseif yellow_button_state == 1
        
        % MUSIC
        num = 750;
        while num > 100
            playTone(musicalArduino, MUSIC_PIN, num, 0.1);
            num = num - 25;
        end
        while num < 750
            playTone(musicalArduino, MUSIC_PIN, num, 0.1);
            num = num + 25;
        end
        
        % LIGHTS -- SOMETHING WACK
        for index = 1:5
            for green = 1:5
                writeDigitalPin(musicalArduino, green_light, 1);
                writeDigitalPin(musicalArduino, green_light, 0);
            end
            for blue = 1:5
                writeDigitalPin(musicalArduino, blue_light, 1);
                writeDigitalPin(musicalArduino, blue_light, 0);
            end
            for red = 1:5
                writeDigitalPin(musicalArduino, red_light, 1);
                writeDigitalPin(musicalArduino, red_light, 0);
            end
            for yellow = 1:5
                writeDigitalPin(musicalArduino, yellow_light, 1);
                writeDigitalPin(musicalArduino, yellow_light, 0);
            end
        end
        
    end
    pause(0.25);
    
    % condition = 0;
end