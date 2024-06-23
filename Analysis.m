%% Controller Design

% Define system parameters
m = 10;
k = 0.5;

% Transfer function variable
s = tf('s');

% System transfer function
P = 1/(s*(m*s + k));

% Lead compensator parameters
kl = 14.76;
tau_p = 0.1;
tau_z = 1.5;

% Lead compensator transfer function
C_L = kl * (tau_z * s + 1) / (tau_p * s + 1);

% Closed-loop transfer function for lead compensator
G_L = feedback(C_L * P, 1);

% Print G_L poles
disp('Poles of the closed-loop transfer function:');
poles = pole(G_L);
disp(poles);

% Plot root locus for lead compensator
figure;
rlocus(C_L * P);
title('Root Locus with Lead Compensator');

% Add current poles to root-locus
hold on;
plot(real(poles), imag(poles), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
hold off;

% Plot Bode diagram for lead compensator
figure;
bode(C_L * P);
title('Bode Plot with Lead Compensator');
grid on;

% Calculate the gain and phase margins for lead compensator
[gm, pm, wcg, wcp] = margin(C_L * P);
gm_dB = 20 * log10(gm);

% Print margins
fprintf('Gain Margin: %.3g dB at frequency %.3g rad/sec\n', gm_dB, wcg);
fprintf('Phase Margin: %.3g deg at frequency %.3g rad/sec\n', pm, wcp);
fprintf('Delay Margin: %.3g seconds\n', (pm * pi / 180) / wcp);

% Step response plot
figure;
subplot(2, 1, 1);
[y_G_L, T_G_L] = step(G_L);
plot(T_G_L, y_G_L, 'LineWidth', 2);
title('Step Response');
grid on;
xlabel('Time [s]');
ylabel('Position [m]');

% Transfer function from setpoint to control input (torque)
G_L_u = C_L / (1 + C_L * P);

% Step response - control input
subplot(2, 1, 2);
[y_G_L_u, T_G_L_u] = step(G_L_u);
plot(T_G_L_u, y_G_L_u, 'LineWidth', 2);
title('Control Input');
grid on;
xlabel('Time [s]');
ylabel('Force [N]');

%% Observer Design

% Extended system dynamics (3rd state is the disturbance)

Ae = [-k/m 0 1/m; 1 0 0; 0 0 0];
Be = [1/m; 0; 0];
Ce = [0 1 0];
De = 0;

% Place observer poles farther left from the closed loop function poles
L = place(Ae', Ce', [-3 -3.5 -4])';

%% Discretize Controller

% Sample time
Ts = 0.1;

% Discretize controller
C_L_d = c2d(C_L, Ts, 'matched');

% Discretise Observer
obs = ss(Ae, Be, Ce, De);
obs_d = c2d(obs, Ts);