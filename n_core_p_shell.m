function p = n_core_p_shell(diam_core, Nd, diam_shell, Na, height)
%%
% Create a Pillar with an n core, and a p shell
% then sample the magnitude of the e-field in r^ and z^

n_doping = Nd; % donors per cm^3
p_doping = Na; % acceptors per cm^3

diam_core_cm = diam_core*1e2; % core diam in cm
diam_shell_cm = diam_shell*1e2; % shell diam in cm
height_cm = height*1e2; % Height  in cm

core_vol = pi*diam_core_cm^2/4*height_cm;
shell_vol = pi*diam_shell_cm^2/4*height_cm - core_vol;

core_charges = core_vol*n_doping;
shell_charges = shell_vol*p_doping;

% Create a pillar with outer diameter equal to the shell diameter
p = Pillar(diam_shell, height, GaAs);

%% Add the bound and free charges in core and shell
for c=1:ceil(core_charges)
    % locate the ionized donor randomly
    r1 = random('unif', 0, diam_core/2);
    t1 = random('unif', 0, 2*pi);
    x1 = r1*sin(t1);
    y1 = r1*cos(t1);
    z1 = random('unif', 0, height);
    p.add_pos_charge(x1, y1,z1);

    % initialize the electron near the donor with momentum given by fermi
    % function
    x2 = random('normal', x1, 1e-8);
    y2 = random('normal', y1, 1e-8);
    z2 = random('normal', z1, 1e-8);
    % Give it some random momentum with energy up to 26meV
    c = p.add_electron(x2, y2, z2, 0,0,0);
    c.randomize_momentum(p.ev_to_joules(random('uniform', 0, 0.026)));

end

for c=1:ceil(shell_charges)
    r1 = random('unif', diam_core/2, diam_shell/2);
    t1 = random('unif', 0, 2*pi);
    x1 = r1*sin(t1);
    y1 = r1*cos(t1);
    z1 = random('unif', 0, height);
    p.add_neg_charge(x1, y1,z1);

    % initialize the holes near the donor with momentum given by fermi
    % function
    x2 = random('normal', x1, 1e-8);
    y2 = random('normal', y1, 1e-8);
    z2 = random('normal', z1, 1e-8);
    % Give it some random momentum with energy up to 26meV
    c = p.add_hole(x2, y2, z2, 0,0,0);
    c.randomize_momentum(p.ev_to_joules(random('uniform', 0, 0.026)));
end


end