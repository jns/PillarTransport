
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
        % Find the field from this charge at
        % the point x,y,z
        % in a material of relative permittivity er
        function E = field_at(P, x, y, z, er)
            dx = x-P.x;
            dy = y-P.y;
            dz = z-P.z;
            r = sqrt(dx*dx + dy*dy + dz*dz);
              
            Emag = P.q*P.CHARGE_ELECTRON/(4*pi*P.PERMITTIVITY_VACUUM*er*r*r);
            E = [dx, dy, dz]*Emag/r;
        end
    end
    
end