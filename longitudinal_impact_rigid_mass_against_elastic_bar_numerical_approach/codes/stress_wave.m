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

% initializing
t = linspace(0, tt, 100);
l = linspace(0, L, length(t));
sigma = zeros(1, length(t)); % initialize stress wave
sigma__0 = rho * c * v__0; % sigma__0
time = [1.551e-5, 3.49e-5, tt + 1.551e-5]; % desired time for extracting wave stress

% loop over times 
for jj = 1:length(time)
    % analytical solution
    figure('position', [0 0 800 600])
    hold on
    if time(jj) <= tt % 0 < t < T/2 where T = 2L/c
        for ii = 1:length(t)
            if t(ii) <= time(jj)
                sigma(ii) = sigma__0 * exp(-t(ii) / M * sqrt(E * rho));
            else
                sigma(ii) = 0;
            end
        end
        plot(l, sigma, 'k', 'LineWidth', 2)
    else % T/2 < t < T 
        for ii = 1:length(t)
            if t(ii) <= time(jj) - tt
                sigma(ii) = sigma__0 + sigma__0 * exp(-t(ii) / M * sqrt(E * rho));
            else
                sigma(ii) = sigma__0 * exp(-t(ii) / M * sqrt(E * rho));
            end
        end
        plot(fliplr(l), sigma, 'k', 'LineWidth', 2)
    end
    
    % numerical result
    t__n = importdata(sprintf('stress_t%d.txt', jj)); % time
    l__n = t__n.data(:, 2); % length
    s__n = t__n.data(:, 7); % wave stress
    plot(l__n, -s__n, '--k', 'LineWidth', 2)
    xlabel('L[m]', 'Interpreter','latex', 'FontSize', 18)
    ylabel('$\sigma$[Pa]', 'Interpreter','latex', 'FontSize', 18)
    set(gca, 'FontSize', 20)
    legend('Analytical', 'Numerical', 'Interpreter','latex', 'FontSize', 20)
    if jj == 3
        legend('Analytical', 'Numerical', 'Interpreter','latex', 'FontSize', 20, 'location', 'northwest')
    end
    box on
end

% save figures
saveas(figure(1), 'figs/stress_t1', 'epsc')
saveas(figure(2), 'figs/stress_t2', 'epsc')
saveas(figure(3), 'figs/stress_t3', 'epsc')