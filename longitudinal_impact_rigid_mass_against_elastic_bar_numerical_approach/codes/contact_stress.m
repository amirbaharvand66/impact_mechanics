clc
clear
close all

% LateX interpreter for plots
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');

addpath('fe_result')

% beam data
E = 2.1e11; % Young's modulus
rho = 7.9e3; % density
L = 0.3; % length
A = 9e-4; % area
m = 2.133; % mass

% rigid mas data
v__0 = 1; % initial velocity

% calculated parameters
M = m / A;
c = sqrt(E / rho); % wave propagation speed
tt = L / c; % required time for the wave to travel through the beam
T = 2 * tt;

% initializing
alpha = 1; % L*rho / M
t = linspace(0, 2.5e-4, 100);
l = linspace(0, L, length(t));
cs = zeros(1, length(t)); % reaction stress
s__1 = zeros(1, length(t)); % s__n(t). here, n=1
sigma__0 = rho * c * v__0; % sigma__0

% analytical solution
figure('position', [0 0 800 600])
hold on
% loop over time periods
for ii = 1:length(t)
    if t(ii) <= T % 0<t<T/2 where T = 2L/c
        cs(ii) = sigma__0 * exp(-t(ii) / M * sqrt(E * rho));
    elseif t(ii) > T && t(ii) <= 2*T % T<t<2T
        % s__1(t)
        s__1(ii) = sigma__0 * exp(-2 * t(ii) / T) + sigma__0 * exp(-2*(t(ii) / T - 1)) * (1 + 4 * (1 - t(ii) / T));
        % contact stress = s__n(t) + s__(n-1)(t - T)
        % here, contact stress = s__1(t) + s__0(t - T)
        cs(ii) = s__1(ii) + sigma__0 * exp(-(t(ii) - T) / M * sqrt(E * rho));
    end
end
plot(t, cs, 'k', 'LineWidth', 2)

% numerical result
t__n = importdata('contact_stress.txt'); % numerical time
t_n = t__n.data(:, 2); % numerical length
cs__n = t__n.data(:, 3); % numerical reaction force
plot(t_n, -cs__n, '--k', 'LineWidth', 2)
xlabel('t[s]', 'Interpreter','latex', 'FontSize', 14)
ylabel('Contact Pressure[Pa]', 'Interpreter','latex', 'FontSize', 18)
set(gca, 'FontSize', 20)
set(gca, 'FontSize', 20)
legend('Analytical', 'Numerical', 'Interpreter','latex', 'FontSize', 20)
box on
xlim([0, max(t_n)])

% save figures
saveas(figure(1), 'figs/contact_pressure', 'epsc')