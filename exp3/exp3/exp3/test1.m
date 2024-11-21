clc
config=[491;450;450;84];
L1=config(1);
L2=config(2);
L3=config(3);
L4=config(4);
g0=[-1 0 0 0;
    0 -1 0 0;
    0 0 1 (L1+L2+L3+L4);
    0 0 0 1];
Ksi1=[0,0,1,0,0,0]';
Ksi2=[0,1,0,-L1,0,0]';
Ksi3=[0,1,0,-(L1+L2),0,0]';
Ksi4=[0,0,1,0,0,0]';
Ksi5=[0,1,0,-(L1+L2+L3),0,0]';
Ksi6=[0,0,1,0,0,0]';
Xi=[Ksi1,Ksi2,Ksi3,Ksi4,Ksi5,Ksi6];
theta=[30;30;30;30;30;30];
g_st = Fkine(Xi,theta,g0)
theta_m = Ikine6s(g_st,config)