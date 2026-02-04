% Generation of the Dipole Kernel
%   D = dipole_kernel(matrix_size, voxel_size, B0_dir, ...)
%
%   output
%   D - dipole kernel saved in Fourier space
% 
%   input
%   matrix_size - the size of the matrix
%   voxel_size - the size of a voxel
%   B0_dir - the direction of the B0 field
%   domain - 'imagespace' or 'kspace'
%       Fourier domain expression:
%       Salomir et al. Concepts in Magn Reson Part B 2003, 19(B):26-34
%       Image domain expression: 
%       Li et al. Magn Reson Med 2004, 51(5):1077-82
%
%
%   Created by Tian Liu in 2008
%   Modified by Tian Liu on 2011.02.01
%   Last modified by Tian Liu on 2013.07.22
%   Modified by S.R. on November 20, 2025


function D = my_dipole_kernel(matrix_size, voxel_size, B0_dir)

    if ischar(B0_dir) || isstring(B0_dir)
        if B0_dir == "x"
            B0_dir = [1 0 0]';
        elseif B0_dir == "y"
            B0_dir = [0 1 0]';
        elseif B0_dir == "z"
            B0_dir = [0 0 1]';
        end
    end

% Calculate and save both
    [Y,X,Z]=meshgrid(-matrix_size(2)/2:(matrix_size(2)/2-1),...
        -matrix_size(1)/2:(matrix_size(1)/2-1),...
        -matrix_size(3)/2:(matrix_size(3)/2-1));
    
    X = X/(matrix_size(1)*voxel_size(1));
    Y = Y/(matrix_size(2)*voxel_size(2));
    Z = Z/(matrix_size(3)*voxel_size(3));
    
    D = 1/3-  ( X*B0_dir(1) + Y*B0_dir(2) + Z*B0_dir(3) ).^2./(X.^2+Y.^2+Z.^2);
    D(isnan(D)) = 0;
    D_k = fftshift(D);
    niftiwrite(D_k,"fourier_domain_dipole_kernel.nii.gz")
    d_img = ifftn(ifftshift(D_k));
    niftiwrite(single(real(d_img)), "image_domain_dipole_kernel.nii.gz")
    

end


