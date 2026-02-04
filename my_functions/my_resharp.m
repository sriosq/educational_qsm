% Copied code from Sun et al. MRM 2014;71(3):1151-7 
% which was created by Tian Liu on 2014.02.01
% For the purpose of L-curve creation

function RDF=my_resharp(iFreq,Mask, matrix_size,voxel_size,radius,alpha)

if (nargin<6)
    alpha=0.01;
end
if (nargin<5)
    radius=round(6/max(voxel_size)) * max(voxel_size);
end

% generate the convolution/deconvolution kernel
S = SMV_kernel(matrix_size, voxel_size, radius);
M1 = SMV(Mask, matrix_size, voxel_size, radius)>0.999;

A = @(x) M1.*ifftn(S.*fftn(x));
Ah = @(x) ifftn(S.*fftn(M1.*x));
b = Ah(A(iFreq));
FW = @(x) (A(Ah(x))+alpha*(x));

RDF = cgsolve(FW, b, 1e-2,40,0);
