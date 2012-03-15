function p = i_core_n_shell_p_shell(diam_core, diam_shell1, Nd, diam_shell2, Na, height)
%%
% Create a Pillar with an n core, and a p shell
% then sample the magnitude of the e-field in r^ and z^

n_doping = Nd; % donors per cm^3
p_doping = Na; % acceptors per cm^3

diam_core_cm = diam_core*1e2; % core diam in cm
diam_shell1_cm = diam_shell1*1e2; % shell 1 diam in cm
diam_shell2_cm = diam_shell2*1e2; % shell 2 diam in cm 
height_cm = height*1e2; % Height  in cm

core_vol = pi*diam_core_cm^2/4*height_cm;
shell1_vol = pi*diam_shell1_cm^2/4*height_cm - core_vol;
shell2_vol = pi*diam_shell2_cm^2/4*height_cm - shell1_vol;

shell1_charges = ceil(shell1_vol*n_doping);
shell2_charges = ceil(shell2_vol*p_doping);
net_charge = shell2_charges - shell1_charges;

% Create a pillar with outer diameter equal to the shell diameter
p = Pillar(diam_shell2, height, GaAs);

%% Add the bound and free charges in core and shell
for c=1:shell1_charges
    % locate the ionized donor randomly
    r1 = random('unif', diam_core/2, diam_shell1/2);
    t1 = random('unif', 0, 2*pi);
    x1 = r1*sin(t1);
    y1 = r1*cos(t1);
    z1 = random('unif', 0, height);
    p.add_pos_charge(x1, y1,z1);
end

for c=1:shell2_charges
    r1 = random('unif', diam_shell1/2, diam_shell2/2);
    t1 = random('unif', 0, 2*pi);
    x1 = r1*sin(t1);
    y1 = r1*cos(t1);
    z1 = random('unif', 0, height);
    p.add_neg_charge(x1, y1,z1);
end

for c=1:abs(net_charge)
    % initialize the net charges
    r1 = random('unif', 0, diam_shell2/2);
    t1 = random('unif', 0, 2*pi);
    x1 = r1*sin(t1);
    y1 = r1*cos(t1);
    z1 = random('unif', 0, height);
    % Give it some random momentum with energy up to 26meV
    if (0 > net_charge)
        c = p.add_electron(x1, y1, z1, 0,0,0);
    else
        c = p.add_hole(x1, y1, z1, 0, 0, 0);
    end
    c.randomize_momentum(p.ev_to_joules(random('uniform', 0, 0.026)));
end

end