# StrombomDussutour2018

INSTRUCTIONS FOR (RE)GENERATING FIGURES 1 AND 3 IN ‘STRÖMBOM & DUSSUTOUR. 2018. SELF-ORGANIZED TRAFFIC VIA PRIORITY RULES IN LEAF-CUTTING ANTS. PLOS COMPUT. BIOL.” FROM NEW SIMULATIONS OR FROM APPENDED DATA.


Download the folders Fig1 and Fig3 to your computer.


(RE)GENERATE FIG 1

Set Fig1 as Current Folder in Matlab.

To run a complete set of new simulations and generate a new Fig 1 type NarrowLab(1000) on the command line and press enter. This script calls the main simulation function (NarrowModel.m) 1000 times and calculates and plots the distributions in Fig 1 (via NarrowPlotCI.m). It also returns the mean group size, max group size, and total flow. 

To regenerate Fig1 from the same data used for the figures in the manuscript set Current Folder Fig1> Data and run the script NarrowPlotCI.


NOTE: Font size, width of lines and other superficial features of the plots you generated will/may differ from the ones in the manuscript, but the actual values will be identical if you regenerated them from the appended data. If you run new simulations the results will be very similar but not identical because of stochasticity in leaving times etc. 


(RE)GENERATE FIG 3

Set Fig3 as Current Folder in Matlab.

To run a complete set of new simulations and generate a new Fig 3 type WideLab(1000) on the command line and press enter. This script calls the main simulation function (WideModel.m) 1000 times and calculates and plots the distributions in Fig 3 (via WidePlotAB). It also returns the mean group size, max group size, and total flow. 

To regenerate Fig3 from the same data used for the figures in the manuscript set Current Folder Fig3> Data and run the script WidePlotAB.



NOTE: All code has been tested on a Mac running MATLAB_R2016b and a PC running MATLAB_R2017a and there were no problems. 
