% File Name: Force Sensitive Resistor
% Creator: Katie Plese
% Date: 20 October 2020

clear;

forceArduino = arduino('COM3','Uno');
FSR_PIN = 'A0';

% Calibrate force sensor based on supplied voltage and the resistance.
% If you have a miltimeter available, measure the actual voltage output of
% the 5V power port on the Arduino. Nest meaesure the resistance across the
% resistor. They should be within 10% of the nominal value.

% If you don't have a multimeter, just use the nominal value.

% Vout = Rm*V/(Rm+Rfsr)
% Vout(Rm+Rfsr) = Rm*V
% Vout*Rm + Vout*Rfsr = Rm*V
% Vout*Rfsr = Rm*V - Rm*Vout
% Rfsr = (Rm*(V-Vout))/Vout

VCC = 5;  % Voltage supplied by Arduino
R_DIV = 9800; % Resistor

% Wait between readings
waitTime = 2;

% Weight of Reference Object -- Cell Phone
ref_object = 0;

% Weight of Bottle
W_0 = 100;

while(1)
    fsrVoltage = readVoltage(forceArduino,FSR_PIN);
    
    if fsrVoltage ~= 0
    
        fsrResistance = (R_DIV*(VCC-fsrVoltage))/fsrVoltage;
        fprintf("Reistance is %f\n",fsrResistance);

        % Compute Conductance -- Inverse the Resistance of FSR
        fsrConductance = 1/fsrResistance;

        % Convert from Conductance to Force
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

% 0.99669 g = 1 cc
% 29.57 cc = 1 fluid ounce
fl_oz = 29.472;

% Theoretical Values
V_1 = (250/fl_oz); % Volume of H20 required to turn on 1 light (>250)

V_2 = (500/fl_oz); % Volume of H20 required to turn on 2 lights (>500)

V_3 = (1000/fl_oz); % Volume of H20 required to turn on 3 lights (>1000)

V_4 = (2000/fl_oz); % Volume of H20 required to turn on 4 lights (>2000)

% Experimental Values
V_1_ex = 10;
V_2_ex = 20;
V_3_ex = 35;
V_4_ex = 70;

% Percent Error=ABS[(Theoretical-Experimental)/Theoretical]*100;
V_1_error = abs((V_1 - V_1_ex)/V_1)*100;
V_2_error = abs((V_2 - V_2_ex)/V_1)*100;
V_3_error = abs((V_3 - V_3_ex)/V_1)*100;
V_4_error = abs((V_4 - V_4_ex)/V_1)*100;