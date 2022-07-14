// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: A Current (K+)
// component source [Prinz et al. 2003](http://jn.physiology.org/content/jn/90/6/3998.full.pdf)
//
#ifndef ACURRENT
#define ACURRENT

//inherit conductance class spec
class ACurrent: public conductance {

public:
    double ac_shift_m = 0.0;
    double ac_shift_h = 0.0;

    // specify parameters + initial conditions
    ACurrent(double gbar_, double E_, double m_, double h_, double ac_shift_m_, double ac_shift_h_)
    {
        gbar = gbar_;
        E = E_;
        m = m_;
        h = h_;

        // defaults 
        if (isnan (E)) { E = -80; }

        p = 3;
        q = 1;

        name = "ACurrent";


        perm.K = 1;

        ac_shift_m = ac_shift_m_;
        ac_shift_h = ac_shift_h_;
    }

    double m_inf(double V, double Ca) {return 1.0/(1.0+exp((V+27.2+ac_shift_m)/-8.7)); }
    double h_inf(double V, double Ca) {return 1.0/(1.0+exp((V+56.9+ac_shift_h)/4.9)); }
    double tau_m(double V, double Ca) {return 23.2 - 20.8/(1.0+exp((V+32.9)/-15.2));}
    double tau_h(double V, double Ca) {return 77.2 - 58.4/(1.0+exp((V+38.9)/-26.5));}
};



// double ACurrent::m_inf(double V, double Ca) {return 1.0/(1.0+exp((V+27.2)/-8.7)); }
// double ACurrent::m_inf(double V, double Ca) {return 1.0/(1.0+exp((V+27.2+2.7)/-8.7)); }
// double ACurrent::h_inf(double V, double Ca) {return 1.0/(1.0+exp((V+56.9)/4.9)); }
// double ACurrent::h_inf(double V, double Ca) {return 1.0/(1.0+exp((V+56.9-1)/4.9)); }
// double ACurrent::tau_m(double V, double Ca) {return 23.2 - 20.8/(1.0+exp((V+32.9)/-15.2));}
// double ACurrent::tau_m(double V, double Ca) {return 23.2 - 20.8/(1.0+exp((V+32.9+4.3)/-15.2));}
// double ACurrent::tau_h(double V, double Ca) {return 77.2 - 58.4/(1.0+exp((V+38.9)/-26.5));}
// double ACurrent::tau_h(double V, double Ca) {return 77.2 - 58.4/(1.0+exp((V+38.9-4.3)/-26.5));}

#endif
