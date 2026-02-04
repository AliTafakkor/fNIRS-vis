function install_fnirs_toolbox()
    fprintf('--- Initializing fNIRS 3D Toolbox Setup ---\n');
    
    % 1. Create directory structure
    if ~exist('data', 'dir'), mkdir('data'); end
    
    % 2. Download MNI Brain Mesh
    % Using a reliable public URL for a low-poly MNI152 brain for speed
    brain_url = 'https://raw.githubusercontent.com/fieldtrip/fieldtrip/master/template/anatomy/surface_pial_both.mat';
    head_url = 'https://raw.githubusercontent.com/fieldtrip/fieldtrip/master/template/anatomy/surface_scalp_left.mat'; % Placeholder for scalp
    
    fprintf('Downloading MNI Brain Mesh (FieldTrip Template)... ');
    try
        if ~exist('data/mni_brain.mat', 'file')
            websave('data/mni_brain.mat', brain_url);
            fprintf('Done.\n');
        else
            fprintf('Already exists. Skipping.\n');
        end
    catch
        warning('Download failed. Using fallback ellipsoid geometry.');
    end

    % 3. Add current folder to MATLAB path
    addpath(genpath(pwd));
    savepath;
    
    fprintf('Setup Complete. You can now run the example script.\n');
end