%% Measure the dynamics in a pillar



N_samples = 10;
T_step = 5e-14; % The time step of the simulation
N_steps= 50; % Number of time steps to evolve

% Define pillar dimension and donor/acceptor concentrations
core_diam = 80*1e-9;
shell1_diam = 120*1e-9;
shell_diam = 160*1e-9;
height = 30*1e-9;
Nd = 1e16;
Na = 2e16;

% Setup data structures for capturing electron and hole densities
bins = linspace(0, shell_diam/2*1e9, 15);
n = zeros(1,length(bins));
p = zeros(1, length(bins));
z_crossings_n = zeros(1, length(N_samples));
z_crossings_p = zeros(1, length(N_samples));

for iter=1:N_samples
    fprintf(1,'Iteration %i\n', iter);
%     pillar = n_core_p_shell(core_diam, Nd, shell_diam, Na, height);
    pillar = i_core_n_shell_p_shell(core_diam, shell1_diam, Nd, shell_diam, Na, height);
    output=move_free_charge(pillar, N_steps, T_step);
    
    %    visualize_pillar_3D(p);
    %    hold all;
    
    % build a probability density for electrons
    n_charges = size(output.charges,1);
    for c = 1:n_charges
        x = output.x(c,:)*1e9;
        y = output.y(c,:)*1e9;
        z = output.z(c,:)*1e9;
        %    plot3(x,y,z, 'linewidth', 2);
        r = sqrt(x.^2 + y.^2);
        if (output.charges(c) > 0)
            p = p + histc(r, bins);
            z_crossings_p(iter) = output.z_crossings(c);
        else
            n = n + histc(r, bins);
            z_crossings_n(iter) = output.z_crossings(c);
        end
    end
end


clf
hold all;
n_prob = 0.5*n/sum(n); % divide by 2 because only represents half the pillar
p_prob = 0.5*p/sum(p);
n_density = n_prob*pillar.electron_count/pillar.volume;
p_density = p_prob*pillar.hole_count/pillar.volume;
stairs(bins, n_density);
stairs(bins, p_density);
legend('n', 'p', 'location', 'NorthWest');
xlabel('Radius (nm)');
ylabel('Carrier Density (cm^{-3}) ');
hold on
plot([core_diam*1e9/2 core_diam*1e9/2], [0 1e15], 'k--')
plot([shell_diam*1e9/2 shell_diam*1e9/2], [0 1e15], 'k--')
text(core_diam*1e9/5, 7e14, sprintf('N_D=%0.1e', Nd));
text(core_diam*1e9/2 + (shell_diam-core_diam)*1e9/5, 7e14, sprintf('N_A=%0.1e', Na));
title(sprintf('%i Iterations, %0.2f ps/Iteration', N_samples, T_step*N_steps*1e12));

