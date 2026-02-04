classdef fNIRS_3D_Toolbox
    methods (Static)
        function plot_session(S_pos, D_pos, wavelengths)
            if nargin < 3, wavelengths = repmat(850, size(S_pos, 1), 1); end

            % --- High Visibility Figure Setup ---
            figure('Color', 'w', 'Name', 'fNIRS 3D Visualization (Bright Mode)');
            hold on; axis equal; view([120 20]);
            grid on; 
            set(gca, 'FontSize', 10, 'GridColor', [0.8 0.8 0.8]);
            
            % 1. Plot MNI Brain (Increased Opacity)
            if exist('data/mni_brain.mat', 'file')
                load('data/mni_brain.mat', 'mesh');
                patch('Faces', mesh.tri, 'Vertices', mesh.pos, ...
                    'FaceColor', [0.8 0.8 0.8], 'EdgeColor', 'none', ...
                    'FaceAlpha', 0.25); % Increased for better visibility
            end

            % 2. Render Paths
            for i = 1:size(S_pos, 1)
                fNIRS_3D_Toolbox.draw_accurate_path(S_pos(i,:), D_pos(i,:), wavelengths(i));
            end

            % 3. Plot Optodes (Bright Colors)
            scatter3(S_pos(:,1), S_pos(:,2), S_pos(:,3), 150, [0.9 0.1 0.1], 'filled', 'MarkerEdgeColor', 'k');
            scatter3(D_pos(:,1), D_pos(:,2), D_pos(:,3), 150, [0.1 0.1 0.9], 'filled', 'MarkerEdgeColor', 'k');
            
            % 4. Enhanced Lighting
            l1 = camlight('right');
            l2 = camlight('left');
            set(l1, 'Intensity', 0.8);
            set(l2, 'Intensity', 0.5);
            lighting gouraud;
            
            xlabel('MNI X'); ylabel('MNI Y'); zlabel('MNI Z');
        end

        function draw_accurate_path(S, D, wl)
            dist = norm(S-D);
            mid = (S + D) / 2;
            
            % Wavelength scaling (850nm goes deeper than 690nm)
            wl_factor = (wl / 800); 
            depth = (dist * 0.45) * wl_factor;
            inward = -mid / norm(mid);
            peak = mid + (inward * depth);
            
            % Organic Curve Generation
            t = linspace(0, 1, 40);
            path = zeros(length(t), 3);
            for d = 1:3
                path(:,d) = interp1([0, 0.5, 1], [S(d), peak(d), D(d)], t, 'pchip');
            end
            
            % Diffusion Volume (Tapered)
            base_radius = (dist * 0.18) * wl_factor;
            [X, Y, Z] = fNIRS_3D_Toolbox.tube_mesh(path, base_radius);
            
            % Render with bright, glowing orange
            surf(X, Y, Z, 'FaceColor', [1 0.5 0], 'EdgeColor', 'none', ...
                'FaceAlpha', 0.6, 'AmbientStrength', 0.6);
        end

        function [X, Y, Z] = tube_mesh(path, r)
            n = size(path, 1); m = 24; theta = linspace(0, 2*pi, m);
            X = zeros(n, m); Y = zeros(n, m); Z = zeros(n, m);
            for i = 1:n
                taper = sin(pi * (i-1)/(n-1))^0.6; 
                current_r = r * max(taper, 0.08); 
                
                if i < n, tang = path(i+1,:) - path(i,:);
                else, tang = path(i,:) - path(i-1,:); end
                [~, v1, v2] = fNIRS_3D_Toolbox.null_basis(tang);
                X(i,:) = path(i,1) + current_r * (cos(theta)*v1(1) + sin(theta)*v2(1));
                Y(i,:) = path(i,2) + current_r * (cos(theta)*v1(2) + sin(theta)*v2(2));
                Z(i,:) = path(i,3) + current_r * (cos(theta)*v1(3) + sin(theta)*v2(3));
            end
        end

        function [v, v1, v2] = null_basis(v)
            v = v / (norm(v) + eps);
            if abs(v(1)) > 0.1, v1 = [-v(2), v(1), 0];
            else, v1 = [0, -v(3), v(2)]; end
            v1 = v1 / norm(v1); v2 = cross(v, v1);
        end
    end
end