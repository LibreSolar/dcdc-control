%%
%% Plant transfer function (continous time domain)
%%

% Preparation: source config.m before executing this file

pkg load control;
pkg load signal;

%% Plant state space model

% See http://www.ti.com/download/trng/docs/seminar/Topic_7_Hagen.pdf

%   x  = [vC, iL]           state vector
%   u  = Vg                 input vector
%   x' = A*x + B*u          derivative of state vector
%   y  = C*x + D*u          output vector

%   1: on state
%   2: off state

Rpar = (Rload * Rls) / (Rload + Rls);
p1 = -(1 / ((Rload + Rls) * Cls));
p2 =  (Rload / ((Rload + Rls) * Cls));
p3 = -(Rload / ((Rload + Rls) * L));
p4 = -((Rind + Rpar) / L);
p5 = (Rload / (Rload + Rls));

A1 = [p1 p2; p3 p4];        % State matrix A.
A2 = A1;
B1 = [0; (1 / L)];          % Input-to-state matrix B
B2 = [0];
C1 = [p5, Rpar];            % State-to-output matrix C
C2 = C1;
D1 = 0;                     % Feedthrough matrix D
D2 = D1;

% calculate averaged state-space model using duty cycle

A = A1 * duty + A2 * (1 - duty);
B = B1 * duty + B2 * (1 - duty);
C = C1 * duty + C2 * (1 - duty);
D = D1 * duty + D2 * (1 - duty);

%plant = ss(A, B, C, D);

[n_plant, d_plant] = ss2tf(A, B, C, D);

G_plant = tf(n_plant, d_plant);


%% ADC delay (ToDo)

% Exponentials are not handled by Octave control package to include a delay
% Using the Pade approximation for delay seems to be the best work around
% Pade (Octave): https://octave.sourceforge.io/octave/function/padecoef.html
% Pade (Wiki): https://en.wikipedia.org/wiki/Pad%C3%A9_table


%% Divider circuitry

% Documentation here: https://learn.libre.solar/b/dc-control/development/digital_control.html#modelling-the-digital-controller
% Voltage is divided to ADC full scale by divider circuit:

R1 = 100e3;
R2 = 5.6e3;
Cz = 0;         % Previously: Cz = 1e-6;
% Typically not populated as this is not a programmable compensation zero
% Hardware currently does not have Cz.
Rp = (R1 * R2) / (R1 + R2);
Cp = 1 / (2*pi*fs*Rp);      % good attenuation according to paper
Cp = 10e-9;                 % overwrite with actual value in hardware (10nF)

% Gain of the divider

Kdiv = R2 / (R1 + R2);
Vsense = Vls * Kdiv; % The sensed voltage in for control loop. Max voltage is 3.3V.

% Transfer function of the divider circuit:

G_div = tf([R1*Cz 1], [Kdiv*R1*(Cz+Cp) 1]);     % continuous time domain (S domain)

% Plant + divider transfer function

G_plant_div = G_plant * G_div
