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
p = Pillar(diam_shell, height);

%% Add the bound charges in core and shell
for c=1:ceil(core_charges)
    r1 = random('unif', 0, diam_core/2);
    t1 = random('unif', 0, 2*pi);
    x1 = r1*sin(t1);
    y1 = r1*cos(t1);
    z1 = random('unif', 0, height);
    p.add_pos_charge(x1, y1,z1);
end

for c=1:ceil(shell_charges)
    r2 = random('unif', diam_core/2, diam_shell/2);
    t2 = random('unif', 0, 2*pi);
    x2 = r2*sin(t2);
    y2 = r2*cos(t2);
    z2 = random('unif', 0, height);
    p.add_neg_charge(x2, y2,z2);
end


end