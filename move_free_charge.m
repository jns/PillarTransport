
function output=move_free_charge(pillar, num_steps, time_step)
% A dynamic simulation
% move the free charge through a pillar. 
% num_steps - the number of time steps
% time_step - the size of the time step

n_charges = length(pillar.free_charges);
output.x = zeros(n_charges, num_steps);
output.y = zeros(n_charges, num_steps);
output.z = zeros(n_charges, num_steps);
output.px = zeros(n_charges, num_steps);
output.py = zeros(n_charges, num_steps);
output.pz = zeros(n_charges, num_steps);
output.p_sq = zeros(n_charges, num_steps);
output.energy = zeros(n_charges, num_steps);
output.charges = zeros(n_charges,1);
output.charge_mass = zeros(n_charges, 1);
output.z_crossings = zeros(n_charges, 1);
output.time = zeros(num_steps, 1);

for step=1:num_steps
    pillar.step_free_charges(time_step);
    output.time(step) = step*time_step;
    for c=1:n_charges
       output.x(c, step) = pillar.free_charges{c}.x;
       output.y(c, step) = pillar.free_charges{c}.y;
       output.z(c, step) = pillar.free_charges{c}.z;
       output.px(c, step) = pillar.free_charges{c}.px;
       output.py(c, step) = pillar.free_charges{c}.py;
       output.pz(c, step) = pillar.free_charges{c}.pz;
       output.p_sq(c, step) = output.px(c, step)^2 + output.py(c, step)^2 + output.pz(c, step)^2;  
       output.energy(c, step) = output.p_sq(c, step)/(2*pillar.free_charges{c}.m);  
    end
end


for c = 1:n_charges
    output.charges(c) = pillar.free_charges{c}.q;
    output.charge_mass(c) = pillar.free_charges{c}.m;
    output.z_crossings(c) = pillar.free_charges{c}.z_crossings;
end

end