% Author: 
%
% ABSTRACT:  ���׹켣�滮������ļ�
%
% INPUTS:InterpolationCycle      ���㲽������λs ����Ϊ0.001s
%        TotalLength             �켣���ȣ�1xN���飬NΪ�켣���ɶ�������λm����rad
%        Vmax                    �켣���ٶ�����ٶȣ�1xN���飬��λm/s ��rad/s
%        Acc                     �����ٶȣ�1xN���飬��λm/s^2 �� rad/s^2
%        Dec                     �����ٶȣ�1xN���飬��λm/s^2 �� rad/s^2
%
% OUTPUTS:MotionData             �켣��ʽ������
%         s 	                 �켣�������飬NxM���飬��λm �� rad
%         v 	                 �ٶ����飬NxM���飬��λm/s ��rad/s
%         a 	                 ���ٶ����飬NxM���飬��λm/s^2 �� rad/s^2
%         t 	                 ʱ�����飬Mx1���飬��λs
%         maxtime 	             ����ʱ�䣬��λs

function MotionData = MotionPlanning(TotalLength, Vmax, Accel, Decel, Ts)
    for i = 1:length(Totallength)
        t = 0;
        t1 = Vmax(i)/Accel(i);
        t2 = Vmax(i)/Decel(i);
        if (Vmax(i)^2/2/Accel(i) + Vmax(i)^2/2/Decel(i) <= TotalLength*(i))
            t3 = (TotalLength(i) - Vmax(i)^2/2/Accel(i) - Vmax(i)^2/2/Decel(i))/Vmax(i);
            x = 0;
            v = 0;
            t_count = 0;
            count = 0;
            while (x < TotalLength(i))
                count = count + 1;
                if (v + Accel(i)*0.001 < Vmax(i))
                    v1 = v + Accel(i)*0.001;
                    x = x + (v1^2-v^2)/2/Accel(i);
                    v = v + Accel(i)*0.001;
                    s(i, count) = x;
                    t(i, count) = count * 0.001;
                    v(i, count) = v;
                    a(i, count) = Accel(i);
                elif (v + Accel(i)*0.001 >= Vmax(i) && t_count < t3)
                    x = x + v * 0.001;
                    t_count = t_count + 0.001;
                    s(i, count) = x;
                    t(i, count) = count * 0.001;
                    v(i, count) = v;
                    a(i, count) = 0;
                elif (t_count >= t3 && v > 0)
                    v1 = v - Decel(i)*0.001;
                    if (v1 <)
                    x = x + (v^2-v1^2)/2/Decel(i);
                end
            end
        end
    end
end
