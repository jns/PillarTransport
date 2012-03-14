%% Measure the dynamics in a pillar

N_samples = 10;
T_step = 5e-14; % The time step of the simulation
N_steps= 100; % Number of time steps to evolve

bins = 0:5:75;
n = zeros(1,length(bins));
p = zeros(1, length(bins));

for n=1:N_samples
    fprintf(1,'Iteration %i\n', n);
    pillar = n_core_p_shell(100*1e-9, 3e16, 150*1e-9, 1e16, 30*1e-9);
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
        else
            n = n + histc(r, bins);
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