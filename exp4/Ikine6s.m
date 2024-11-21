% AUTHOR : 
%
% ABSTRACT：这是六轴机器人逆运动学函数，适用于六轴机器人
% 
% INPUT：config           机器人杆长信息
%        T                机器人末端姿态矩阵，4x4矩阵
%        
% OUTPUT: theta           关节转角矩阵，1X6，单位rad      
%
function theta = Ikine6s(T,config)
L1=config(1);
L2=config(2);
L3=config(3);
L4=config(4);
Ksi1=[0,0,1,0,0,0]';
Ksi2=[0,1,0,-L1,0,0]';
Ksi3=[0,1,0,-(L1+L2),0,0]';
Ksi4=[0,0,1,0,0,0]';
Ksi5=[0,1,0,-(L1+L2+L3),0,0]';
Ksi6=[0,0,1,0,0,0]';
g0=[-1 0 0 0;
    0 -1 0 0;
    0 0 1 (L1+L2+L3+L4);
    0 0 0 1];
g1=T*g0^(-1);
qw=[0,0,(L1+L2+L3)]';
pb=[0,0,L1]';
eta=g1*[qw;1]-[pb;1];
eta=eta(1:3);
eta=norm(eta);
r3=[0,0,L1+L2]';
[theta3_1,theta3_2]=pk_sub3(Ksi3,qw,pb,eta,r3);
qw3_1=KsitoT(Ksi3,theta3_1)*[qw;1];
qw3_1=qw3_1(1:3);
qw3_2=KsitoT(Ksi3,theta3_2)*[qw;1];
qw3_2=qw3_2(1:3);
q1=g1*[qw;1];
q1=q1(1:3);
r12=[0,0,L1]';
[theta1_1_1,theta2_1_1,theta1_2_1,theta2_2_1]=pk_sub2(Ksi1,Ksi2,qw3_1,q1,r12);
[theta1_1_2,theta2_1_2,theta1_2_2,theta2_2_2]=pk_sub2(Ksi1,Ksi2,qw3_2,q1,r12);
g2_1_1=KsitoT(Ksi3,-theta3_1)*KsitoT(Ksi2,-theta2_1_1)*KsitoT(Ksi1,-theta1_1_1)*g1;
g2_2_1=KsitoT(Ksi3,-theta3_1)*KsitoT(Ksi2,-theta2_2_1)*KsitoT(Ksi1,-theta1_2_1)*g1;
g2_1_2=KsitoT(Ksi3,-theta3_2)*KsitoT(Ksi2,-theta2_1_2)*KsitoT(Ksi1,-theta1_1_2)*g1;
g2_2_2=KsitoT(Ksi3,-theta3_2)*KsitoT(Ksi2,-theta2_2_2)*KsitoT(Ksi1,-theta1_2_2)*g1;
p=[0,0,(L1+L2+L3+L4)]'
p2_1_1=g2_1_1*[p;1];
p2_1_1=p2_1_1(1:3);
p2_2_1=g2_2_1*[p;1];
p2_2_1=p2_2_1(1:3);
p2_1_2=g2_1_2*[p;1];
p2_1_2=p2_1_2(1:3);
p2_2_2=g2_2_2*[p;1];
p2_2_2=p2_2_2(1:3);
r45=[0,0,L1+L2+L3]';
[theta4_1_1_1,theta5_1_1_1,theta4_1_2_1,theta5_1_2_1]=pk_sub2(Ksi4,Ksi5,p,p2_1_1,r45);
[theta4_2_1_1,theta5_2_1_1,theta4_2_2_1,theta5_2_2_1]=pk_sub2(Ksi4,Ksi5,p,p2_2_1,r45);
[theta4_1_1_2,theta5_1_1_2,theta4_1_2_2,theta5_1_2_2]=pk_sub2(Ksi4,Ksi5,p,p2_1_2,r45);
[theta4_2_1_2,theta5_2_1_2,theta4_2_2_2,theta5_2_2_2]=pk_sub2(Ksi4,Ksi5,p,p2_2_2,r45);
g6_1_1_1=(KsitoT(Ksi1,theta1_1_1)*KsitoT(Ksi2,theta2_1_1)*KsitoT(Ksi3,theta3_1)*KsitoT(Ksi4,theta4_1_1_1)*KsitoT(Ksi5,theta5_1_1_1))^(-1)*g1;
g6_1_2_1=(KsitoT(Ksi1,theta1_1_1)*KsitoT(Ksi2,theta2_1_1)*KsitoT(Ksi3,theta3_1)*KsitoT(Ksi4,theta4_1_2_1)*KsitoT(Ksi5,theta5_1_2_1))^(-1)*g1;
g6_2_1_1=(KsitoT(Ksi1,theta1_2_1)*KsitoT(Ksi2,theta2_2_1)*KsitoT(Ksi3,theta3_1)*KsitoT(Ksi4,theta4_2_1_1)*KsitoT(Ksi5,theta5_2_1_1))^(-1)*g1;
g6_2_2_1=(KsitoT(Ksi1,theta1_2_1)*KsitoT(Ksi2,theta2_2_1)*KsitoT(Ksi3,theta3_1)*KsitoT(Ksi4,theta4_2_2_1)*KsitoT(Ksi5,theta5_2_2_1))^(-1)*g1;
g6_1_1_2=(KsitoT(Ksi1,theta1_1_2)*KsitoT(Ksi2,theta2_1_2)*KsitoT(Ksi3,theta3_2)*KsitoT(Ksi4,theta4_1_1_2)*KsitoT(Ksi5,theta5_1_1_2))^(-1)*g1;
g6_1_2_2=(KsitoT(Ksi1,theta1_1_2)*KsitoT(Ksi2,theta2_1_2)*KsitoT(Ksi3,theta3_2)*KsitoT(Ksi4,theta4_1_2_2)*KsitoT(Ksi5,theta5_1_2_2))^(-1)*g1;
g6_2_1_2=(KsitoT(Ksi1,theta1_2_2)*KsitoT(Ksi2,theta2_2_2)*KsitoT(Ksi3,theta3_2)*KsitoT(Ksi4,theta4_2_1_2)*KsitoT(Ksi5,theta5_2_1_2))^(-1)*g1;
g6_2_2_2=(KsitoT(Ksi1,theta1_2_2)*KsitoT(Ksi2,theta2_2_2)*KsitoT(Ksi3,theta3_2)*KsitoT(Ksi4,theta4_2_2_2)*KsitoT(Ksi5,theta5_2_2_2))^(-1)*g1;
p6=[1,1,1]';
q6_1_1_1=g6_1_1_1*[p6;1];
q6_1_1_1=q6_1_1_1(1:3);
q6_1_2_1=g6_1_2_1*[p6;1];
q6_1_2_1=q6_1_2_1(1:3);
q6_2_1_1=g6_2_1_1*[p6;1];
q6_2_1_1=q6_2_1_1(1:3);
q6_2_2_1=g6_2_2_1*[p6;1];
q6_2_2_1=q6_2_2_1(1:3);
q6_1_1_2=g6_1_1_2*[p6;1];
q6_1_1_2=q6_1_1_2(1:3);
q6_1_2_2=g6_1_2_2*[p6;1];
q6_1_2_2=q6_1_2_2(1:3);
q6_2_1_2=g6_2_1_2*[p6;1];
q6_2_1_2=q6_2_1_2(1:3);
q6_2_2_2=g6_2_2_2*[p6;1];
q6_2_2_2=q6_2_2_2(1:3);
r6=[0,0,(L1+L2+L3+L4)]';
theta6_1_1_1=pk_sub1(Ksi6,p6,q6_1_1_1,r6);
theta6_1_2_1=pk_sub1(Ksi6,p6,q6_1_2_1,r6);
theta6_2_1_1=pk_sub1(Ksi6,p6,q6_2_1_1,r6);
theta6_2_2_1=pk_sub1(Ksi6,p6,q6_2_2_1,r6);
theta6_1_1_2=pk_sub1(Ksi6,p6,q6_1_1_2,r6);
theta6_1_2_2=pk_sub1(Ksi6,p6,q6_1_2_2,r6);
theta6_2_1_2=pk_sub1(Ksi6,p6,q6_2_1_2,r6);
theta6_2_2_2=pk_sub1(Ksi6,p6,q6_2_2_2,r6);
ans1=[theta1_1_1,theta2_1_1,theta3_1,theta4_1_1_1,theta5_1_1_1,theta6_1_1_1]';
ans2=[theta1_1_1,theta2_1_1,theta3_1,theta4_1_2_1,theta5_1_2_1,theta6_1_2_1]';
ans3=[theta1_2_1,theta2_2_1,theta3_1,theta4_2_1_1,theta5_2_1_1,theta6_2_1_1]';
ans4=[theta1_2_1,theta2_2_1,theta3_1,theta4_2_2_1,theta5_2_2_1,theta6_2_2_1]';
ans5=[theta1_1_2,theta2_1_2,theta3_2,theta4_1_1_2,theta5_1_1_2,theta6_1_1_2]';
ans6=[theta1_1_2,theta2_1_2,theta3_2,theta4_1_2_2,theta5_1_2_2,theta6_1_2_2]';
ans7=[theta1_2_2,theta2_2_2,theta3_2,theta4_2_1_2,theta5_2_1_2,theta6_2_1_2]';
ans8=[theta1_2_2,theta2_2_2,theta3_2,theta4_2_2_2,theta5_2_2_2,theta6_2_2_2]';
theta=[ans1,ans2,ans3,ans4,ans5,ans6,ans7,ans8];
end




