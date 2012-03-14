
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

for step=1:num_steps
    pillar.step_free_charges(time_step);
    for c=1:n_charges
       output.x(c, step) = pillar.free_charges{c}.x;
       output.y(c, step) = pillar.free_charges{c}.y;
       output.z(c, step) = pillar.free_charges{c}.z;
       output.px(c, step) = pillar.free_charges{c}.px;
       output.py(c, step) = pillar.free_charges{c}.py;
       output.pz(c, step) = pillar.free_charges{c}.pz; 
    end
end

end