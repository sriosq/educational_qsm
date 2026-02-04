function RDF= my_sharp(total_field, msk, matrix_size, voxel_size, radius, threshold)

if (nargin<6)
    threshold=0.00;
end
if (nargin<5)
    radius=round(6/max(voxel_size)) * max(voxel_size);
end

%eroding the mask not necessary (assumption by S.R. based on only SC
%images)
%Mask = my_SMV(msk, matrix_size,voxel_size,radius)>0.9999999; 
msk = double(msk);
% generate the convolution/deconvolution kernel
kernel = SMV_kernel(matrix_size, voxel_size, radius);
niftiwrite(kernel, "step1_kernel.nii.gz")

% subtraction of the spherical mean value
iFreq = ifftn(fftn(total_field).*kernel); % iFreq in img domain
niftiwrite(iFreq, "step2_apply_SMV_kernel.nii.gz")

% mask out the ROI - outside the SC mask
iFreq_maskd = iFreq.*msk;
niftiwrite(iFreq_maskd, "step3_masking.nii.gz")

% deconvolution in k-space
kRDF = fftn(iFreq_maskd)./kernel;
niftiwrite(kRDF, "step4_divide_w_kernel.nii.gz")
% truncation in k-space
kRDF(abs(kernel)<=threshold) = 0;
kRDF(isnan(kRDF)) = 0;
kRDF(isinf(kRDF)) = 0;
% results in image space
RDF = ifftn(kRDF).*msk;
niftiwrite(RDF,"step5_final_LF.nii.gz")
disp("Finished running custom version of sharp for SC ROI")