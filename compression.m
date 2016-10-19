%   ECG CCOMPRESSION    
%          1. Linear Predictive Coding
%          2. Coding-packing Scheme
%          ***********************************************************
%        3 * A * 1 *   5/4 bits     *   5/4 bits    *    5/4 bits    *
%          ***********************************************************
%        4 * B * 0 1 *      7/6 bits         *      7/6 bits         *
%          ***********************************************************
%        2 * C * 0 0 0 1 *  3 bits  *  3 bits  *  3 bits  *  3 bits  *
%          ***********************************************************
%        1 * D * 0 0 0 0 *2 bits *2 bits *2 bits*2 bits*2 bits*2 bits*
%          ***********************************************************
%        5 * E * 0 0 1 1 *              12 bits                      *
%          ***********************************************************
%
%   Clear our variables
clear
warning off
%   Load data sample
plotname = 'Lead 1';
load ecg.mat;
lead1 = ecgdata(1:4500,2);
size = length(lead1);
%size = 2000;
a = fir1(100,[0.588,0.7058],'stop');
%lead1 = filter(a,1,lead1);

lead11(1) = lead1(1);
lead11(2) = lead1(2);
for i = 3:1:size
    %lead11(i) = lead1(i) - 2 * lead1(i-1) + lead1(i-2);
    lead11(i) = lead1(i) - lead1(i-1);
end

subplot(2, 1, 1); plot(lead1);
title('\bf1. Original ECG'); ylim([-300 300]);
subplot(2, 1, 2); plot(lead11);
title('\bf2. Linear Predictive ECG'); ylim([-100 100]);

csvwrite('Predicted_ECG.csv',lead11);

k = 0;
m = 0;
i = 1;
ecgout(:) = 0;

while (i<=(size-5))
    ecgo = 0;
    %Frame D
    if ((max(lead11(i:(i+5)))>=-2) && (max(lead11(i:(i+5)))<=1))
        for j=i:1:(i+5)
            ecgo = bitset(ecgo,(j-i)*2+1,bitget(bin2dec(dec2twos(lead11(j))),1));
            ecgo = bitset(ecgo,(j-i)*2+2,bitget(bin2dec(dec2twos(lead11(j))),2));
        end
        ecgo = bitand(ecgo,4095);
        i = i + 6;
        
    %Frame C
    else if ((max(lead11(i:(i+3)))>=-4) && (max(lead11(i:(i+3)))<=3))
        for j=i:1:(i+3)
            ecgo = bitset(ecgo,(j-i)*3+1,bitget(bin2dec(dec2twos(lead11(j))),1));
            ecgo = bitset(ecgo,(j-i)*3+2,bitget(bin2dec(dec2twos(lead11(j))),2));
            ecgo = bitset(ecgo,(j-i)*3+3,bitget(bin2dec(dec2twos(lead11(j))),3));
        end
        ecgo = bitand(ecgo,4095);
        ecgo = bitset(ecgo,13,1);
        i = i + 4;

    %Frame A
    else if ((max(lead11(i:(i+2)))>=-16) && (max(lead11(i:(i+2)))<=15))
        %do something
        for j=i:1:(i+2)
            ecgo = bitxor(ecgo,bitshift(bin2dec(dec2twos(lead11(j))),(j-i)*5));
        end
        ecgo = bitset(ecgo,16,1);
        i = i + 3;
        
    %Frame B
    else if ((max(lead11(i:(i+1)))>=-64) && (max(lead11(i:(i+1)))<=63)) 
        %do something
        for j=i:1:(i+1)
            ecgo = bitxor(ecgo,bitshift(bin2dec(dec2twos(lead11(j))),(j-i)*7));
        end
        ecgo = bitset(ecgo,16,0);
        ecgo = bitset(ecgo,15,1);
        i = i + 2;
        
    %Frame E
        else
        ecgo = bin2dec(dec2twos(lead11(j)));
        ecgo = bitset(ecgo,16,0);
        ecgo = bitset(ecgo,15,0);
        ecgo = bitset(ecgo,14,1);
        ecgo = bitset(ecgo,13,1);     
        i = i + 1;
        end
        end
        end
    end
    m = m+1;
    ecgout(m,1) = ecgo;
end

csvwrite('Compressed_ECG.csv',ecgout);