// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: Inward rectifying potassium current 
// component source [Prinz et al. 2003](http://jn.physiology.org/content/jn/90/6/3998.full.pdf)
//
#ifndef KD
#define KD

//inherit conductance class spec
class Kd: public conductance {

public:
    double ac_shift_m = 0.0;

    //specify both gbar and erev and initial conditions
    Kd(double gbar_, double E_, double m_, double ac_shift_m_)
    {
        gbar = gbar_;
        E = E_;
        m = m_;

        // defaults         
        if (isnan (E)) { E = -80; }

        p = 4;

        name = "Kd";


        perm.K = 1;

        ac_shift_m = ac_shift_m_;

    }

    double m_inf(double V, double Ca) {return 1.0/(1.0+exp((V+12.3+ac_shift_m)/-11.8));}
    double tau_m(double V, double Ca) {return 14.4 - 12.8/(1.0+exp((V+28.3)/-19.2));}

};




#endif
