"""
General Numerical Solver for the 1D Time-Dependent Schrodinger's equation.

adapted from code at http://matplotlib.sourceforge.net/examples/animation/double_pendulum_animated.py

Double pendulum formula translated from the C code at
http://www.physics.usyd.edu.au/~wheat/dpend_html/solve_dpend.c

author: Jake Vanderplas
email: vanderplas@astro.washington.edu
website: http://jakevdp.github.com
license: BSD
Please feel free to use and modify this, but keep the above information. Thanks!
"""

from numpy import sin, cos
import numpy as np
from scipy.linalg import solve 
import matplotlib.pyplot as plt
import scipy.integrate as integrate
import matplotlib.animation as animation
from matplotlib.patches import Rectangle

class Crane:
    """Cart and pole

    init_state is [z, theta, zdot, thetadot]
    where z is the horizontal position of the cart and theta is the angle of the 
    pendulum.  theta=0 means hanging down.
    """
    def __init__(self,
                 init_state = [0, 0.1, 0, 0],
                 l=40,   # length of pendulum in m
                 M=1e3,  # mass of cart in kg
                 m=1e4,  # mass of pendulum in kg
                 g=9.8  # acceleration due to gravity, in m/s^2)
                 ) :
        self.init_state = np.asarray(init_state, dtype='double')
        self.params = (l, M, m, g)
        self.time_elapsed = 0
        self.state = self.init_state.copy()
        self.M = np.zeros((2,2))
        self.M[0,0] = M+m
        self.M[1,1] = m*(l**2)
        
        #self.controller = CartPole.constant(0.0)
        
    def pendulum_position(self):
        """compute the current x,y position of the pendulum"""
        (l, M, m, g) = self.params 
        z = self.state[0]
        th = self.state[1]
        x  = np.zeros(2)
        y = np.zeros(2)
        x[0] = z
        x[1] = z - l*np.sin(th)
        y[1] = -l*np.cos(th)
        return (x, y)

    def energy(self):
        """compute the energy of the current state"""
        (l, M, m, g) = self.params 

        th = self.state[1]
        zdot = self.state[2]
        thdot = self.state[3]
        
        # Kinetic energy of the cart
        Ekcart = 0.5*M*zdot**2

        # Kinetic energy of the pendulum
        hdot = zdot -l*thdot*np.cos(th)
        vdot = l*thdot*np.sin(th)
        
        Ekpend = 0.5*m*(hdot**2 + vdot**2)

        # Potential energy of the pendulum
        Ep = -m*g*l*np.cos(th)

        return Ekcart + Ekpend + Ep

    #def dstate_dt(self, state, t):
    def dstate_dt(self, state, t):
        """compute the derivative of the given state"""
        u = 0.0
        if u is None:
            u = self.controller(state)
            
        (l, M, m, g) = self.params 
        #ml2 = m*l**2
        ml2 = m*l**2
        
        th = self.state[1]
        thdot = self.state[3]
        thdot2 = thdot**2
        
        cth = np.cos(th)
        sth = np.sin(th)
        Mt = M+m
        Jt = m*l**2
        dxdt = np.zeros_like(state)

        dxdt[0] = state[2]
        dxdt[1] = state[3]

        # Using sympy Lagrangian Mechanics
        dnm = M+m*sth**2
        dxdt[2] = -(m*sth)/dnm * (g*cth + l*thdot**2 - u)
        dxdt[3] = -sth/(l*dnm) * (g*Mt + l*m*cth*thdot**2 )
        

        #G = np.array([-m*l*sth*thdot**2+u, -m*g*l*sth])
        #self.M[0,1] = -m*l*cth
        #self.M[1,0] = -m*l*cth
        #dxdt[2:4] = solve(self.M, G)

        

        ## From Astrom 6 Wittenmark
        #G = np.array([-m*l*sth*thdot**2+u, -m*g*l*sth])
        #self.M[0,1] = -m*l*cth
        #self.M[1,0] = -m*l*cth
        #dxdt[2:4] = solve(self.M, G)
        
        #dxdt[2] = (-0.5*m*g*np.sin(2*th) - l*m*thdot**2*sth +u)/dnm
        #dxdt[3] = (-g*Mt*sth - l*m*thdot**2*sth*cth + cth*u)/(l*dnm)
        #dxdt[2] = (-m*l*sth*thdot2 + m*g*(ml2/Jt)*sth*cth + u)/(Mt-m*(ml2/Jt)*cth**2)
        #dxdt[3] = (-ml2*sth*cth*thdot2 - Mt*g*l*sth + l*cth*u)/(Jt*(Mt/m)-ml2*cth**2)
                                                                   
        return dxdt

    def step(self, dt):
        """execute one time step of length dt and update state"""
        self.state = integrate.odeint(self.dstate_dt, self.state, [0, dt])[1]
        #self.state = integrate.odeint(self.dstate_dt, self.state, [0, dt], hmax=dt/1000)[1]
        #self.state = integrate.solve_ivp(self.dstate_dt, [0, dt], self.state,)[1]
        self.time_elapsed += dt

def run_sim(state=[0, np.pi/12, 0, 0], M=1e3, m=1e4, l=40, g=9.8) :
    global crane, dt
    #------------------------------------------------------------
    # set up initial state and global variables
    crane = Crane(init_state=state, M=M, m=m, l=l, g=g)
    dt = 1./30 # 30 fps

    #------------------------------------------------------------
    # set up figure and animation
    fig = plt.figure()
    ax = fig.add_subplot(111, aspect='equal', autoscale_on=False,
                         xlim=(-60, 60), ylim=(-50, 10))
    ax.grid()

    cartwidth = 4
    cartheight = 1.5
    rect = Rectangle((0-cartwidth/2, 0), width=cartwidth, height=cartheight)

    ax.add_patch(rect)
    line, = ax.plot([], [], 'o-', lw=2)
    time_text = ax.text(0.02, 0.95, '', transform=ax.transAxes)
    energy_text = ax.text(0.02, 0.90, '', transform=ax.transAxes)

    def init():
        """initialize animation"""
        line.set_data([], [])
        time_text.set_text('')
        energy_text.set_text('')
        return line, time_text, energy_text

    def animate(i):
        """perform animation step"""
        global crane, dt
        crane.step(dt)

        (x,y) = crane.pendulum_position()
        rect.set_x(x[0]-2)
        line.set_data(x,y)
        time_text.set_text('time = %.1f' % crane.time_elapsed)
        energy_text.set_text('energy = %.3f J' % crane.energy())
        return line, time_text, energy_text,rect
    
    # choose the interval based on dt and the time to animate one step
    from time import time
    t0 = time()
    animate(0)
    t1 = time()
    interval = 1000 * dt - (t1 - t0)

    ani = animation.FuncAnimation(fig, animate, frames=300,
                                  interval=interval, blit=True, init_func=init)

    # save the animation as an mp4.  This requires ffmpeg or mencoder to be
    # installed.  The extra_args ensure that the x264 codec is used, so that
    # the video can be embedded in html5.  You may need to adjust this for
    # your system: for more information, see
    # http://matplotlib.sourceforge.net/api/animation_api.html
    #ani.save('double_pendulum.mp4', fps=30, extra_args=['-vcodec', 'libx264'])
    
    plt.show()


