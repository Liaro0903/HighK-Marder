// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: Slow Calcium current  
// component source [Prinz et al. 2003](http://jn.physiology.org/content/jn/90/6/3998.full.pdf)
//
#ifndef CAS
#define CAS

//inherit conductance class spec
class CaS: public conductance {

public:
    double ac_shift_m = 0.0;
    double ac_shift_h = 0.0;

    // specify parameters + initial conditions
    CaS(double gbar_, double E_, double m_, double h_, double ac_shift_m_, double ac_shift_h_)
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
        name = "CaS";

        perm.Ca = 1;

        ac_shift_m = ac_shift_m_;
        ac_shift_h = ac_shift_h_;

    }

    double m_inf(double V, double Ca) {return 1.0/(1.0+exp((V+33.0+ac_shift_m)/-8.1));}
    double h_inf(double V, double Ca) {return 1.0/(1.0+exp((V+60.0+ac_shift_h)/6.2));}
    double tau_m(double V, double Ca) {return 2.8 + 14.0/(exp((V+27.0)/10.0) + exp((V+70.0)/-13.0));}
    double tau_h(double V, double Ca) {return 120.0 + 300.0/(exp((V+55.0)/9.0) + exp((V+65.0)/-16.0));}

};

#endif