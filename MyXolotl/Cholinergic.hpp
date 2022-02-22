
// component info: Graded Cholinergic synapse 
// component source [Prinz et al. 2004](https://www.nature.com/articles/nn1352)
//
#ifndef CHOLINERGIC
#define CHOLINERGIC

class Cholinergic: public synapse {

public:

    double Delta = 5.0;
    double k_ = 0.01;
    double Vth = -35.0;

    double s_inf_cache[2000];
    double tau_s_cache[2000];


    // specify parameters + initial conditions
    Cholinergic(double gmax_, double s_, double Vth_, double E_)
    {
        gmax = gmax_;
        // E = -80.0;
        E = E_;
        Vth = Vth_;


        // dynamic variables
        s = s_;

        // defaults
        if (isnan (s)) { s = 0; }
        if (isnan (gmax)) { gmax = 0; }
        if (isnan (Vth)) { Vth = -35.0; }
        if (isnan (E)) { E = -80.0; }

    }

    void integrate(void);
    void integrateMS(int, double, double);
    void checkSolvers(int);

    double s_inf(double);
    double tau_s(double);
    double sdot(double, double);

    void init(void);

};


void Cholinergic::init() {
    // build a LUT 
    double V = 0;

    for (int V_int = -999; V_int < 1001; V_int++) {
        V = ((double) V_int)/10;
        s_inf_cache[V_int+999] = s_inf(V);
        tau_s_cache[V_int+999] = tau_s(V);
    }

}


double Cholinergic::s_inf(double V_pre) {return 1.0/(1.0+exp((Vth - V_pre)/Delta));}

double Cholinergic::tau_s(double V_pre) {
    return (1 - s_inf(V_pre))/k_;
}

double Cholinergic::sdot(double V_pre, double s_) {
    double sinf = s_inf(V_pre);
    return (sinf - s_)/tau_s(V_pre);
}

void Cholinergic::integrate(void) {
    // figure out the voltage of the pre-synaptic neuron
    double V_pre = pre_syn->V;

    int V_idx = (int) round((V_pre*10)+999);
    if (V_idx < 0) {V_idx = 0;};
    if (V_idx > 2000) {V_idx = 2000;};

    // integrate using exponential Euler
    s = s_inf_cache[V_idx] + (s - s_inf_cache[V_idx])*exp(-dt/tau_s_cache[V_idx]);

    g = gmax*s;
}

void Cholinergic::integrateMS(int k, double V, double Ca) {

    double V_pre;



    if (k == 0) {
        V_pre = pre_syn->V_prev;
        k_s[0] = dt*(sdot(V_pre, s));

    } else if (k == 1) {

        V_pre = pre_syn->V_prev + pre_syn->k_V[0]/2;
        k_s[1] = dt*(sdot(V_pre, s + k_s[0]/2));


    } else if (k == 2) {

        V_pre = pre_syn->V_prev + pre_syn->k_V[1]/2;
        k_s[2] = dt*(sdot(V_pre, s + k_s[1]/2));

    } else if (k == 3) {
        V_pre = pre_syn->V_prev + pre_syn->k_V[2];
        k_s[3] = dt*(sdot(V_pre, s + k_s[2]));


    } else {
        // last step

        s = s + (k_s[0] + 2*k_s[1] + 2*k_s[2] + k_s[3])/6;

        if (s < 0) {s = 0;}
        if (s > 1) {s = 1;}
    }

}

void Cholinergic::checkSolvers(int k){
    if (k == 0) {
        return;
    } else if (k == 4) {
        return;
    }
    mexErrMsgTxt("[Cholinergic] Unsupported solver order\n");
}



#endif
