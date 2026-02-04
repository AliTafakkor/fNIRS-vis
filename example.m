%% fNIRS 3D Visualization - High Visibility Demo
clear; clc; close all;

% Ensure mesh exists
if ~exist('data/mni_brain.mat', 'file'), install_fnirs_toolbox(); end

% Define Channels (MNI Coordinates)
% Channel 1: Left Motor
s1 = [-40, -20, 70]; d1 = [-35, -10, 65];
% Channel 2: Right Motor
s2 = [40, -20, 70]; d2 = [35, -10, 65];

sources = [s1; s2];
detectors = [d1; d2];
wavelengths = [690; 850]; % Mix of wavelengths

% Execute
fNIRS_3D_Toolbox.plot_session(sources, detectors, wavelengths);

title('fNIRS Photon Paths (Bright Mode)', 'FontSize', 14);