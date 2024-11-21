% Author: 
%
% ABSTRACT:  ����ʱ���·����ʽ�����ṹ����㵱ǰʱ��㣬�ؽ�λ�ã��ٶȺͼ��ٶ�
%
% INPUTS: time            ��ǰʱ��
%         MotionData      ·����ʽ�����ṹ�壬����s,v,a,j,t��Ϣ
%         loc1            ·������λ
%         loc2            ·���յ��λ
%             
% OUTPUTS: q              ��ǰʱ��㣬�ؽ�λ������1xN����λm��rad
%          qd             ��ǰʱ��㣬�ؽ��ٶ�����1xN,��λm/s��rad/s
%          qdd            ��ǰʱ��㣬�ؽڼ��ٶ�����1xN,��λm/s^2��rad/s^2       
%
function theta_all = TrajGena(time, MotionData, loc1, loc2)
    g0=[-1 0 0 loc1(1);
        0 -1 0 loc1(2);
        0 0 1 loc1(3);
        0 0 0 1];
    x = MotionData.s(1,:);
    y = MotionData.s(2,:);
    z = MotionData.s(3,:);
    index = 0;
    for i = 1:length(MotionData.t(1,:))
        if (time > MotionData.t(1,i) && index ~= 0) 
            index = i;
        end
    end
    if (index <= 0) index = 1; end
    if (index > length(MotionData.s(1,:))) index = length(MotionData.s(1,:)); end
    config=[491;450;450;84];
    for i = 1:length(MotionData.t(1,:)) 
        x_target = loc1(1) + x(i);
        y_target = loc1(2) + y(i);
        z_target = loc1(3) + z(i);
        g_st=[0.6790 0.0841 0.7293 x_target;
            -0.1655 -0.9503 0.2637 y_target;
            0.7152 -0.2998 -0.6313 z_target;
            0 0 0 1];
        theta = Ikine6s(g_st,config)
        if i == 1
            for j = 1:8
                if abs(theta(1,j) < 170) && abs(theta(2,j) < 120) && abs(theta(3,j) < 140) && abs(theta(4,j) < 170) && abs(theta(5,j) < 120)
                    theta_last = theta(:,j);
                    theta_all = [theta_last]
                end
            end
        end
        if i >= 2
            for j = 1:8
                id = 0;
                min = 10000000000000;
                if abs(theta(1,j) < 170) && abs(theta(2,j) < 120) && abs(theta(3,j) < 140) && abs(theta(4,j) < 170) && abs(theta(5,j) < 120)
                    sum = 0
                    for k = 1:6
                        sum = sum + (theta(k,j)-theta_last(k))^2;
                    end
                    sum
                    if sum < min
                        id = j;
                        min = sum;
                    end
                end
            end
            theta_last = theta(:,id);
            theta_all = [theta_all theta_last];
        end 
    end
%     MotionPlanning(loc2-loc1, Vmax, Accel, Decel, Ts)
    
end

