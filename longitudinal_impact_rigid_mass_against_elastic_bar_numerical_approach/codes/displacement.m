clc
clear
% close all
clf

% LateX interpreter for plots
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');

addpath('fe_result')

E = 2.1e11;
rho = 7.9e3;
L = 0.3;
A = 9e-4;
m = 2.133;
v__0 = 1;

% calculated parameters
M = m / A;
c = sqrt(E / rho); % wave propagation speed
tt = L / c; % required time for the wave to travel through the beam
T = 2 * tt;

% initializing
alpha = 1; % L*rho / M
t = linspace(0, 5e-4, 100);
l = linspace(0, L, length(t));
d = zeros(1, length(t)); % displacement
sigma__0 = rho * c * v__0; % sigma__0

% analytical solution
% figure('position', [0 0 800 600])
hold on
% loop over time periods
for ii = 1:length(t)
    if t(ii) >= 0 && t(ii) < T % T<t<2T
        d(ii) = L * v__0 / c * (1 - exp(-1 / L * (c * t(ii) - l(ii))));
    elseif t(ii) >= T && t(ii) < 2*T % T<t<2T
        d(ii) = L * v__0 / c * (1 - exp(-1 / L * (c * (t(ii) - T - 2*  l(ii))))) +...
            L* v__0 / c * (-1 + (1 + 2 * ((c * t(ii)  - l(ii)) / L - 2)) * exp(2 - (c * t(ii)  - l(ii)) / L));
    end
end
plot(t, d, 'k', 'LineWidth', 2)

% numerical result
t__n = importdata('displacement.txt'); % numerical time
t = t__n.data(:, 2); % numerical length
d__n = t__n.data(:, 3); % numerical reaction force
plot(t, -d__n, '--k', 'LineWidth', 2)
xlabel('t[s]', 'Interpreter','latex', 'FontSize', 14)
ylabel('Displacement[m]', 'Interpreter','latex', 'FontSize', 18)
set(gca, 'FontSize', 20)
box on
legend('Analytical', 'Numerical', 'Interpreter','latex', 'FontSize', 20)
xlim([0, max(t)])

% save figures
saveas(figure(1), 'figs/displacement', 'epsc')