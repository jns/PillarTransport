
% A unit of charge with position, and momentum
classdef Charge < Constants
    
    properties
        q; % Charge 
        % Cartesian coordinates
        x; 
        y;
        z;
        % Momentum
        px;
        py;
        pz;
        % Effective mass
        m;
    end
    
    methods
        %%
        % Initialize a charge with magnitude and polarity q
        % position x,y,z
        % and momentum px, py, pz
        function C = Charge(q,x,y,z,px,py,pz,m)
           
            if (7 == nargin)
                C.m = m;
            else
                C.m = C.MASS_ELECTRON;
            end
            
            if (4 < nargin)
                C.px = px;
                C.py = py;
                C.pz = pz;
            else
                C.px = 0;
                C.py = 0;
                C.pz = 0;
            end
            
            if (1 < nargin)
                C.x = x;
                C.y = y;
                C.z = z;
            else
                C.x = 0;
                C.y = 0;
                C.z = 0;
            end
            
            if (0 == nargin)
                me = MException('Charge requires at least one argument');
                throw(me);
            else
                C.q = q;
            end
        end
        
        %% 
        % Test if a charge is at the position x,y,z
        function bool=at_position(C, x,y,z)
            bool = (C.x == x && C.y == y && C.z == z);
            
        end
        
        %%
        % Find the field from this charge at
        % the point x,y,z
        % in a material of relative permittivity er
        function E = field_at(C, x, y, z, er)
            dx = x-C.x;
            dy = y-C.y;
            dz = z-C.z;
            r = sqrt(dx*dx + dy*dy + dz*dz);
              
            Emag = C.q*C.CHARGE_ELECTRON/(4*pi*C.PERMITTIVITY_VACUUM*er*r*r);
            E = [dx, dy, dz]*Emag/r;
        end
        
        %%
        % Randomize the momentum vector but set
        % the energy of the particle  equal to energy
        function momentum = randomize_momentum(C, energy)
            p = random('unif', 0, 1, 3,1); % Get a 3 element random col. vector
            p_hat = p/norm(p); % normalize it.
            
            % p^2/(2m) = E (kinetic energy)
            p_mag = sqrt(2*C.m*energy);
            
            C.px = p_hat(1)*p_mag;
            C.py = p_hat(2)*p_mag;
            C.pz = p_hat(3)*p_mag;
        end
        
        %%
        % Step this charge by a distance
        % given by it's momentum and the time step t
        function step_in_time(C, t)
            dx = t*C.px/C.m;
            dy = t*C.py/C.m;
            dz = t*C.pz/C.m;
            C.x = C.x + dx;
            C.y = C.y + dy;
            C.z = C.z + dz;
        end
        
        %%
        % Modify the momentum of this particle
        % by applying a force given by the field E=[Ex, Ey, Ez] for 
        % a duration t
        function apply_field(C, E, t)
            force = C.q*C.CHARGE_ELECTRON*E;
            C.px = C.px + force(1)*t;
            C.py = C.py + force(2)*t;
            C.pz = C.pz + force(3)*t;
        end
    end
    
end