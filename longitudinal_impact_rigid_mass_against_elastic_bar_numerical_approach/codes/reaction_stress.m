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
rs = zeros(1, length(t)); % reaction stress
s__1 = zeros(1, length(t)); % s__n(t). here, n=1
sigma__0 = rho * c * v__0; % sigma__0

% analytical solution
figure('position', [0 0 800 600])
hold on
% loop over time periods
for ii = 1:length(t)
    if t(ii) > 0 && t(ii) <= T
        rs(ii) = 2 * sigma__0 * exp(-t(ii) / M * sqrt(E * rho));
    elseif t(ii) >= T && t(ii) < 2*T
        % s__1(t)
        s__1(ii) = sigma__0 * exp(-2 * t(ii) / T) + sigma__0 * exp(-2*(t(ii) / T - 1)) * (1 + 4 * (1 - t(ii) / T));
        % contact stress = s__n(t) + s__(n-1)(t - T)
        % here, contact stress = s__1(t) + s__0(t - T)
        rs(ii) = s__1(ii) + sigma__0 * exp(-(t(ii) - T) / M * sqrt(E * rho));
    end
end
plot(t(2:end) + T/2, rs(2:end), 'k', 'LineWidth', 2)

% numerical result
d__n = importdata('reaction_force.txt'); % numerical time
t__n = d__n.data(:, 2); % numerical length
f__n = d__n.data(:, 5); % numerical reaction force
s__n = f__n / A;
plot(t__n, s__n, '--k', 'LineWidth', 2)
xlabel('t[s]', 'Interpreter','latex', 'FontSize', 14)
ylabel('Reaction Stress[Pa]', 'Interpreter','latex', 'FontSize', 18)
set(gca, 'FontSize', 20)
legend('Analytical', 'Numerical', 'Location', 'southwest', 'Interpreter','latex', 'FontSize', 20)
box on
xlim([0, max(t__n)])

% save figures
saveas(figure(1), 'figs/reaction_stress', 'epsc')