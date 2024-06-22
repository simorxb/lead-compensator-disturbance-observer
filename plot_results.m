% Access the signals from out.logsout

r = out.logsout.get('r').Values.Data;
t_r = out.logsout.get('r').Values.Time;
z = out.logsout.get('z').Values.Data;
t_z = out.logsout.get('z').Values.Time;
z_hat = out.logsout.get('z_hat').Values.Data;
t_z_hat = out.logsout.get('z_hat').Values.Time;
F = out.logsout.get('F').Values.Data;
t_F = out.logsout.get('F').Values.Time;
Fd = out.logsout.get('Fd').Values.Data;
t_Fd = out.logsout.get('Fd').Values.Time;
Fd_hat = out.logsout.get('Fd_hat').Values.Data;
t_Fd_hat = out.logsout.get('Fd_hat').Values.Time;

% Create the first figure
figure;

% Subplot for position
subplot(3, 1, 1);
plot(t_r, r, '--', 'LineWidth', 2);
hold on;
plot(t_z, z, 'LineWidth', 2);
plot(t_z_hat, z_hat, 'LineWidth', 2);
hold off;
ylabel('Position (m)');
set(gca, 'FontSize', 12);
title('Position');
legend({'Setpoint', 'Measurement', 'Estimated'}, 'FontSize', 12);
grid on;

% Subplot for control input
subplot(3, 1, 2);
plot(t_F, F, 'LineWidth', 2);
ylabel('Force (N)');
set(gca, 'FontSize', 12);
title('Control Input');
grid on;

% Subplot for disturbance
subplot(3, 1, 3);
plot(t_Fd, Fd, 'LineWidth', 2);
hold on;
plot(t_Fd_hat, Fd_hat, 'LineWidth', 2);
hold off;
ylabel('Force (N)');
xlabel('Time (s)');
set(gca, 'FontSize', 12);
title('Disturbance');
legend({'Actual', 'Estimated'}, 'FontSize', 12);
grid on;