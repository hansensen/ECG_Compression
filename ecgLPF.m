a = fir1(100,[0.588,0.9],'stop');
y2 = filter(a,1,lead1);
subplot(3,1,1);
subplot(3,1,2);
plot(lead1);
subplot(3,1,3);
plot(y2);
%freqz(a,1,512);
freqz(y2);

Y = fft(lead1);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')