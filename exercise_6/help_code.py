import matplotlib.pyplot as plt
import scipy.io.wavfile as wavfile
import numpy as np
import scipy.signal as signal

rate, sound = wavfile.read('path_to_file.wav')
time = np.arange(0, len(sound)) * 1. / rate

# Greenwood Parameters (1990)
ear_q = 7.23824
min_bw = 22.8509
order = 1


#Basic Parameters
lo_freq = 100 #Highest filter frequency in Hz
hi_freq = 5e3 #Lowest filter frequency in Hz
num_channels = 22 #Number of Channels / Filter

#calculate cf and erb
erb_lo = ((lo_freq / ear_q)**order + min_bw**order) ** (1. / order)
erb_hi = ((hi_freq / ear_q)**order + min_bw**order) ** (1. / order)
overlap = (erb_hi / erb_lo)**(1. / (num_channels - 1))

erbs = erb_lo * (overlap**(np.arange(num_channels)))
cfs = ear_q * (((erbs**order) - (min_bw**order))**(1. / order))

nyq = float(rate) / 2

low_cf = ... #lower cutoff frquency normed so that nyquist freq = 1
high_cf = ... #higher cutoff frquency normed so that nyquist freq = 1
ba  = signal.butter(N=2,
                    Wn=[low_cf, high_cf],
                    btype='bandpass')
filtered_sound = signal.lfilter(ba[0], ba[1], sound)


fig = plt.figure()
ax = fig.add_subplot(1,1,1)
amp = filtered_sound[:, i] / 255
ax.plot(time, amp)
ax.set_ylim(-0.5, 0.5)



#Plot the frequency Response in Hz and dB
fig = plt.figure()
ax = fig.add_subplot(111)
for filt in filter_list:
    w, h = signal.freqz(filt[0], filt[1], worN=2048)
    freqs = w / np.pi * nyq
    amps = 20 * np.log10(np.abs(h))
    ax.semilogx(freqs , amps)
    ax.set_xlim( 50, hi_freq * 2)
    ax.set_ylim( -70, 0)
    fig.show()

# Plot the specgram
fig = plt.figure()
ax = fig.add_subplot(111)
ax.specgram(sound)
fig.show()
