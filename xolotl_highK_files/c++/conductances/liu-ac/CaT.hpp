// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: Transient Ca current
// component source [Liu et al. 98](http://www.jneurosci.org/content/jneuro/18/7/2309.full.pdf)
//
#pragma once
class conductance;

//inherit conductance class spec
class CaT: public conductance {

public:

    // specify parameters + initial conditions
    CaT(double gbar_, double E_, double m_, double h_, double ac_shift_m_, double ac_shift_h_)
    {
        gbar = gbar_;
        E = E_;
        m = m_;
        h = h_;

        // defaults
        if (isnan (E)) { E = 30; }

        p = 3;
        q = 1;

        is_calcium = true;
        name = "CaT";

        perm.Ca = 1;

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


double CaT::m_inf(double V, double Ca) {return 1.0/(1.0 + exp((V+27.1+ac_shift_m)/-7.2));}
double CaT::h_inf(double V, double Ca) {return 1.0/(1.0 + exp((V+32.1+ac_shift_h)/5.5));}
double CaT::tau_m(double V, double Ca) {return 21.7 - 21.3/(1.0 + exp((V+68.1)/-20.5));}
double CaT::tau_h(double V, double Ca) {return 105.0 - 89.8/(1.0 + exp((V+55.0)/-16.9));}


