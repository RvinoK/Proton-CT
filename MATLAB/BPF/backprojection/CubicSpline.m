function [ a ] = CubicSpline( x0, x1, y0, y1, dy0, dy1 )


A = [ x0^3 x0^2 x0 1; ...
    x1^3 x1^2 x1 1; ...
    3*x0^2 2*x0 1 0; ...
    3*x1^2 2*x1 1 0];

y = [y0; y1; dy0; dy1];

a = A \ y;



end

