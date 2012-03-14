%% Measure the dynamics in a pillar

N_samples = 1;
T_step = 5e-14; % The time step of the simulation
N_steps= 100; % Points per shot (resolution)

% for n=1:N_samples
%     fprintf(1,'Iteration %i\n', n);
    p = n_core_p_shell(100*1e-9, 1e16, 150*1e-9, 1e16, 30*1e-9);
    output=move_free_charge(p, N_steps, T_step);
    
   visualize_pillar_3D(p);
   hold all;
   
   n_charges = size(output.x,1);
   for c = 1:n_charges
    x = output.x(c,:)*1e9;
    y = output.y(c,:)*1e9;
    z = output.z(c,:)*1e9;
    plot3(x,y,z, 'linewidth', 2);
   end