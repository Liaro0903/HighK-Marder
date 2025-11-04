// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: A Current (K+)
// component source [Liu et al. 98](http://www.jneurosci.org/content/jneuro/18/7/2309.full.pdf)
//
#pragma once
class conductance;

//inherit conductance class spec
class ACurrent: public conductance {

public:

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
        if (isnan(ac_shift_m)) { ac_shift_m = 0.0; }
        if (isnan(ac_shift_h)) { ac_shift_h = 0.0; }

        AllowMInfApproximation = false;
        AllowHInfApproximation = false;
    }


    double m_inf(double, double);
    double h_inf(double, double);
    double tau_m(double, double);
    double tau_h(double, double);

};



double ACurrent::m_inf(double V, double Ca) {return 1.0/(1.0+exp((V+27.2+ac_shift_m)/-8.7)); }
double ACurrent::h_inf(double V, double Ca) {return 1.0/(1.0+exp((V+56.9+ac_shift_h)/4.9)); }
double ACurrent::tau_m(double V, double Ca) {return 11.6 - 10.4/(1.0+exp((V+32.9)/-15.2));}
double ACurrent::tau_h(double V, double Ca) {return 38.6 - 29.2/(1.0+exp((V+38.9)/-26.5));}


