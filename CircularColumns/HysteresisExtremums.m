function [Extremums] = HysteresisExtremums(numfiles, DispForce)

    VultMax  = zeros(numfiles,1); % Ultimate shear force at positive side
    dVultMax = zeros(numfiles,1); % Displacement at the ult shear force at positive side

    VultMin  = zeros(numfiles,1); % Ultimate shear force at negative side
    dVultMin = zeros(numfiles,1); % Displacement at the ult shear force at negative side
    
    Vmax  = zeros(numfiles,1);    % Maximum shear force at positive side
    dVmax = zeros(numfiles,1);    % Displacement at the max shear force at positive side

    Vmin  = zeros(numfiles,1);    % Maximum shear force at negative side
    dVmin = zeros(numfiles,1);    % Displacement at the max shear force at negative side

    absVmax  = zeros(numfiles,1); % Governing maximum shear force
    absDVmax = zeros(numfiles,1); % Displacement corresponding to governing maximum shear force

    for k=1:numfiles

        [dVultMax(k),locDMaxPos]= max(DispForce{k}(:,1));
        VultMax(k) = DispForce{k}(locDMaxPos,2);

        [dVultMin(k),locDMinNeg]= min(DispForce{k}(:,1));
        VultMin(k) = DispForce{k}(locDMinNeg,2);
    
        [Vmax(k),locMaxPos]= max(DispForce{k}(:,2));
        dVmax(k) = DispForce{k}(locMaxPos,1);

        [Vmin(k),locMinNeg]= min(DispForce{k}(:,2));
        dVmin(k) = DispForce{k}(locMinNeg,1);

        if VultMax(k)>-VultMin(k)
            absVmax(k) = VultMax(k);
            absDVmax(k) = dVultMax(k);
        else
            absVmax(k) = -VultMin(k);
            absDVmax(k)= -dVultMin(k);
        end          

        if Vmax(k)>-Vmin(k)
            absVmax(k) = Vmax(k);
            absDVmax(k) = dVmax(k);
        else
            absVmax(k) = -Vmin(k);
            absDVmax(k)= -dVmin(k);
        end          
        
        % Prevent non-physical outcomes
        for k=1:numfiles
            if dVultMax(k)<0
                dVultMax(k) = 0;
            end

            if dVultMin(k)>0
                dVultMin(k) = 0;
            end

            if VultMax(k)<0
                VultMax(k) = 0;
            end

            if VultMin(k)>0
                VultMin(k) = 0;
            end
        end

        Extremums = [VultMax, dVultMax, VultMin, dVultMin, Vmax, dVmax, ...
            Vmin, dVmin, absVmax, absDVmax];
        
    end
end