clc
clear
close all

% LateX interpreter for plots
set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');

% problem data
c__p = 1000; %wave propagation speed[m/s]
a = 1; %cavity radius[m]
nu = [0, 0.25, 0.45]; %Poisson's ratio
t = linspace(0,0.05, 100);
r = 200*a;
p = 1;

% customize plot
line_style = {'-', '--', ':', '-.'};
mkr = {'o', '^', 's', '*'};
clr = {'r', 'g', 'b'};

figure ('position', [0 0 800 500])
for ii = 1:length(nu)
    
    
    alpha = 1 / sqrt(1-2*nu(ii));
    tau = t - (r - a) / c__p;
    d = (1 - nu(ii)) / (2 * (1 - 2 * nu(ii)));
    theta = alpha*c__p*tau/(2*d*a);
    sigma__r = -p*a^3/r^3 * (1 + ((r^2-a^2)/a^2*cos(theta) - ((r-a)/a)^2*1/alpha*sin(theta)) .* exp(-c__p * tau/(2*d*a))) .* heaviside(tau);
    sigma__r = double(sigma__r);
    plot(t*c__p/a, sigma__r/p, 'DisplayName', ['$\nu$=' num2str(nu(ii)) 'm'], 'LineWidth', 2, 'LineStyle', line_style{ii}, 'Color', clr{ii}, 'Marker', mkr{ii})
    hold on
    
    legend('show', 'Location', 'east', 'Interpreter','latex', 'FontSize', 14)
    set(gca, 'FontSize', 16)
    xlabel('$\frac{c_p t}{a}$[-]', 'Interpreter','latex', 'FontSize', 28)
    ylabel('$\frac{\sigma_r}{p}$[-]', 'Interpreter','latex', 'FontSize', 28);
    ylim([-1.2, 0.2])
end

% save figures
saveas(figure(1), 'large_r', 'epsc')