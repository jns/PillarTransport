function visualize_pillar(p)

    xmin = -p.diameter/2;
    xmax = p.diameter/2;
    ymin = xmin;
    ymax = xmax;
    zmin = 0;
    zmax = p.height;
    
    sizeX = 20;
    sizeY = 20;
    sizeZ = 10;
    
    X = xmin:(xmax-xmin)/(sizeX-1):xmax;
    Y = ymin:(ymax-ymin)/(sizeY-1):ymax;
    Z = zmin:(zmax-zmin)/(sizeZ-1):zmax;

    [FieldX, FieldY, FieldZ, V] = p.field_in_volume(X,Y,Z);
    
    figure(1)
    clf;
    hold all;
    logV = log10(V);
    % Plot in nanometers
    [XX,YY,ZZ] = meshgrid(X*1e9,Y*1e9,Z*1e9);
    slice(XX,YY,ZZ,logV, [0 0], [0 0], [0]);
%     contourslice(XX,YY,ZZ,V, [], [], [z1 z2]*1e9);
%     h = streamline(XX,YY,ZZ,FieldX, FieldY, FieldZ, [1 0 -1 0],[0 1 0 -1] , [height height height height]);
%     set(h,'color', 'red');
     daspect([1,1,1]);
    [f verts] = reducepatch(isosurface(XX,YY,ZZ, logV, 6), .2);
    h=coneplot(XX,YY,ZZ,FieldX,FieldY,FieldZ,verts(:,1),verts(:,2),verts(:,3),10);
    set(h, 'FaceColor', 'red');  
    view(3);
    xlabel('nm');
    ylabel('nm');
    title('Log E-Field from ionized impurities in NP');
    colorbar;

end