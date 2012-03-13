
classdef Pillar < Constants

    properties
        % Number of bound charges
        num_bound_charges = 0;
        
        % Fixed, immovable charges
        bound_charges = {};
        
        % Free carriers
        free_charges = {};
        
        % Permittivity
        er;
        
        % Pillar diameter
        diameter;
        
        % Pillar Height
        height;
    end
    
    methods
        function P = Pillar(diam, height)
            P.er = 12.5;
            P.diameter = diam;
            P.height = height;
        end
        
        %%
        % Add a bound charge to the pillar
        % at point x, y, z 
        % type is +/-Z where Z is units of electron charge
        % Return number of bound charges.
        function n=add_bound_charge(P, x,y,z,type)
            if (P.VERBOSE > 0)
                fprintf(1, 'Adding %i bound charge at (%0.3f, %0.3f, %0.3f)\n', type, x*1e9, y*1e9, z*1e9);
            end
            % Add a charge of the right polarity and no momentum
            n = P.num_bound_charges + 1;
            P.num_bound_charges = n;
            P.bound_charges{n} = Charge(type,x,y,z,0,0,0);
        end

        
        %%
        % Add a free carrier to the pillar
        % at point x,y,z
        % initial momentum px, py, pz
        % type is +/-q units of charge (usually +/-1)
        % m is effective mass of carrier
        function n=add_free_charge(P, x,y,z, px, py, pz, type, m) 
            
        end
        
        %% 
        % Add a negative charge to the pillar
        % at point x, y, z 
        function add_neg_charge(P, x,y,z)
            P.add_bound_charge(x,y,z,-1);
        end

        %% 
        % Add a positive charge to the pillar 
        % at point x,y,z
        function add_pos_charge(P, x,y,z)
            P.add_bound_charge(x,y,z,1);
        end
        
        %%
        % Return the E-field at the point x,y,z
        % E is a 3-element row vector of the 
        % x, y and z components of the E-field.
        function E=field_at_point(P,x,y,z)
           E_cumulative = [0,0,0];
           for c=1:P.num_bound_charges
               charge = P.bound_charges{c};
               e = charge.field_at(x,y,z, P.er);
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
    end
end