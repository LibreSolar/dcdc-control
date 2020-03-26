%%
%% Bode plot
%%

% The Octave bode function returns omega (rad/s), so we need to convert to frequency

[mag1, pha1, w1] = bode(G_plant);
f1 = w1 ./ (2*pi);

[mag2, pha2, w2] = bode(G_plant_div);
f2 = w2 ./ (2*pi);

% Magnitude

figure()
subplot (2, 1, 1)
hold on
box on
semilogx (f1/1000, mag2db(mag1))
semilogx (f2/1000, mag2db(mag2))
hold off
axis ("tight")
ylim (__axis_margin__ (ylim))
#ylim ([-50, 20])
xlim ([0.1, 100])
set (gca, "xticklabel", num2str (get (gca, "xtick"), '%g|'))
grid ("on")
title ("Bode plot")
ylabel ("Magnitude (dB)")
set (gca, 'fontsize', 14);
h = legend ("location", "southwest");
set (h, "fontsize", 14);
legend("Plant only", "Plant and voltage div")

% Phase

subplot (2, 1, 2)
hold on
box on
semilogx (f1/1000, pha1)
semilogx (f2/1000, pha2)
hold off
yticks ([45 0 -45 -90 -135 -180 -225 -270])
ylim ([-270, 45])
xlim ([0.1, 100])
set (gca, "xticklabel", num2str (get (gca, "xtick"), '%g|'))
grid ("on")
xlabel ("Frequency (kHz)")
ylabel ("Phase (deg)")
set (gca, 'fontsize', 14);


pause
