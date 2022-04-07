# SNN-LAL-CPG
The code simulating the Spiking Neural Network from the paper "Production of adaptive movement patterns via an insect inspired Spiking Neural Network Central Pattern Generator."

The simulations took place on a High-Performance-Cluster. This is why the code is initiated with the Submit_Exploration.bash file. This will initiate 125 parallel simulation loops using the MegaLoop.m-file. Each simulation is exported as a separate .mat-file. Please not, due to the noise component during the calculation, you may not achieve the exact same results.
