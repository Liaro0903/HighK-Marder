// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: alph term
// component source [Liu et al. 98](http://www.jneurosci.org/content/jneuro/18/7/2309.full.pdf)
//

#ifndef ALPHASENSOR
#define ALPHASENSOR
#include "mechanism.hpp"
#include <limits>


//inherit mechanism class spec
class AlphaSensor: public mechanism {

public:

    // parameters for LiuController
    double tau_alpha = 20000;
    double alpha = -50;
    double alpha_inf = -50;
    
    // specify parameters + initial conditions 
    AlphaSensor(double tau_alpha_, double alpha_)
    {
        tau_alpha = tau_alpha_;
        alpha = alpha_;
        fullStateSize = 1;
        name = "AlphaSensor";
    }

    void integrate(void);
    double getState(int);

};

void AlphaSensor::integrate(void) {

    // alpha = 139.0;
    // alpha_inf += (dt/tau_alpha)*(comp->V - alpha_inf);
    alpha_inf = comp->V;
    alpha = alpha_inf + (alpha - alpha_inf)*exp(-dt/tau_alpha);

}

double AlphaSensor::getState(int idx) {
  return alpha;
  // return comp->V;
}


#endif
