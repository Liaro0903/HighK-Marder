// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: Hyper-polarization activated inward current 
// component source [Prinz et al. 2003](http://jn.physiology.org/content/jn/90/6/3998.full.pdf)
//
#ifndef HCURRENT
#define HCURRENT

//inherit conductance class spec
class HCurrent: public conductance {

public:
    double ac_shift_m = 0.0;

    //specify both gbar and erev and initial conditions
    HCurrent(double gbar_, double E_, double m_, double ac_shift_m_)
    {
        gbar = gbar_;
        E = E_;
        m = m_;

        // defaults 
        if (isnan (E)) { E = -20; }

        name = "HCurrent";

        ac_shift_m = ac_shift_m_;


    }

    double m_inf(double V, double Ca) {return 1.0/(1.0+exp((V+75.0+ac_shift_m)/5.5));}
    double tau_m(double V, double Ca) {return (2/( exp((V+169.7)/(-11.6)) + exp((V- 26.7)/(14.3)) ));}

};




#endif
