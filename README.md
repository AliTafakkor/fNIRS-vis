# 🧠 fNIRS 3D High-Fidelity Visualization Toolbox

A lightweight MATLAB toolbox to visualize wavelength-dependent photon migration paths (the "banana shape") in MNI space. It models the sensitivity volume between source-detector pairs using tapered tube meshes and wavelength-specific physics.

## 🛠 Features
- **Wavelength Physics:** Supports 690nm, 850nm, etc. Longer wavelengths result in deeper penetration and broader diffusion volumes.
- **Organic Geometry:** Uses `pchip` splines and tapered tube meshes to mimic the actual spatial sensitivity profile (Jacobian) of fNIRS.
- **Layered Rendering:** Visualizes a core sensitivity path and an outer "glow" to represent the probability distribution of photon paths.
- **MNI Integration:** Automatically maps paths onto a transparent 3D MNI brain surface.

## 🔬 Physics & Modeling Notes
The "banana" thickness and depth are not static. This toolbox uses the following logic to approximate the photon path:

1. **Penetration Depth:** The path curves toward the center of the head. The maximum depth ($D$) is determined by the Source-Detector separation ($d_{SD}$) and scaled by the wavelength ($\lambda$):
   $$D \approx (d_{SD} \times 0.45) \times \frac{\lambda}{800}$$
2. **Diffusion Volume:** The thickness of the path follows a sinusoidal taper. It is narrowest at the optodes (contact points) and widest at the midpoint of the arc, representing the scattering of photons as they travel deeper into the tissue.
3. **Wavelength Sensitivity:** Longer wavelengths (e.g., 850nm) are modeled with a broader radius and deeper peak to account for the reduced absorption coefficient in the "optical window," allowing photons to migrate further.

## 🚀 Installation
1. Ensure `install_fnirs_toolbox.m` and `fNIRS_3D_Toolbox.m` are in your MATLAB path.
2. Run the installer to fetch the MNI mesh:
   ```matlab
   install_fnirs_toolbox

📂 Project Structure
- `fNIRS_3D_Toolbox.m`: Core rendering engine.

- `install_fnirs_toolbox.m`: Utility to fetch standard brain meshes.

- `run_fNIRS_example.m`: A single-file demonstration script.