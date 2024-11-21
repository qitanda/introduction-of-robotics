function theta = inverse_kinematics(T_desired)
    % T_desired��������ĩ��ִ�����任����
    % �������п��ܵĹؽڽǶ����
    
    L1 = 491;
    L2 = 450;
    L3 = 450;
    L4 = 84;

    % ��T_desired����ȡĩ��ִ����λ��
    px = T_desired(1, 4);
    py = T_desired(2, 4);
    pz = T_desired(3, 4);

    % ����theta1
    theta1 = atan2(py, px);
    
    % ����theta3
    D = (px^2 + py^2 + (pz - L1)^2 - L2^2 - L3^2) / (2 * L2 * L3);
    D
    theta3 = atan2(sqrt(1 - D^2), D); % ������������
    
    % ����theta2
    k1 = L2 + L3 * cos(theta3);
    k2 = L3 * sin(theta3);
    theta2 = atan2(pz - L1, sqrt(px^2 + py^2)) - atan2(k2, k1);
    
    % ����theta4, theta5, theta6
    R03 = [cos(theta1)*cos(theta2 + theta3), -cos(theta1)*sin(theta2 + theta3), sin(theta1);
           cos(theta2 + theta3)*sin(theta1), -sin(theta1)*sin(theta2 + theta3), -cos(theta1);
           sin(theta2 + theta3), cos(theta2 + theta3), 0];
       
    R36 = R03' * T_desired(1:3, 1:3);
    
    theta4 = atan2(R36(2, 3), R36(1, 3));
    theta5 = atan2(sqrt(R36(1, 3)^2 + R36(2, 3)^2), R36(3, 3));
    theta6 = atan2(R36(3, 2), -R36(3, 1));
    
    theta = [theta1, theta2, theta3, theta4, theta5, theta6];
end
