// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: Sodium conductance
// component source [Prinz et al. 2003](http://jn.physiology.org/content/jn/90/6/3998.full.pdf)
//
#ifndef NAV
#define NAV

//inherit conductance class spec
class NaV: public conductance {

public:
    double ac_shift_m = 0.0;
    double ac_shift_h = 0.0;

    // specify parameters + initial conditions
    NaV(double gbar_, double E_, double m_, double h_, double ac_shift_m_, double ac_shift_h_)
    {
        gbar = gbar_;
        E = E_;
        m = m_;
        h = h_;

        // defaults 
        if (isnan (E)) { E = 50; }

        p = 3;
        q = 1;

        name = "NaV";


        perm.Na = 1;

        ac_shift_m = ac_shift_m_;
        ac_shift_h = ac_shift_h_;

    }

    double m_inf(double V, double Ca) {return 1.0/(1.0+exp((V+25.5+ac_shift_m)/-5.29));}
    double h_inf(double V, double Ca) {return 1.0/(1.0+exp((V+48.9+ac_shift_h)/5.18));}
    double tau_m(double V, double Ca) {return 2.64 - 2.52/(1+exp((V+120.0)/-25.0));}
    double tau_h(double V, double Ca) {return (1.34/(1.0+exp((V+62.9)/-10.0)))*(1.5+1.0/(1.0+exp((V+34.9)/3.6)));}

};




#endif
