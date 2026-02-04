function gx = my_grad(iMag, voxel_size)

Dx = [iMag(2:end,:,:); iMag(end,:,:)] - iMag;
Dy = [iMag(:,2:end,:), iMag(:,end,:)] - iMag;
Dz = cat(3, iMag(:,:,2:end), iMag(:,:,end)) - iMag;

Dx = Dx/voxel_size(1);
Dy = Dy/voxel_size(2);
Dz = Dz/voxel_size(3);

gx = cat(4, Dx, Dy, Dz);

end