function wG = my_gradmask(iMag, msk, vox_size, percent)
    if percent > 1
        disp("Percent is divided by 100 assuming input comes from 0-100")
        percent = percent/100;
    end

    mskd_mag = iMag.*(msk);
    field_noise_level = 0.01*max(iMag(:));
    disp("Field noise level:")
    disp(field_noise_level)
    disp("#########");
    wG = abs(my_grad(mskd_mag, vox_size));

    denominator = sum(msk(:)==1);

    disp("Denominator:");
    disp(denominator);
    numerator = sum(wG(:)>field_noise_level);
    disp("Numerator:");
    disp(numerator);
    disp("#########");
    disp("Flag:");
    disp(numerator/denominator)
    disp("Begin!");
    if  (numerator/denominator)>percent
        while (numerator/denominator)>percent
            %disp("Increase noise level");
            field_noise_level = field_noise_level*1.05;
            numerator = sum(wG(:)>field_noise_level);
        end
    else
        while (numerator/denominator)<percent
            %disp("Decrease noise level");
            field_noise_level = field_noise_level*.95;
            numerator = sum(wG(:)>field_noise_level);
        end
    end

wG = (wG<=field_noise_level);

