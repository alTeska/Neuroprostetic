function [newFilter, f_r, Q] = own_filter(f_go, f_gu, N, f_s)
% [newFilter, f_r, Q] = own_filter(f_go, f_gu, N, f_s)
%
% Funktion zur Erstellung eines Bandpassfilters
%
% Inputs:
% f_go          obere Grenzfrequenz in Hz
% f_gu          untere Grenzfrequenz in Hz
% N             geforderte Ordnung
% f_s           Abtastfrequenz in Hz
%
% Outputs:
% newFilter     neu erstellter Filter
% f_r           Resonanzfrequenz bzw. Mittenfrequenz
% Q             G�te der Teilbandp�sse
%
% Wichtig:
% Die Funktion ist ausschlie�lich mit geraden und positiven Ordnungen zu verwenden!




% Sicherstellung von gerader und positiver Ordnung. Korrektur, falls dies nicht der Fall!
N = abs(N);
if N==0
    N = 2;
elseif mod(N,2)~=0
    N = N+1;
end

% Ausrechnen der Resonanzfrequenz durch geometrisches Mittel aus oberer und unterer Grenzfrequenz
f_r = sqrt(f_go*f_gu);
w_r = 2*pi*f_r;
% Berechnung der Bandbreite des Filters
B = f_go - f_gu;
% Berechnung der G�te, Korrekturfaktor von 0.5 vorhanden. Zusammenh�nge siehe PDF-Datei
Q = f_r/B/2;
A_r = 1;
% Erstellung eines Modells einer zeitkontinuierlichen �bertragungsfunktion
% Hintergrund der Formel siehe PDF-Datei
transferFunc_BP = tf([(A_r/Q)/w_r 0], [1/(w_r^2) (1/Q)/w_r 1]);

% Bilineare Transformation des zeitkontinuierlichen Modells, damit zeitlich diskretisiert.
% Angabe von Resonanzfrequenz bewirkt zus�tzliches Prewarping --> stabilere & genauere Resultate!
[num, den] = bilinear(transferFunc_BP.Numerator{1}, transferFunc_BP.Denominator{1}, f_s, f_r);
% Umwandlung der �bertragungsfunktion in Zustandsraumdarstellung um numerische Fehler
% bei h�heren Ordnungen zu vermindern. Zustandsraumdarstellung sehr viel toleranter!
[A,B,C,D] = tf2ss(num,den);
% Erstellung von Zustandsraummodell und Hintereinanderschaltung von Teilbandp�ssen
sys = ss(A,B,C,D)^(N/2);
% Optimierungsfunktionen f�r mehr Genauigkeit und f�r ein Ausbessern m�glicher aufgetretener Fehler
sys = minreal(sys);
sys = balreal(sys);
% Erstellung eines zeitdiskreten Zustandsraumfilters
newFilter = dfilt.statespace(sys.A,sys.B,sys.C,sys.D);

endow
