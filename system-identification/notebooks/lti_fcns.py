import numpy as np
import control
import matplotlib.pyplot as plt

def predict_lti(b, a, y, u, k=1, d=0):
    """
    Returns the k-step ahead prediction for the LTI with pulse-transfer function
       H(z) = B(z)/A(z)
    The coefficients of the numerator polynomial is contained in the array b, and those of
    the denominator polynomial in the array a.

    Input
       b  ->  numerator coefficients (1 x m) row vector
       a  ->  denominator coefficients (1 x n) row vector
       u  ->  input data (N x 1) column vector 
       y  ->  output data (N x 1) column vector 
       k  ->  prediction horizon (integer > 0)
       d  ->  input delay (integer >= 0)

    Output
       ypredk  <-  predicted output ((N-k) x 1) column vector
       tk      <-  for convenience, discrete time vector for predicted values 
                   tk = [1+k, 2+k, ..., N]

    """

    # Kjartan Halvorsen
    # 2019-10-03


    # Adjust coefficient arrays in case of input delay 
    aa = np.concatenate( (a, np.zeros(d)), axis=None)
    bb = np.concatenate( (np.zeros(len(aa)-len(b)), b), axis=None)


    n = len(aa) - 1 # System order
    N = len(u)      # Length of data

    print("Order n=%d" %n)
    print("Data points N=%d" %N)
    
    yy = np.concatenate( (np.zeros(n), y), axis=None ) # Prepad with initial values
    uu = np.concatenate( (np.zeros(n), u), axis=None )  # Prepad with initial values

    tk = np.arange(k, N)

    ypredk = np.zeros(len(tk))
    for i in range(N-k):
        ysim = yy[i:i+n+k+1] # First n are initial values, last k will be overwritten 
        usim = uu[i:i+n+k+1] 
        for l in range(k):
            ysim[n+l+1] = - np.dot(aa[1:], ysim[n+l:l:-1])
            ysim[n+l+1] += np.dot(bb, usim[n+l+1:l:-1])
        ypredk[i] = ysim[-1]

    return (ypredk, tk)

def predict_unit_test():
    # Generate some data and test method
    b = np.array([0, 0, 1,0.9])
    a = np.array([1, -np.sqrt(3), 1, 0])
    
    N = 50
    u = np.random.randn(N)
    t = np.arange(N)
    (t, y, x) = control.forced_response( control.tf(b,a,1.0), t, u)
    y = np.ravel(y)
    
    k = 10;
    (ypred, tpred) = predict_lti(b[2:], a[:-1], y,  u, k, 1);
    
    plt.figure
    plt.plot(tpred, ypred, 'rx')
    plt.plot(t, y, 'bo')

    return (ypred, tpred)
