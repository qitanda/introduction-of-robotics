function [Ad_T]=Ad_tran(T)
p=[T(1,4) T(2,4) T(3,4)]';
R=T(1:3,1:3);
p_m=[0 -p(3) p(2);
    p(3) 0 -p(1);
    -p(2) p(1) 0];
ZERO=zeros(3);
Ad_T=[R ZERO;...
    p_m*R R];
end