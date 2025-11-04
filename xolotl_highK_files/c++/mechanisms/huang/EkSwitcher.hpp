// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: alph term
// component source [Liu et al. 98](http://www.jneurosci.org/content/jneuro/18/7/2309.full.pdf)
//

#ifndef EKSWITCHER
#define EKSWITCHER
#include "mechanism.hpp"
#include <limits>


// inherit mechanism class spec
class EkSwitcher: public mechanism {

public:

    double counter = 0.0;
    // double timepoints[6] = {10, 30, 50, 55, 56, 100};
    double timepoints[2] = {200, 450};
    // double timepoints[4] = {20, 50, 60, 65}; // just for testing
    double tp_length = sizeof(timepoints) / sizeof(timepoints[0]);
    double V_low = -80;
    double V_high = -56;
    double V_diff = V_high - V_low;
    double slope = 1.0;
    double E = 0.0; 
    double Eleak = 0.0;

    // specify parameters + initial conditions 
    EkSwitcher(double V_low_, double V_high_, double slope_)
    {
        V_low = V_low_;
        V_high = V_high_;
        slope = slope_;
        V_diff = V_high - V_low;
        fullStateSize = 2;
        name = "EkSwitcher";
    }

    void integrate(void);
    double getState(int);
    double risingEk(double, double, double);
    double fallingEk(double, double, double);
   
    // void init(void);

};

void EkSwitcher::integrate(void) {
    counter += 0.0001;
    conductance * KCa = comp->getConductancePointer("KCa");
    conductance * Kd = comp->getConductancePointer("Kd");
    conductance * ACurrent = comp->getConductancePointer("ACurrent");
    conductance * Leak = comp->getConductancePointer("Leak");
    E = KCa->E;  // For getState to have a var to return E
    Eleak = Leak->E; // For getState to have a var to return Eleak

    double Ek = 0.0;
    double Ek_leak = 0.0;

    for (int i = 0; i < tp_length; i++) {
        if (i % 2 == 0) {    // rising time points
            Ek += risingEk(1, counter, timepoints[i]);
            Ek_leak += risingEk(1, counter, timepoints[i]);
        } else {
            Ek += fallingEk(1, counter, timepoints[i]) - 1; // minus 1 because of adding functions (try it on a graphing calculator)
            Ek_leak += fallingEk(1, counter, timepoints[i]) - 1;
        }
    }

    // Ek -= (tp_length / 2) * (V_high - V_low) - V_low; // can be deleted if the new calculation works better
    // Ek_leak -= (tp_length / 2) * 12 + 50; // can be deleted if the new calculation works better

    Ek = V_diff * Ek + V_low;
    Ek_leak = (V_diff / 2) * Ek_leak - 50; // increase by half, and shift to -50 mV instead of -80 mV

    KCa->E = Ek;
    Kd->E = Ek;
    ACurrent->E = Ek;
    Leak->E = Ek_leak;
}

double EkSwitcher::getState(int idx) {
    if (idx == 0) {
        return E;
    } else {
        return Eleak;
    }
}

double EkSwitcher::risingEk(double V_diff, double timepoint, double shift) {
    return V_diff / (1.0 + exp(-slope * (timepoint - shift)));
}

double EkSwitcher::fallingEk(double V_diff, double timepoint, double shift) {
    return V_diff / (1.0 + exp(slope * (timepoint - shift)));
}


#endif
