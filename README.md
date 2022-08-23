# Modeling the recovery of bursting of the crab pyloric neurons in 2.5x [K+] saline

This repository holds the code for the project *modeling the recovery of bursting of the crab pyloric neurons in 2.5x[K+] saline*. In short, this is called the HighK project. The initial findings and basic background of this project is written in the Abstract section. 

This project is currently divided into 4 parts (and hence 4 folders inside HighK): Network, ABPD, ABcoupledPD, and AB_multi_compartment. The Abstract is currently about ABcoupledPD. Each part has their own experiments, which are outlined in the Experiments section. Each file also explains the purpose of each file and how to run them.

"Test files" are not actually test files, but they act more like a demo on how to run the code. They also serve as making sure the actual code runs as it was intended to.

# Abstract
The pyloric circuit of the stomatogastric ganglion of crustaceans is a central pattern generator that produces a motor pattern important for digestion. Recent study discovered an adaptation of the neurons in the pyloric circuit of the crab C. Borealis to an increase in extracellular potassium concentration (He et al., 2020). They showed that the pyloric dilator (PD) neuron, which is a part of the pacemaker kernel driving bursting in the network, switched to tonic spiking in response to 2.5-fold increase in extracellular [K+] (2.5x[K+]), but then recovered its bursting activity similar to baseline within 60 minutes. The recovery of bursting activity was accompanied by the change in the intrinsic excitability of PD neurons. However, the ionic mechanism of the recovery of bursting remains unknown. We generated a large family of biophysical models of a PD neuron coupled to an anterior burster (AB) neuron to study which changes in the ionic currents result in the bursting activity in 2.5x[K+]. The 2.5-fold increase in extracellular [K+] was modeled as changing the equilibrium potentials of the potassium-dependent ion currents, which are calcium-dependent potassium current (IKCA), delayed-rectifier current (IKd), and A-type potassium current (IA), from -80mV to -56mV, and the equilibrium potential of a leak current from -50mV to -38mV. We sampled sets of maximal conductances of the ionic currents of AB and PD neurons to generate two distributions that result in 1) tonically firing PD neurons in 2.5x[K+] saline (n = 12016) and 2) burst in 2.5x[K+] saline (n = 12287). We compared the sets of maximal conductances across distributions to investigate the changes necessary for switching from tonic to bursting pattern of activity. Preliminary results show a shift in the conductance distributions of multiple ionic currents, with the biggest positive shift observed in the distribution of the maximal conductances of IKCA in a PD neuron. We also observed a significant shift towards lower conductances of IKd in a PD neuron and transient calcium current (ICaT) in an AB neuron. Future investigations include adding axonal compartments to the present models to produce more biologically plausible morphology and shifting the activation curves of the ionic currents to examine other potential mechanisms of adaptation in addition to changes in the maximal conductances.

**References**

He, L.S., Rue, M.C.P., Morozova, E.O., Powell, D.J., James, E.J., Kar, M., Marder, E. Rapid adaptation to elevated extracellular potassium in the pyloric circuit of the crab, Cancer borealis. J Neurophysiol. 2020 May 1;123(5):2075-2089. doi: 10.1152/jn.00135.2020.


# Installation
Make sure to have the following toolboxes installed in your MATLAB
1. Xolotl
2. tight_subplot

The `MyXolotl` folder holds custom files that need to be copied to the Xolotl toolbox for the code to work. Run `initialize.sh` in the `MyXolotl` folder and it will add the custom files to their location in Xolotl toolbox.

# The core of how this project is structured
The main class is called the HKX, which is a xolotl wrapper (more info in the file). Inside contains methods that are used repeately to setup the neurons, so it will simplify the setup process.


# Experiments
The generated data for these experiments are stored in this [google drive folder](https://drive.google.com/drive/folders/17p2R4jzCggg1Iz1D2U3Vg_9IeerLVw-A?usp=sharing).
## Network Experiments

| Exp Number    | Description           | Num Models  |
| ----|---|-----------:|
| 1   | Simulate the prinz network while changing Ek for A, KCa, and Kd from -100mV to -40mV, but this is wrong because synaptic currents also depend on K. | 150 |
| 2   | Same thing as in exp1 but now also changing Echol and Eglut | 150 |
| 3.1 | Increasing all gbar from x2 to x8 on ABPD that switch to silent at -70mV |  |
| 3.2 | Using Model 221, did a grid search on gbar on ABPD ranging from x1 to x3. | 6561 |
| 3.3 | Same as 3.2 except simulate 10 seconds and only grab the last 5 seconds to avoid initial effect. | 6561 |
| 3.4 | Increase KCa on all neurons, and they become triphasic. Just to demonstrate KCa on networks. | 1 |
| 4   | Attach ABcPD models to the network and see what changes |  |

## ABPD Experiments
| Exp Number | Description | Num Models |
| ----|---|-----------:|
| 1   | Simulate the prinz ABPD while changing Ek for A, KCa, and Kd from -100mV to -40mV. | 5 |

## ABcoupledPD Experiments

## AB_multi_compartment Experiments
| Exp Number | Search Area | Criteria | Num Models | Other Notes
| ---|---|---|---|---|
| rand_1 | [0, 4*gi] for A, CaS, CaT, KCa, Kd, NaV<br>[0, 2\*gi] for H and leak | At -80mV<br>ABaxon: spikes_per_burst >= 3<br> ABsn: firing rate between 0.5Hz to 2Hz<br>At -56mV,<br>ABaxon: ibi_std < 100 (more uniform means tonic firing) | 10651 | 
| rand_high_1 | [0, 4*gi] for A, CaS, CaT, KCa, Kd, NaV<br>[0, 2\*gi] for H and leak | At -80mV<br>ABaxon: spikes_per_burst >= 3<br> ABsn: firing rate between 0.5Hz to 2Hz<br>At -56mV,<br>ABaxon: ibi_mean > 500 (0.1ms), ibi_std < 2, spikes_per_burst => 3 | 11623 |
