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

function MotionData = MotionPlanning1(TotalLength, Vmax, Accel, Decel, Ts)
    flag_x = 1;
    flag_y = 1;
    flag_z = 1;
    if (TotalLength(1) < 0) 
        flag_x = 0;
        TotalLength(1) = -TotalLength(1);
    end
    if (TotalLength(2) < 0) 
        flag_y = 0;
        TotalLength(2) = -TotalLength(2);
    end
    if (TotalLength(3) < 0) 
        flag_z = 0;
        TotalLength(3) = -TotalLength(3);
    end
    td1 = 2*TotalLength(1)/Accel(1)+2*TotalLength(1)/Decel(1);
    td2 = 2*TotalLength(2)/Accel(2)+2*TotalLength(2)/Decel(2);
    td3 = 2*TotalLength(3)/Accel(3)+2*TotalLength(3)/Decel(3);
    if (td3 >= td2 && td3 >= td1)
        i = 3;
    end
    if (td2 >= td1 && td2 >= td3)
        i = 2;
    end
    if (td1 >= td2 && td1 >= td3)
        i = 1;
    end
    t = 0;
    t1 = Vmax(i)/Accel(i);
    t2 = Vmax(i)/Decel(i);
    Vmax(i)^2/2/Accel(i) + Vmax(i)^2/2/Decel(i)
    if (Vmax(i)^2/2/Accel(i) + Vmax(i)^2/2/Decel(i) <= 0.3 * TotalLength(i))
        t3 = (TotalLength(i) - Vmax(i)^2/2/Accel(i) - Vmax(i)^2/2/Decel(i))/Vmax(i);
        x = 0;
        v = 0;
        t_count = 0;
        count = 0;
        flag = 1;
        while (x < TotalLength(i) && flag)
            count = count + 1;
            if (v + Accel(i)*0.001 < Vmax(i) && t_count == 0)
                v1 = v + Accel(i)*0.001;
                x = x + (v1^2-v^2)/2/Accel(i);
                v = v + Accel(i)*0.001;
                s(i, count) = x;
                t(i, count) = Ts + count * 0.001;
                v_all(i, count) = v;
                a(i, count) = Accel(i);
            elseif (v + Accel(i)*0.001 >= Vmax(i) && t_count < t3)
                x = x + v * 0.001;
                t_count = t_count + 0.001;
                s(i, count) = x;
                t(i, count) = Ts + count * 0.001;
                v_all(i, count) = v;
                a(i, count) = 0;
            elseif (t_count >= t3 && v > 0)
                v1 = v - Decel(i)*0.001;
                if (v1 > 0)
                    x = x + (v^2-v1^2)/2/Decel(i);
                    v = v - Decel(i)*0.001;
                    s(i, count) = x;
                    t(i, count) = Ts + count * 0.001;
                    v_all(i, count) = v;
                    a(i, count) = -Decel(i);
                elseif (v1 <= 0)
                    t4 = v / Decel(i);
                    x = x + v^2/2/Decel(i);
                    s(i, count) = x;
                    t(i, count) = Ts + t(i, count-1) + t4;
                    v_all(i, count) = 0;
                    a(i, count) = -Decel(i);
                    flag = 0;
                end
            end
        end
        max_time = t(i, count)
    elseif (Vmax(i)^2/2/Accel(i) + Vmax(i)^2/2/Decel(i) > 0.3 * TotalLength(i))
        Vm = sqrt(0.6*TotalLength(i)*Accel(i)*Decel(i)/(Accel(i)+Decel(i)));
        t3 = (TotalLength(i) - Vm^2/2/Accel(i) - Vm^2/2/Decel(i))/Vm;
        x = 0;
        v = 0;
        t_count = 0;
        count = 0;
        flag = 1;
        while (x < TotalLength(i) && flag)
            count = count + 1;
            if (v + Accel(i)*0.001 < Vm && t_count == 0)
                v1 = v + Accel(i)*0.001;
                x = x + (v1^2-v^2)/2/Accel(i);
                v = v + Accel(i)*0.001;
                s(i, count) = x;
                t(i, count) = Ts + count * 0.001;
                v_all(i, count) = v;
                a(i, count) = Accel(i);
            elseif (v + Accel(i)*0.001 >= Vm && t_count < t3)
                x = x + v * 0.001;
                t_count = t_count + 0.001;
                s(i, count) = x;
                t(i, count) = Ts + count * 0.001;
                v_all(i, count) = v;
                a(i, count) = 0;
            elseif (t_count >= t3 && v > 0)
                v1 = v - Decel(i)*0.001;
                if (v1 > 0)
                    x = x + (v^2-v1^2)/2/Decel(i);
                    v = v - Decel(i)*0.001;
                    s(i, count) = x;
                    t(i, count) = Ts + count * 0.001;
                    v_all(i, count) = v;
                    a(i, count) = -Decel(i);
                elseif (v1 <= 0)
                    t4 = v / Decel(i);
                    x = x + v^2/2/Decel(i);
                    s(i, count) = x;
                    t(i, count) = Ts + t(i, count-1) + t4;
                    v_all(i, count) = 0;
                    a(i, count) = -Decel(i);
                    flag = 0;
                end
            end
        end
        max_time = t(i, count)
    end
    if (i == 2)
        j = 1;
        Vm = Accel(j)*Decel(j)/(Accel(j)+Decel(j))*(max_time-sqrt(max_time^2-2*(Accel(j)+Decel(j))/Accel(j)/Decel(j)*TotalLength(j)));
        t3 = (TotalLength(j) - Vm^2/2/Accel(j) - Vm^2/2/Decel(j))/Vm;
        x = 0;
        v = 0;
        t_count = 0;
        count = 0;
        flag = 1;
        while (x < TotalLength(j) && flag)
            count = count + 1;
            if (v + Accel(j)*0.001 < Vm && t_count == 0)
                v1 = v + Accel(j)*0.001;
                x = x + (v1^2-v^2)/2/Accel(j);
                v = v + Accel(j)*0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = Accel(j);
            elseif (v + Accel(j)*0.001 >= Vm && t_count < t3)
                x = x + v * 0.001;
                t_count = t_count + 0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = 0;
            elseif (t_count >= t3 && v > 0)
                v1 = v - Decel(j)*0.001;
                if (v1 > 0)
                    x = x + (v^2-v1^2)/2/Decel(j);
                    v = v - Decel(j)*0.001;
                    s(j, count) = x;
                    t(j, count) = Ts + count * 0.001;
                    v_all(j, count) = v;
                    a(j, count) = -Decel(j);
                elseif (v1 <= 0)
                    t4 = v / Decel(j);
                    x = x + v^2/2/Decel(j);
                    s(j, count) = x;
                    t(j, count) = Ts + t(j, count-1) + t4;
                    v_all(j, count) = 0;
                    a(j, count) = -Decel(j);
                    flag = 0;
                end
            end
        end
        j = 3;
        Vm = Accel(j)*Decel(j)/(Accel(j)+Decel(j))*(max_time-sqrt(max_time^2-2*(Accel(j)+Decel(j))/Accel(j)/Decel(j)*TotalLength(j)));
        t3 = (TotalLength(j) - Vm^2/2/Accel(j) - Vm^2/2/Decel(j))/Vm;
        x = 0;
        v = 0;
        t_count = 0;
        count = 0;
        flag = 1;
        while (x < TotalLength(j) && flag)
            count = count + 1;
            if (v + Accel(j)*0.001 < Vm && t_count == 0)
                v1 = v + Accel(j)*0.001;
                x = x + (v1^2-v^2)/2/Accel(j);
                v = v + Accel(j)*0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = Accel(j);
            elseif (v + Accel(j)*0.001 >= Vm && t_count < t3)
                x = x + v * 0.001;
                t_count = t_count + 0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = 0;
            elseif (t_count >= t3 && v > 0)
                v1 = v - Decel(j)*0.001;
                if (v1 > 0)
                    x = x + (v^2-v1^2)/2/Decel(j);
                    v = v - Decel(j)*0.001;
                    s(j, count) = x;
                    t(j, count) = Ts + count * 0.001;
                    v_all(j, count) = v;
                    a(j, count) = -Decel(j);
                elseif (v1 <= 0)
                    t4 = v / Decel(j);
                    x = x + v^2/2/Decel(j);
                    s(j, count) = x;
                    t(j, count) = Ts + t(j, count-1) + t4;
                    v_all(j, count) = 0;
                    a(j, count) = -Decel(j);
                    flag = 0;
                end
            end
        end
    end
    if (i == 1)
        j = 2;
        Vm = Accel(j)*Decel(j)/(Accel(j)+Decel(j))*(max_time-sqrt(max_time^2-2*(Accel(j)+Decel(j))/Accel(j)/Decel(j)*TotalLength(j)));
        t3 = (TotalLength(j) - Vm^2/2/Accel(j) - Vm^2/2/Decel(j))/Vm;
        x = 0;
        v = 0;
        t_count = 0;
        count = 0;
        flag = 1;
        while (x < TotalLength(j) && flag)
            count = count + 1;
            if (v + Accel(j)*0.001 < Vm && t_count == 0)
                v1 = v + Accel(j)*0.001;
                x = x + (v1^2-v^2)/2/Accel(j);
                v = v + Accel(j)*0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = Accel(j);
            elseif (v + Accel(j)*0.001 >= Vm && t_count < t3)
                x = x + v * 0.001;
                t_count = t_count + 0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = 0;
            elseif (t_count >= t3 && v > 0)
                v1 = v - Decel(j)*0.001;
                if (v1 > 0)
                    x = x + (v^2-v1^2)/2/Decel(j);
                    v = v - Decel(j)*0.001;
                    s(j, count) = x;
                    t(j, count) = Ts + count * 0.001;
                    v_all(j, count) = v;
                    a(j, count) = -Decel(j);
                elseif (v1 <= 0)
                    t4 = v / Decel(j);
                    x = x + v^2/2/Decel(j);
                    s(j, count) = x;
                    t(j, count) = Ts + t(j, count-1) + t4;
                    v_all(j, count) = 0;
                    a(j, count) = -Decel(j);
                    flag = 0;
                end
            end
        end
        j = 3;
        Vm = Accel(j)*Decel(j)/(Accel(j)+Decel(j))*(max_time-sqrt(max_time^2-2*(Accel(j)+Decel(j))/Accel(j)/Decel(j)*TotalLength(j)));
        t3 = (TotalLength(j) - Vm^2/2/Accel(j) - Vm^2/2/Decel(j))/Vm;
        x = 0;
        v = 0;
        t_count = 0;
        count = 0;
        flag = 1;
        while (x < TotalLength(j) && flag)
            count = count + 1;
            if (v + Accel(j)*0.001 < Vm && t_count == 0)
                v1 = v + Accel(j)*0.001;
                x = x + (v1^2-v^2)/2/Accel(j);
                v = v + Accel(j)*0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = Accel(j);
            elseif (v + Accel(j)*0.001 >= Vm && t_count < t3)
                x = x + v * 0.001;
                t_count = t_count + 0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = 0;
            elseif (t_count >= t3 && v > 0)
                v1 = v - Decel(j)*0.001;
                if (v1 > 0)
                    x = x + (v^2-v1^2)/2/Decel(j);
                    v = v - Decel(j)*0.001;
                    s(j, count) = x;
                    t(j, count) = Ts + count * 0.001;
                    v_all(j, count) = v;
                    a(j, count) = -Decel(j);
                elseif (v1 <= 0)
                    t4 = v / Decel(j);
                    x = x + v^2/2/Decel(j);
                    s(j, count) = x;
                    t(j, count) = Ts + t(j, count-1) + t4;
                    v_all(j, count) = 0;
                    a(j, count) = -Decel(j);
                    flag = 0;
                end
            end
        end
    end
    if (i == 3)
        j = 1;
        Vm = Accel(j)*Decel(j)/(Accel(j)+Decel(j))*(max_time-sqrt(max_time^2-2*(Accel(j)+Decel(j))/Accel(j)/Decel(j)*TotalLength(j)));
        t3 = (TotalLength(j) - Vm^2/2/Accel(j) - Vm^2/2/Decel(j))/Vm;
        x = 0;
        v = 0;
        t_count = 0;
        count = 0;
        flag = 1;
        while (x < TotalLength(j) && flag)
            count = count + 1;
            if (v + Accel(j)*0.001 < Vm && t_count == 0)
                v1 = v + Accel(j)*0.001;
                x = x + (v1^2-v^2)/2/Accel(j);
                v = v + Accel(j)*0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = Accel(j);
            elseif (v + Accel(j)*0.001 >= Vm && t_count < t3)
                x = x + v * 0.001;
                t_count = t_count + 0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = 0;
            elseif (t_count >= t3 && v > 0)
                v1 = v - Decel(j)*0.001;
                if (v1 > 0)
                    x = x + (v^2-v1^2)/2/Decel(j);
                    v = v - Decel(j)*0.001;
                    s(j, count) = x;
                    t(j, count) = Ts + count * 0.001;
                    v_all(j, count) = v;
                    a(j, count) = -Decel(j);
                elseif (v1 <= 0)
                    t4 = v / Decel(j);
                    x = x + v^2/2/Decel(j);
                    s(j, count) = x;
                    t(j, count) = Ts + t(j, count-1) + t4;
                    v_all(j, count) = 0;
                    a(j, count) = -Decel(j);
                    flag = 0;
                end
            end
        end
        j = 2;
        Vm = Accel(j)*Decel(j)/(Accel(j)+Decel(j))*(max_time-sqrt(max_time^2-2*(Accel(j)+Decel(j))/Accel(j)/Decel(j)*TotalLength(j)));
        t3 = (TotalLength(j) - Vm^2/2/Accel(j) - Vm^2/2/Decel(j))/Vm;
        x = 0;
        v = 0;
        t_count = 0;
        count = 0;
        flag = 1;
        while (x < TotalLength(j) && flag)
            count = count + 1;
            if (v + Accel(j)*0.001 < Vm && t_count == 0)
                v1 = v + Accel(j)*0.001;
                x = x + (v1^2-v^2)/2/Accel(j);
                v = v + Accel(j)*0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = Accel(j);
            elseif (v + Accel(j)*0.001 >= Vm && t_count < t3)
                x = x + v * 0.001;
                t_count = t_count + 0.001;
                s(j, count) = x;
                t(j, count) = Ts + count * 0.001;
                v_all(j, count) = v;
                a(j, count) = 0;
            elseif (t_count >= t3 && v > 0)
                v1 = v - Decel(j)*0.001;
                if (v1 > 0) 
                    x = x + (v^2-v1^2)/2/Decel(j);
                    v = v - Decel(j)*0.001;
                    s(j, count) = x;
                    t(j, count) = Ts + count * 0.001;
                    v_all(j, count) = v;
                    a(j, count) = -Decel(j);
                elseif (v1 <= 0)
                    t4 = v / Decel(j);
                    x = x + v^2/2/Decel(j);
                    s(j, count) = x;
                    t(j, count) = Ts + t(j, count-1) + t4;
                    v_all(j, count) = 0;
                    a(j, count) = -Decel(j);
                    flag = 0;
                end
            end
        end
    end
    for i = 1:3
        if (s(i, length(s(i,:))) == 0) s(i, length(s(i,:))) = s(i, length(s(i,:))-1); end
        if (t(i, length(t(i,:))) == 0) t(i, length(t(i,:))) = t(i, length(t(i,:))-1); end
    end
    if flag_x == 0
        for i = 1:length(s(i,:))
            s(1, i) = -s(1, i);
            v_all(1, i) = -v_all(1, i);
            a(1, i) = -a(1, i);
        end
    end
    if flag_y == 0
        for i = 1:length(s(i,:))
            s(2, i) = -s(2, i);
            v_all(2, i) = -v_all(2, i);
            a(2, i) = -a(2, i);
        end
    end
    if flag_z == 0
        for i = 1:length(s(i,:))
            s(3, i) = -s(3, i);
            v_all(3, i) = -v_all(3, i);
            a(3, i) = -a(3, i);
        end
    end
    MotionData = struct();
    MotionData.t = t;
    MotionData.v = v_all;
    MotionData.a = a;
    MotionData.s = s;
    MotionData.maxtime = max_time;
end
