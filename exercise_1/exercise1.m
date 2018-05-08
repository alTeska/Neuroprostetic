)

function [F, T, D] = signal(f, A, t, sr, A0)
    T = 0:t:t/(1/sr)
    F = A0;
    D = [];
    for i=0:len(A)
        D(i) = A(i) * np.sin(2 * np.pi * f(i) * T)
        F = F + A(i) * np.sin(2 * np.pi * f(i) * T)
    end
end



f = [100, 600, 9000];
A = [1, 1.5, 2];
t = 0.1;
A0 = 3;
sr = 100000;

signal(f, A, t, sr, A0)
