function T = rot(axis, theta)
if axis=='x'
    T = [1 0 0
         0 cos(theta) -sin(theta)
         0 sin(theta) cos(theta)];
elseif axis=='y'
    T = [cos(theta) 0 sin(theta)
         0 1 0
         -sin(theta) 0 cos(theta)];
elseif axis=='z'
    T = [cos(theta) -sin(theta) 0
         sin(theta) cos(theta) 0
         0 0 1];
end