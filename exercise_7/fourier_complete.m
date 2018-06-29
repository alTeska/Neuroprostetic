function [single_fourier, f] = fourier_complete(timeSignal, t_signalMax, f_s)
% [single_fourier, f] = fourier_complete(timeSignal, t_signalMax, f_s)
%
% Funktion zur Berechnung einer einseitigen Fouriertransformation
%
% Inputs:
% timeSignal        Zeitsignal
% t_signalMax       Dauer des Zeitsignals
% f_s               Abtastfrequenz
%
% Outputs:
% single_fourier    einseitige Fouriertransformierte
% f                 Frequenzvektor




N_fft = t_signalMax*f_s;

% Unterscheidung f�r gerade & ungerade N
if mod(N_fft,2)~=0
    N_fft_half = (N_fft+1)/2;       % Ungerader Fall
else
    N_fft_half = N_fft/2+1;         % Gerader Fall
end

f = f_s/N_fft * (0:N_fft_half-1);   % Erstellung des Frequenzvektors

% Fouriertransformation (2 f�r zeilenweise berechnen), Normierung, Betrag
single_fourier = abs(fft(timeSignal,[],2)/N_fft);
% Abschneiden bei der "H�lfte" --> einseitig
single_fourier = single_fourier(1:N_fft_half);
% Her�berklappen f�r vollst�ndige einseitige Transformation: Verdopplung
% aller Werte au�er DC und fs/2
single_fourier(2:end-1) = 2*single_fourier(2:end-1);

end 
