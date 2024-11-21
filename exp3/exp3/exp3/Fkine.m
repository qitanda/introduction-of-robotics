% AUTHOR :
%
% ABSTRACT�� ���Ǽ�����������⺯����ͨ�ú����������Transformation����
% 
% INPUT�� Xi      �����˸��ؽ��˶�����
%         theta   �����˹ؽ�λ�ƣ�1xN��������λm��rad
%         g0      �����˻�׼�ο�λ�ˣ� 4X4����
% OUTPUT: g_st    ������ĩ��λ��λ�ˣ� 4X4����
% 
function g_st = Fkine(Xi,theta,g0)
Ksi1=Xi(:,1);
Ksi2=Xi(:,2);
Ksi3=Xi(:,3);
Ksi4=Xi(:,4);
Ksi5=Xi(:,5);
Ksi6=Xi(:,6);
theta1=theta(1);
theta2=theta(2);
theta3=theta(3);
theta4=theta(4);
theta5=theta(5);
theta6=theta(6);
g_st=KsitoT(Ksi1,theta1)*KsitoT(Ksi2,theta2)*KsitoT(Ksi3,theta3)*KsitoT(Ksi4,theta4)*KsitoT(Ksi5,theta5)*KsitoT(Ksi6,theta6)*g0;

end


    
        
    
    
            
            
    





    