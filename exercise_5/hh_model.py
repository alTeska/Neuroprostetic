def hh_model_exp_multi(num, temp, T, dt, I_stim):
    l = int(T/dt)
    M = np.zeros((num,l))
    N = np.zeros((num,l))
    H = np.zeros((num,l))
    U = np.zeros((num,l))

    M[:,0] = np.ones(num) * m_ss(0)
    N[:,0] = np.ones(num) * n_ss(0)
    H[:,0] = np.ones(num) * h_ss(0)
    k = temp_corr(temp)

    for t in range(0, len(I)-1):
        u = U[:][t]
        A_m = -1 * k * (alpha_m(u) + beta_m(u))
        A_n = -1 * k * (alpha_n(u) + beta_n(u))
        A_h = -1 * k * (alpha_h(u) + beta_h(u))
        B_m = k * alpha_m(u)
        B_n = k * alpha_n(u)
        B_h = k * alpha_h(u)

        M[:][t+1] = M[:][t] * np.exp(A_m * dt) + B_m/A_m * (np.exp(A_m * dt)-1)
        N[:][t+1] = N[:][t] * np.exp(A_n * dt) + B_n/A_n * (np.exp(A_n * dt)-1)
        H[:][t+1] = H[:][t] * np.exp(A_h * dt) + B_h/A_h * (np.exp(A_h * dt)-1)

        I_ion = hh_current(M[:][t+1], N[:][t+1], H[t+1], u)
        
        U[:][t+1] = U[:][t] - 1/C_m * (I_ion - I_stim[:][t]) * dt + 1/(C_m * Ra) * C * U[:][t] * dt

return U
