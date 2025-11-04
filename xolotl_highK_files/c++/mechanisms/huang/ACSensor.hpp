// _  _ ____ _    ____ ___ _
//  \/  |  | |    |  |  |  |
// _/\_ |__| |___ |__|  |  |___
//
// component info: Probe that reads out activation and inactivation variables of a channel

#ifndef ACSENSOR
#define ACSENSOR

//inherit controller class spec
class ACSensor: public mechanism {

public:

    // Terminology:
    // hp = half potential
    // dhp = change in half potential

    double tau_dhp_m = 50000;
    double tau_dhp_h = 50000;

    double dhp_m;
    double dhp_m_inf;
    double dhp_m_mag;
    double dhp_m_slope;
    double dhp_m_offset;

    double dhp_h;
    double dhp_h_inf;
    double dhp_h_mag;
    double dhp_h_slope;
    double dhp_h_offset;

    conductance * channel;

    // specify parameters + initial conditions for
    ACSensor(double dhp_m_mag_, double dhp_m_slope_, double dhp_m_offset_, double dhp_h_mag_, double dhp_h_slope_, double dhp_h_offset_) {
      // tau_AC = tau_AC_;
    //   if (gate_ != 0 && gate_ != 1) {
    //     mexErrMsgTxt("Unrecognized gate variable");
    //   }
      dhp_m_mag = dhp_m_mag_;
      dhp_m_slope = dhp_m_slope_;
      dhp_m_offset = dhp_m_offset_;
      dhp_h_mag = dhp_h_mag_;
    //   if (isnan(dhp_h_mag_)) {
    //     dhp_h_inf = 23;
    //   }
      dhp_h_slope = dhp_h_slope_;
      dhp_h_offset = dhp_h_offset_;
      fullStateSize = 4;
      name = "ACSensor";
    }

    double getState(int);
    // void connectCompartment(compartment *);
    void connectConductance(conductance *);
    void integrate(void);

};

double ACSensor::getState(int idx) {
    double v = 0;
    switch (idx) {
        case 0:
            v = channel->ac_shift_m;
            break;
        case 1:
            v = dhp_m_inf;
            break;
        case 2:
            v = channel->ac_shift_h;
            break;
        case 3:
            v = dhp_h_inf;
            break;
        default:
            mexErrMsgTxt("Illegal getState index");
    }
    return v;
}

void ACSensor::integrate(void) {
    // mechanism * alphasensor = (channel->container)->getMechanismPointer(0);
    int n_mech = comp->n_mech;
    for (int i = 0; i < n_mech; i++) { // Loop through mechs to find alphasensor
        mechanism * mech = comp->getMechanismPointer(i);
        if (mech->name == "AlphaSensor") {
            double alpha = mech->getState(0);

            // Update dhp_m if supplied or exists
            if (!isnan(dhp_m_mag)) {
                dhp_m_inf = dhp_m_mag/(1+exp(dhp_m_slope*(alpha-dhp_m_offset)));
                dhp_m = dhp_m_inf + (dhp_m - dhp_m_inf)*exp(-dt/tau_dhp_m);
                channel->ac_shift_m = dhp_m;
            }

            // Update dhp_h if supplied or exists
            if (!isnan(dhp_h_mag)) {
                dhp_h_inf = dhp_h_mag/(1+exp(dhp_h_slope*(alpha-dhp_h_offset)));
                dhp_h = dhp_h_inf + (dhp_h - dhp_h_inf)*exp(-dt/tau_dhp_h);
                channel->ac_shift_h = dhp_h;
            }

            break;
        }
    }

    

    // if (alphasensor->name == "AlphaSensor") {
    //   double alpha = alphasensor->getState(0);
    //   ac_shift_inf = 3;
    //   ac_shift_inf = ac_shift_mag/(1+exp(ac_shift_slope*(alpha-ac_shift_offset)));
    //   ac_shift = ac_shift_inf + (ac_shift - ac_shift_inf)*exp(-dt/tau_AC);
    //   if (gate == 0) {
    //     channel->ac_shift_m = ac_shift;
    //   } else {
    //     channel->ac_shift_h = ac_shift;
    //   }
    // }
}

void ACSensor::connectConductance(conductance * channel_) {

    channel = channel_;

    // make sure the compartment that we are in knows about us
    (channel->container)->addMechanism(this);
    // controlling_class = "compartment";
}

#endif
