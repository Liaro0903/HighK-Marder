// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: Calcium activated Potassium current 
// component source [Prinz et al. 2003](http://jn.physiology.org/content/jn/90/6/3998.full.pdf)
//
#ifndef KCA
#define KCA

//inherit conductance class spec
class KCa: public conductance {

public:
    double ac_shift_m = 0.0;

    // specify parameters + initial conditions
    KCa(double gbar_, double E_, double m_, double ac_shift_m_)
    {
        gbar = gbar_;
        E = E_;
        m = m_;

        // defaults 
        if (isnan (E)) { E = -80; }


        AllowMInfApproximation = false;
        AllowHInfApproximation = false;

        p = 4;

        name = "KCa";

        perm.K = 1;

        ac_shift_m = ac_shift_m_;
        
    }

    double m_inf(double V, double Ca) {return (Ca/(Ca+3.0))/(1.0+exp((V+28.3+ac_shift_m)/-12.6)); }
    double tau_m(double V, double Ca) {return 180.6 - 150.2/(1.0+exp((V+46.0)/-22.7));}

};




#endif
