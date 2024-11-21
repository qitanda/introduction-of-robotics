clc
syms h l1 l2 theta1 theta2 theta3 theta4 theta5 theta6 real%
ksi1=[0 0 1 0 0 0]';
ksi2=[-1 0 0 0 -h 0]';
ksi3=[0 0 0 0 1 0]';
ksi4=[-1 0 0 0 -h l1+l2]';
ksi5=[0 0 1 -(l1+l2) 0 0]';
ksi6=[0 1 0 -h 0 0]';
ans1=ksi1;
ans2=Ad_tran(KsitoT(ksi1,theta1))*ksi2;
ans3=simplify(Ad_tran(KsitoT(ksi1,theta1)*KsitoT(ksi2,theta2))*ksi3);
ans4=simplify(Ad_tran(KsitoT(ksi1,theta1)*KsitoT(ksi2,theta2)*KsitoT(ksi3,theta3))*ksi4);
ans5=simplify(Ad_tran(KsitoT(ksi1,theta1)*KsitoT(ksi2,theta2)*KsitoT(ksi3,theta3)*KsitoT(ksi4,theta4))*ksi5);
ans6=simplify(Ad_tran(KsitoT(ksi1,theta1)*KsitoT(ksi2,theta2)*KsitoT(ksi3,theta3)*KsitoT(ksi4,theta4)*KsitoT(ksi5,theta5))*ksi6);
J_s=[ans1 ans2 ans3 ans4 ans5 ans6]
T_bs=KsitoT(ksi1,theta1)*KsitoT(ksi2,theta2)*KsitoT(ksi3,theta3)*KsitoT(ksi4,theta4)*KsitoT(ksi5,theta5)*KsitoT(ksi6,theta6)*KsitoT(ksi1,0)*KsitoT(ksi2,0)*KsitoT(ksi3,0)*KsitoT(ksi4,0)*KsitoT(ksi5,0)*KsitoT(ksi6,0);
J_b=Ad_tran(T_bs)*J_s