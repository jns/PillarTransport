%% Monte-Carlo simulation for average field/potential in pillar

%% 
% Create a Pillar with an n core, and a p shell
% then sample the magnitude of the e-field in r^ and z^

N_samples = 1;
N_shots = 10; % Shots through pillar
N_points = 100; % Points per shot (resolution)

efield_Z = zeros(1, N_points);
efield_R = zeros(1, N_points);

for n=1:N_samples
    fprintf(1,'Iteration %i\n', n);
    p = n_core_p_shell(100*1e-9, 1e16, 150*1e-9, 1e16, 30*1e-9);
    E = shots_through_pillar(p, N_shots, N_points);
    efield_Z = efield_Z + sum(E.fieldZ, 1)/N_shots;
    efield_R = efield_R + sum(E.fieldR, 1)/N_shots;
end
plot(E.points*1e9, efield_Z/N_samples, E.points*1e9, efield_R/N_samples, 'linewidth', 3); 
legend('Z', 'R');
xlabel('Radius (nm)');
ylabel('E-Field (V/m)');
title(sprintf('%i Iterations', N_samples));

figure(2)
clf
plot(E.points*1e9, efield_R/N_samples.*E.points, 'linewidth', 3);
xlabel('Radius (nm)');
ylabel('Potential (V)');
title(sprintf('%i Iterations', N_samples));

% visualize_pillar_3D(p);

% Visualize 10 pillars
% clf
% for i=0:9
% % Choose N random points in Z to cross
% N_random = 10;
% N_points = 100;
% E = shots_through_pillar(p, N_random, N_points);
% 
% % Plot the average
% points = E.points;
% efield_mag_Z= sum(E.fieldZ, 2)/N_random;
% efield_mag_R = sum(E.fieldR, 2)/N_random;
% 
% margin = 0.05;
% stepx = (1-2*margin)/5;
% stepy = (1-2*margin)/2;
% ay = floor(i/5);
% ax = mod(i,5);
% 
% axes('Position', [margin+ax*stepx, margin+ay*stepy,stepx, stepy]); 
% plot(points*1e9,efield_mag_Z, points*1e9, efield_mag_R, 'linewidth', 3);
% ylim([-3e6 3e6]);
% if (ax ~= 0) 
%     set(gca, 'ytick', []);
% end
% if (ay ~= 0)
%     set(gca, 'xtick', []);
% end
% 
% if (ax == 4 && ay == 1)
% legend('Z', 'R');
% end
% % xlabel('radius (nm)');
% % ylabel('E-Field Magnitude (V/m)')
% % title('100nm Core N_D=1e16, 50nm Shell N_A=1e16'); 
% end

