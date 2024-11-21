clc;
data = table2array(data);
a_1 = 250;
a_2 = 250;
h = 0;
gst_0 = [1 0 0 a_1+a_2
         0 -1 0 0
         0 0 -1 0
         0 0 0 1];
g_x=[]
g_y=[]
g_z=[]
g_xr=[]
g_yr=[]
g_zr=[]
for i=(1:length(data))
    g1 = zyz2exp(-cross([0 0 1]',[0 0 h]'),[0 0 1]',data(i, 1));
    g2 = zyz2exp(-cross([0 0 1]',[a_1 0 h]'),[0 0 1]',data(i, 2));
    g3 = zyz2exp([0 0 -1]',[0 0 0]',data(i, 3));
    g4 = zyz2exp(-cross([0 0 -1]',[0 a_1+a_2 h]'),[0 0 -1]',data(i, 4));
    g11 = zyz2exp(-cross([0 0 1]',[0 0 h]'),[0 0 1]',data(i,5));
    g21 = zyz2exp(-cross([0 0 1]',[a_1 0 h]'),[0 0 1]',data(i, 6));
    g31 = zyz2exp([0 0 -1]',[0 0 0]',data(i, 7));
    g41 = zyz2exp(-cross([0 0 -1]',[0 a_1+a_2 h]'),[0 0 -1]',data(i, 8));
    gst_end = g1*g2*g3*g4*gst_0
    gst_end1 = g11*g21*g31*g41*gst_0
    g_1=[gst_end(1,4) gst_end(2,4) gst_end(3,4)]'
    g_x = [g_x gst_end(1,4)];
    g_y = [g_y gst_end(2,4)];
    g_z = [g_z gst_end(3,4)];
    g_xr = [g_xr gst_end1(1,4)];
    g_yr = [g_yr gst_end1(2,4)];
    g_zr = [g_zr gst_end1(3,4)];
end
figure(1);
plot3(g_x, g_y, g_z, 'b', 'LineWidth', 1);
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Three-didataensional Plot');
figure(2);
plot3(g_xr, g_yr, g_zr, 'g', 'LineWidth', 1);
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Three-didataensional Plot');
