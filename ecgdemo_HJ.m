%   ECGDEMO    ECG PROCESSING DEMONSTRATION - R-PEAKS DETECTION
%              
%              This file is a part of a package that contains 5 files:
%
%                     1. ecgdemo.m - (this file) main script file;
%                     2. ecgdemowinmax.m - window filter script file;
%                     3. ecgdemodata1.mat - first ecg data sample;
%                     4. ecgdemodata2.mat - second ecg data sample;
%                     5. readme.txt - description.
%
%              The package downloaded from http://www.librow.com
%              To contact the author of the sample write to Sergey Chernenko:
%              S.Chernenko@librow.com
%
%              To run the demo put
%
%                     ecgdemo.m;
%                     ecgdemowinmax.m;
%                     ecgdemodata1.mat;
%                     ecgdemodata2.mat
%
%              in MatLab's "work" directory, run MatLab and type in
%
%                     >> ecgdemo
%
%              The code is property of LIBROW
%              You can use it on your own
%              When utilizing credit LIBROW site

%   We are processing two data samples to demonstrate two different situations
    %   Clear our variables
    clear ecg samplingrate corrected filtered1 peaks1 filtered2 peaks2 fresult
    %   Load data sample
    plotname = 'Sample 1';
    demo = 1;

    %load Predicted_ECG.csv;
    samplingrate = 85;

    ecg = lead11(1,:);
    corrected = ecg;

    %   Filter 
    WinSize = floor(samplingrate * 571 / 1000);
    if rem(WinSize,2)==0
        WinSize = WinSize+1;
    end
    filtered1=ecgdemowinmax(corrected, WinSize);
    
    %   Scale ecg
    peaks1=filtered1/(max(filtered1)/7);
    %   Filter by threshold filter
    
    for data = 1:1:length(peaks1)
        if peaks1(data) < 4.3
            peaks1(data) = 0;
        else
            peaks1(data)=1;
        end
    end
    
    
    %   Create figure - stages of processing
    figure(demo); set(demo, 'Name', strcat(plotname, ' - Processing Stages'));
    %   Original input ECG data
    subplot(3, 1, 1); plot((ecg-min(ecg))/(max(ecg)-min(ecg)));
    title('\bf1. Compressed ECG Signal'); ylim([-0.2 1.2]);

    %   Filtered ECG (1-st pass) - filter has default window size
    subplot(3, 1, 2); stem((filtered1-min(filtered1))/(max(filtered1)-min(filtered1)));
    title('\bf3. Filtered ECG'); ylim([0 1.4]);
    %   Detected peaks in filtered ECG
    subplot(3, 1, 3); stem(peaks1);
    title('\bf4. Detected Peaks'); ylim([0 1.4]);