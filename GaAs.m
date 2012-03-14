
classdef GaAs < Solid
   
    methods
        function S = GaAs
           S.relative_permittivity = 12.5;
           S.eff_mass_e = 0.065;
           S.eff_mass_lh = 0.09;
           S.eff_mass_hh = 0.5;
        end
    end
end