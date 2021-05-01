% File Name: force_sensitive_resistor
% Description: MATLAB script designed to utilize a force sensor to detect distances through electrical resistance.
% Date of Last Modification: 20 October 2020

% MACHEN SIE SAUBER
clear;

% CREATE ARDUINO OBJECT
forceArduino = arduino('COM3','Uno');
FSR_PIN = 'A0';

% VOLTAGE SUPPLIED BY ARDUINO
VCC = 5; 

% RESISTOR
R_DIV = 9800;

% PAUSE BETWEEN READINGS
waitTime = 2;

% WEIGHT OF REFERENCE OBJECT -- CELL PHONE
ref_object = 0;

% WEIGHT OF OBJECT -- BOTTLE
W_0 = 100;

while(1)
    fsrVoltage = readVoltage(forceArduino,FSR_PIN);
    
    if fsrVoltage ~= 0
    
        fsrResistance = (R_DIV*(VCC-fsrVoltage))/fsrVoltage;
        fprintf("Reistance is %f\n",fsrResistance);

        % COMPUTE CONDUCTANCE -- INVERSE RESISTANCE OF FSR
        fsrConductance = 1/fsrResistance;

        % CONVERT FROM CONDUCTANCE TO FORCE
        if fsrResistance <= 600
            force = (fsrConductance-7.4E-4)/3.2639E-7;
        else
            force = fsrConductance/6.42857E-7;
        end
        
        fprintf("\tThe force is %f\n",force);
        
        writeDigitalPin(forceArduino, 'D07', 1); 
        writeDigitalPin(forceArduino, 'D06', 0); 
        writeDigitalPin(forceArduino, 'D05', 0); 
        writeDigitalPin(forceArduino, 'D04', 0); 
        writeDigitalPin(forceArduino, 'D03', 0);
        
        if force > (2000 + W_0)
            writeDigitalPin(forceArduino, 'D07', 0); 
            writeDigitalPin(forceArduino, 'D06', 1); 
            writeDigitalPin(forceArduino, 'D05', 1); 
            writeDigitalPin(forceArduino, 'D04', 1); 
            writeDigitalPin(forceArduino, 'D03', 1); 
        elseif force <= (2000 + W_0) && force > (1000 + W_0)
            writeDigitalPin(forceArduino, 'D07', 0); 
            writeDigitalPin(forceArduino, 'D06', 1); 
            writeDigitalPin(forceArduino, 'D05', 1); 
            writeDigitalPin(forceArduino, 'D04', 1); 
            writeDigitalPin(forceArduino, 'D03', 0); 
        elseif force <= (1000 + W_0) && force > (500 + W_0)
            writeDigitalPin(forceArduino, 'D07', 0);
            writeDigitalPin(forceArduino, 'D06', 1); 
            writeDigitalPin(forceArduino, 'D05', 1); 
            writeDigitalPin(forceArduino, 'D04', 0);
            writeDigitalPin(forceArduino, 'D03', 0);
        elseif force <= (500 + W_0) && force > (250 + W_0)
            writeDigitalPin(forceArduino, 'D07', 0);
            writeDigitalPin(forceArduino, 'D06', 1); 
            writeDigitalPin(forceArduino, 'D05', 0); 
            writeDigitalPin(forceArduino, 'D04', 0);
            writeDigitalPin(forceArduino, 'D03', 0);
        end
        
        pause(waitTime);
    else 
        force = 0;
        fprintf("No resistance detected\n");
        pause(waitTime);
    end
end

fl_oz = 29.472;

% THEORETICAL VALUES
% VOLUME OF H2O REQUIRED TO TURN ON 1 LIGHT (>250)
V_1 = (250/fl_oz);
% VOLUME OF H2O REQUIRED TO TURN ON 2 LIGHTS (>500)
V_2 = (500/fl_oz);
% VOLUME OF H2O REQUIRED TO TURN ON 3 LIGHTS (>1000)
V_3 = (1000/fl_oz);
% VOLUME OF H2O REQUIRED TO TURN ON 4 LIGHTS (>2000)
V_4 = (2000/fl_oz);

% EXPERIMENTAL VALUES
V_1_ex = 10;
V_2_ex = 20;
V_3_ex = 35;
V_4_ex = 70;

% TRUE PERCENT RELATIVE ERROR Percent
V_1_error = abs((V_1 - V_1_ex)/V_1)*100;
V_2_error = abs((V_2 - V_2_ex)/V_1)*100;
V_3_error = abs((V_3 - V_3_ex)/V_1)*100;
V_4_error = abs((V_4 - V_4_ex)/V_1)*100;
