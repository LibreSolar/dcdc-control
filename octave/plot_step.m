%%
%% Step response
%%

[y1, t1, x1] = step(G_plant);

[y2, t2, x2] = step(G_plant_div);

figure()
hold on;
box on;
plot(t1*1000, y1);
plot(t2*1000, y2);
hold off;
grid ("on")
title('Step response')
h = legend("Plant only", "Plant and voltage div");
set (h, "fontsize", 14);
xlabel ("Time (ms)")
ylabel ("Magnitude (-)")
set (gca, 'fontsize', 14);

pause
