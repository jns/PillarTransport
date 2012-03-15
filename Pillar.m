
classdef Pillar < Constants

    properties
        % Number of bound charges
        num_bound_charges = 0;
        
        % Fixed, immovable charges
        bound_charges = {};
        
        % Free carriers
        free_charges = {};
        
        % Pillar Material
        material;
        
        % Pillar diameter
        diameter;
        
        % Pillar Height
        height;
    end
    
    methods
        function P = Pillar(diam, height, solid)
            P.diameter = diam;
            P.height = height;
            P.material = solid;
        end
        
        %%
        % Return the volume of the pillar in cm^3
        function v = volume(P)
            v = pi*(P.diameter*100).^2/4*(P.height*100);
        end
        
        %%
        % Return the number of holes in the pillar
        function n=hole_count(P)
           n = 0;
           for c=1:length(P.free_charges)
              if (P.free_charges{c}.q > 0)
                  n = n + 1;
              end
           end
        end
        
        %%
        % Return the number of electrons in the pillar
        function n=electron_count(P)
            n = 0;
            for c=1:length(P.free_charges)
                if P.free_charges{c}.q < 0
                    n = n + 1;
                end
            end
        end
        
        %%
        % Add a bound charge to the pillar
        % at point x, y, z 
        % type is +/-Z where Z is units of electron charge
        % Return the charge.
        function n=add_bound_charge(P, x,y,z,type)
            if (P.VERBOSE > 0)
                fprintf(1, 'Adding %i bound charge at (%0.3f, %0.3f, %0.3f)\n', type, x*1e9, y*1e9, z*1e9);
            end
            % Add a charge of the right polarity and no momentum
            n = P.num_bound_charges + 1;
            P.num_bound_charges = n;
            P.bound_charges{n} = Charge(type,x,y,z);
        end

        
        %% 
        % Add a negative charge to the pillar
        % at point x, y, z 
        % return the charge
        function c=add_neg_charge(P, x,y,z)
            c=P.add_bound_charge(x,y,z,-1);
        end
        
        %% 
        % Add a positive charge to the pillar 
        % at point x,y,z
        % return the charge
        function c=add_pos_charge(P, x,y,z)
            c=P.add_bound_charge(x,y,z,1);
        end

        
        %%
        % Add a free carrier to the pillar
        % at point x,y,z
        % initial momentum px, py, pz
        % type is +/-q units of charge (usually +/-1)
        % m is effective mass of carrier
        % return the charge
        function c=add_free_charge(P, x,y,z, px, py, pz, type, m) 
            if (P.VERBOSE > 0)
                fprintf(1, 'Adding %i free charge at (%0.3f, %0.3f, %0.3f)\n', type, x*1e9, y*1e9, z*1e9);
            end
            n = length(P.free_charges);
            c = Charge(type, x,y,z, px, py, pz, m);
            P.free_charges{n+1} = c;
        end
        
        %%
        % Add an electron as a free charge with effective mass
        % for pillar material
        function c=add_electron(P, x,y,z, px,py,pz)
            c = P.add_free_charge(x,y,z, px,py,pz, -1, P.material.eff_mass_e*P.MASS_ELECTRON);
        end
        
        %% 
        % Add a hole as a free charge with effective mass
        % for pillar material
        function c=add_hole(P, x,y,z, px, py, pz)
            c = P.add_free_charge(x,y,z, px,py,pz, 1, P.material.eff_mass_lh*P.MASS_ELECTRON);
        end
        
        %%
        % Return the E-field at the point x,y,z
        % E is a 3-element row vector of the 
        % x, y and z components of the E-field.
        function E=field_at_point(P,x,y,z)
           E_cumulative = [0,0,0];
           for c=1:P.num_bound_charges
               charge = P.bound_charges{c};
               
               if charge.at_position(x,y,z)
                % Ignore self charge.
                   continue;
               end
               e = charge.field_at(x,y,z, P.material.relative_permittivity);
               E_cumulative = E_cumulative + e;
           end
           
           for c=1:length(P.free_charges)
               charge = P.free_charges{c};
               if charge.at_position(x,y,z)
                % Ignore self charge.
                   continue;
               end
               e = charge.field_at(x,y,z, P.material.relative_permittivity);
               E_cumulative = E_cumulative + e; 
           end
           
           E = E_cumulative;
        end
           
        %%
        % Get the field in a volume 
        % defined by the vectors X,Y,Z
        function [Ex, Ey, Ez, Emag]=field_in_volume(P, X,Y,Z)
            
            sizeX = length(X);
            sizeY = length(Y);
            sizeZ = length(Z);
            Ex = zeros(sizeX,sizeY,sizeZ);
            Ey = zeros(sizeX,sizeY,sizeZ);
            Ez = zeros(sizeX,sizeY,sizeZ);
            Emag = zeros(sizeX, sizeY, sizeZ);
            
            for m=1:sizeX
                for n=1:sizeY
                    for p=1:sizeZ
                        x = X(m);
                        y = Y(n);
                        z = Z(p);
                        
                        E = P.field_at_point(x,y,z);
                        Ex(n,m,p) = E(1);
                        Ey(n,m,p) = E(2);
                        Ez(n,m,p) = E(3);
                        Emag(n,m,p) = sqrt(E(1)^2 + E(2)^2 + E(3)^2);
                    end
                end
            end
        end
        
        %% 
        % Apply the boundary conditions to the charge
        %
        function apply_boundary_conditions(P, charge)
           
            % If the charge has encountered the surface, then trap it.
            charge_r = sqrt(charge.x^2 + charge.y^2);
            if (charge_r >= P.diameter/2)
                charge.trap
                % Place the charge back on the surface in case it overshot
                scale = (P.diameter/2)/charge_r;
                charge.x = charge.x*scale;
                charge.y = charge.y*scale;
            end
            
           % If the charge has crossed the z-boundary,
           % re-enter from the other side.
           if (charge.z > P.height)
               while (charge.z > P.height)
                   charge.z = charge.z - P.height;
               end
               charge.z_crossings = charge.z_crossings + 1;
           end
           
           if (charge.z < 0)
               while (charge.z < 0)
                   charge.z = charge.z + P.height;
               end
               charge.z_crossings = charge.z_crossings - 1;
           end
        end
        
        %%
        % apply the field to the charge for a duration
        % then step the charge in the direction of it's momentum
        function step_free_charges(P,dt)
            % Evaluate each charge in random order
            for c=randperm(length(P.free_charges))
                charge = P.free_charges{c};
                if (charge.trapped)
                    % if charge is trapped, calculate a probability of
                    % releasing it.
                    num = random('unif', 0, 1);
                    if (0.9 < num)
                        % give it some random amount of energy up to 26meV
                        energy = P.ev_to_joules(random('unif', 0, 0.026));
                        p = sqrt(2*charge.m*energy);
                        % point it towards the core.
                        r = sqrt(charge.x^2 + charge.y^2);
                        z = random('unif', -0.5, 0.5);
                        x = -charge.x/r;
                        y = -charge.y/r;
                        p_hat = [x, y, z]/norm([x,y,z]);
                        % release it
                        charge.release(p*p_hat(1), p*p_hat(2), p*p_hat(3));
                    end
                end
                E = P.field_at_point(charge.x, charge.y, charge.z);
                charge.apply_field(E, dt);
                charge.step_in_time(dt);
                P.apply_boundary_conditions(charge);    
            end
        end
    end
end