function E=shots_through_pillar(pillar, num_shots, num_points)
% return the field in r, z for a number of shots through
% the center of the pillar.

E.points = linspace(-pillar.diameter/2,pillar.diameter/2, num_points);

E.fieldR = zeros(num_shots, num_points);
E.fieldZ = zeros(num_shots, num_points);
for pathnum=1:num_shots
    z = random('unif', 0, pillar.height);
    angle = random('unif', 0, pi);
    sinangle = sin(angle);
    cosangle = cos(angle);
    for pointnum = 1:num_points
        r = E.points(pointnum);
        x = r*cosangle;
        y = r*sinangle;
        Efield = pillar.field_at_point(x,y,z);
        E.fieldR(pathnum, pointnum) = Efield(1)*cosangle + Efield(2)*sinangle; % Mag in direction of rhat
        E.fieldZ(pathnum, pointnum) = Efield(3); % Mag in Z-dir
    end
end
end