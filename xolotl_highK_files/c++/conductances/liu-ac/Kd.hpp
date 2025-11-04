// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: inward rectifying Potassium current
// component source [Liu et al. 98](http://www.jneurosci.org/content/jneuro/18/7/2309.full.pdf)
//
#pragma once
class conductance;

//inherit conductance class spec
class Kd: public conductance {

public:

    //specify both gbar and E_rev and initial conditions
    Kd(double gbar_, double E_, double m_, double ac_shift_m_)
    {
        gbar = gbar_;
        E = E_;
        m = m_;

        // defaults 
        if (isnan (E)) { E = -80; }
        ac_shift_m = ac_shift_m_;
        if (isnan(ac_shift_m)) { ac_shift_m = 0.0; }

        p = 4;

        name = "Kd";

        perm.K = 1;

        AllowMInfApproximation = false;
        AllowHInfApproximation = false;
    }

    double m_inf(double, double);
    double tau_m(double, double);

};



double Kd::m_inf(double V, double Ca) {return 1.0/(1.0+exp((V+12.3+ac_shift_m)/-11.8));}
double Kd::tau_m(double V, double Ca) {return 7.2 - 6.4/(1.0+exp((V+28.3)/-19.2));}


