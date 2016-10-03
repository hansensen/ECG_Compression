%   ECG CCOMPRESSION    
%          1. Linear Predictive Coding
%          2. Coding-packing Scheme
%          ***********************************************************
%          * A * 1 *   5/4 bits     *   5/4 bits    *    5/4 bits    *
%          ***********************************************************
%          * B * 0 1 *      7/6 bits         *      7/6 bits         *
%          ***********************************************************
%          * C * 0 0 0 1 *  3 bits  *  3 bits  *  3 bits  *  3 bits  *
%          ***********************************************************
%          * D * 0 0 0 0 *2 bits *2 bits *2 bits*2 bits*2 bits*2 bits*
%          ***********************************************************
%          * E * 0 0 1 1 *              12 bits                      *
%          ***********************************************************
%
%   Clear our variables
clear
%   Load data sample
plotname = 'Lead 1';
load ecg.mat;
lead1 = ecgdata(:,2);
%size = length(lead1);
size = 1000;

lead11(1) = lead1(1);
lead11(2) = lead1(2);
for i = 3:1:size
    lead11(i) = lead1(i) - 2 * lead1(i-1) + lead1(i-2);
end

subplot(2, 1, 1); plot(lead1);
title('\bf1. Original ECG'); ylim([-300 300]);
subplot(2, 1, 2); plot(lead11);
title('\bf2. Linear Predictive ECG'); ylim([-50 50]);

for i = 1:6:size
    if (size < i+6)
        endpoint = size;
    else
        endpoint = i + 6;
    end
    %max = 0;

    %for j = i:1:endpoint
    %    if (abs(lead11(j))>max)
    %        max = abs(lead11);
    %    end
    %end
    maxi = max(lead11(i:endpoint));

    
    frameFormat = 5;
    if ((maxi>=-2) & (maxi<=1))
        frameFormat = 1;
    else if ((maxi>=-4) & (maxi<=3))
        frameFormat = 2;
    else if ((maxi>=-8) & (maxi<=7)) 
        frameFormat = 3;
    else if ((maxi>=-16) & (maxi<=15))
        frameFormat = 4;
    else if ((maxi>=-64) & (maxi<=63)) 
        frameFormat = 5;
        end
        end
        end
        end
    end
    %Data Packing
    disp(frameFormat);
end
