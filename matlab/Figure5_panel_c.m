%
% Sample simulation and plotting script...
%
% June 8th 2011 - Alex Loebel & Michele Giugliano
%

 clear all;
 close all;
 clc;
 
 randn('state', 21);

 J         = 10.5;      % Recurrent synaptic coupling efficacy
 U         = 0.35;      % Probability of synaptic release 
 tau_rec   = 0.5;       % Depression recovery time constant [sec]
 tau_fac   = 0.300;     % Facilitation recovery time constant [sec]

 T         = 200.;      % Simulation life-time [sec]
 dt        = 0.0005;    % Integration time-step [sec] 
 N         = fix(T/dt); % Number of iterations
 M         = fix(N/4);  % Number of points to discard transients
 
 tau_V     = 0.05;      % Membrane time-constant [sec]
 threshold = 2.;        % Neuronal response function threshold
 alpha     = 1.;        % Neuronal response function gain
 sigma     = 0.4;       % Intensity of background noise
 I         = 0.;        % External input
 
 V         = 0.;        % Voltage [a.u.]
 u         = U;         % Instantaneous probability of release
 x         = 1.;        % Amount of recovered resources [a.u.]
 out       = zeros(N, 1);% Preallocation of output data structure [a.u.]
 t         = dt*(1:N); % Time axis for plotting purpouses only [sec]

for k=1:N,
  out(k) = V;
  
  noise = sigma * sqrt(dt) / tau_V * randn;
  V = V + (dt/tau_V) * (-V + J * u * x * PHI(V, threshold, alpha) + I) + noise;
  x = x + dt *         ( (1.-x)/tau_rec - u * x * PHI(V, threshold, alpha) );
  u = u + dt *         ( (U-u)/tau_fac + U * (1-u) * PHI(V, threshold, alpha) );
end

out = out(M:end);
t   = t(M:end);

figure; set(gcf, 'Color', [1 1 1]);
h1 = subplot(1,2,1);
h2 = subplot(1,2,2); 
set(h1, 'Position', [0.03   0.1100    0.65      0.4150])
set(h2, 'Position', [0.7    0.1100    0.2347    0.4150])

axes(h1);
P = plot(t, out, 'k');
set(P, 'LineWidth', 1);
set(h1, 'XLim', [50 100], 'YLim', [-10 100], 'Visible', 'on');
set(h1, 'XTick', [55:5:95], 'YTick', [10:20:90]);
xlabel('time (s)',  'FontName', 'Arial', 'FontSize', 30);
ylabel('Net activity (a.u.)',  'FontName', 'Arial', 'FontSize', 30);
YLIM = get(h1, 'Ylim');


axes(h2);
[nn xx] = hist(out, 400);
B = bar(xx, nn/length(nn),1);
set(B, 'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);

set(h2, 'XLim', [-20 70], 'XLim', YLIM);
set(h2, 'View', [90 -90], 'XAxisLocation', 'top')
set(h2, 'XTick', [10:20:90], 'YTickLabel', '');

set([h1 h2],  'FontName', 'Arial', 'FontSize', 15)


print(gcf, '-depsc2', 'Figure5_panel_c.eps')
print(gcf, '-dpng', 'Figure5_panel_c.png')

