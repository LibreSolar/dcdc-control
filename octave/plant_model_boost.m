%%
%% Plant transfer function (continous time domain)
%%

pkg load control;
pkg load signal;

% Select system config parameter file
source config.m

%% Plant state space model

% Transfer function from paper: W. M. Polivka ; P. R.K. Chetty ; R. D. Middlebrook,
% "State-Space Average modelling of converters with parasitics and storage-time modulation"

wa = 1 / (Rhs * Chs);
wo = 1 / sqrt(L * Chs);
Ro = sqrt(L / Chs);
Q = 1 / (Ro / Rload + (Rind + Rhs) / Ro);

s = tf('s');

% Transfer function G_vd = v_out / duty
G_plant = tf(Vhs/duty * (1 + s/wa) / (1 + s / (Q * wo) + (s / wo)^2));

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
Vsense = Vhs * Kdiv; % The sensed voltage in for control loop. Max voltage is 3.3V.

% Transfer function of the divider circuit: Gvs = V_out / V_sense

G_div = tf([R1*Cz 1], [Kdiv*R1*(Cz+Cp) 1]);     % continuous time domain (S domain)

% Plant + divider transfer function

G_plant_div = G_plant * G_div
