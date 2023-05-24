close all, clear all, clc
%% Parâmetros
R = 0.195/2; L = 0.331;

emin = 0.05;
u_max = 1.2;
omega_max = (pi/180)*300;

ke = 0.3; kalpha = 1; kd_alpha = -0.5; % Não utilizados (linear).
gamma = 0.3; k = 1; % Parâmetros do controlador não-linear (Lyapunov).

fuzzyCreate

%% Variantes do modelo
BEHAVIOR_CONTROLLER = 2;
FUZZY       = Simulink.Variant("BEHAVIOR_CONTROLLER == 1");
POTENTIAL   = Simulink.Variant("BEHAVIOR_CONTROLLER == 2");

%% Simulação
% open_system('model');   % open_system('model_R2020a');
out = sim('model');     % sim('model_R2020a');

%% Plot da trajetória
plotMap

figname = input('Figure name: ','s');
saveas(fig,['Images/',figname,'.png']);
