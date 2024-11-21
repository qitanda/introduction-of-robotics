function T = forward_kinematics(theta)
    % theta是关节角度向量 [theta1, theta2, theta3, theta4, theta5, theta6]
    
    % DH参数 (d, theta, a, alpha)
%     DH = [491, theta(1), 0, -pi/2;
%           0, theta(2), 450, 0;
%           0, theta(3), 450, 0;
%           84, theta(4), 0, pi/2;
%           0, theta(5), 0, -pi/2;
%           0, theta(6), 0, 0];
      DH = [491, theta(1), 0, 0;
          450, theta(2), 0, 0;
          0, theta(3), 450, 0;
          84, theta(4), 0, pi/2;
          0, theta(5), 0, -pi/2;
          0, theta(6), 0, 0];

    % 初始变换矩阵
    T = eye(4);
    
    % 计算各关节的变换矩阵，并相乘
    for i = 1:size(DH, 1)
        d = DH(i, 1);
        theta = DH(i, 2);
        a = DH(i, 3);
        alpha = DH(i, 4);
        
        % DH变换矩阵
        A = [cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha), a*cos(theta);
             sin(theta), cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
             0, sin(alpha), cos(alpha), d;
             0, 0, 0, 1];
        
        T = T * A;
    end
end
