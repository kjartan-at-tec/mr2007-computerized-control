import numpy as np

def juryrec(a,tab):
    n = len(a)
    if n==1:
        tab.append(a)
    else:
        line1 = a
        line2 = line1[::-1]
        tab.append(line1)
        tab.append(line2)
        alpha = line1[-1]/line2[-1]
        aa = [el1 - alpha*el2 for (el1,el2) in itertools.izip(line1,line2)]
        juryrec(aa[:-1],tab)


def nyq(H, N=400):
    z = np.zeros(N)
    ws = np.linspace(0, np.pi, N)
    for i in range(N):
        z[i] = H(np.exp(1j*ws[i]))
    return (np.real(z), np.imag(z))

        