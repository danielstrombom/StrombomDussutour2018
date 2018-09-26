function X=NarrowPlot
%%FOR REVIEW PURPOSES ONLY. Function to plot figure 1 from simulation data


%load simulation data (See NarrowLab.m for description)
load pGT 
load LUsT 
load pPT 
load plLT
load ME
load MA
load SC
load CssC


%INITIATE VECTORS FOR PLOTS

mpG=[];
mepG=[];
MpG=[];
mLU=[];
meLU=[];
MLU=[];

mpP=[];
mepP=[];
MpP=[];

mplL=[];
meplL=[];
MplL=[];


%CREATE DISTRIBUTIONS (min-mean-max)

for i=1:15 
    
    %GROUP SIZE DISTRIBUTION
    mpG=[mpG,min(pGT(:,i))];
    mepG=[mepG,nanmean(pGT(:,i))];
    MpG=[MpG,max(pGT(:,i))];
    
    %LADEN IN GROUPS OF SIZE N
    mLU=[mLU,min(LUsT(:,i))];
    meLU=[meLU,nanmean(LUsT(:,i))];
    MLU=[MLU,max(LUsT(:,i))];
    
    %GROUPS OF SIZE N LED BY LADEN
    mplL=[mplL,min(plLT(:,i))];
    meplL=[meplL,nanmean(plLT(:,i))];
    MplL=[MplL,max(plLT(:,i))];

end

%LADEN IN POSITION P
for i=1:20
    mpP=[mpP,min(pPT(:,i))];
    mepP=[mepP,nanmean(pPT(:,i))];
    MpP=[MpP,max(pPT(:,i))];
end

%EXPERIMENTAL DATA from Dussutour et al. 2009

%Group size distribution
pGe=[0.181996864,0.151809821,0.131600419,0.105798217,0.086726403,0.063303453,0.058292003,0.047401344,0.031639306,0.03008475,0.025427603,0.017199547,0.011478633,0.011654413,0.045587225];
pGCI=[0.0104323,0.009725211,0.009163667,0.008329223,0.007614047,0.006575014,0.006356577,0.005747258,0.004768046,0.004600034,0.004272562,0.003477956,0.002903235,0.002879618,0.005658327];
%Proportion of Laden in inbound groups of size N
pLUe=[0.128907858,0.181096513,0.201779305,0.210970134,0.221261504,0.269752908,0.252260702,0.232382353,0.269623132,0.28005471,0.259274059,0.235871212,0.248974359,0.25952381,0.257054938];
pLUCI=[0.011663522,0.013403844,0.013968757,0.014200877,0.014447966,0.015448131,0.01511673,0.014700496,0.015445787,0.015628926,0.015253386,0.014776742,0.015050906,0.015258158,0.015210703];
%Proportion of Laden an position P in inbound group
pPe=[0.298854962,0.311874106,0.243274854,0.219512195,0.219090909,0.226351351,0.178120617,0.174295775,0.182017544,0.138297872,0.162068966,0.165919283,0.166666667,0.16025641,0.150793651,0.142857143,0.118421053,0.127272727,0.108695652,0.147058824];%Proportion of groups of size N led by Laden
pPCI=[0.015983285,0.016175417,0.014981302,0.014452543,0.014442564,0.014611517,0.013359586,0.013246085,0.013472881,0.01205364,0.012867256,0.012989258,0.013012646,0.012808932,0.01249482,0.012218263,0.011281762,0.011636941,0.010868034,0.01236622];

plLe=[0.128107075,0.209302326,0.240223464,0.328063241,0.33490566,0.428571429,0.386206897,0.410714286,0.4625,0.441860465,0.46969697,0.511627907,0.56,0.6,0.46031746];
plLCI=[0.023409564,0.02849492,0.029924427,0.032886539,0.033058113,0.03466313,0.034103284,0.034459427,0.034923704,0.034784772,0.034957963,0.035012871,0.034769268,0.034314748,0.034911869];

figure;
%FIG 1A
subplot(2,2,1)
plot([1:15],mpG,'--k');
hold on
plot([1:15],mepG,'-*r');
hold on
plot([1:15],MpG,'-k');
hold on
errorbar([1:15],pGe,pGCI,pGCI,'-b');
xlabel('Group size (N)')
ylabel('Proportion of groups of size N')

%FIG 1B
subplot(2,2,2)
plot([1:15],mLU,'--k');
hold on
plot([1:15],meLU,'-*r');
hold on
plot([1:15],MLU,'-k');
hold on
errorbar([1:15],pLUe,pLUCI,pLUCI,'-b');
xlabel('Group size (N)')
ylabel('Proportion of laden in groups of size N')

%FIG 1C
subplot(2,2,3)
plot([1:20],mpP,'--k');
hold on
plot([1:20],mepP,'-*r');
hold on
plot([1:20],MpP,'-k');
hold on
errorbar([1:20],pPe,pPCI,pPCI,'-b');
xlabel('Position (P)')
ylabel('Proportion of laden at position P')

%FIG 1D
subplot(2,2,4)
plot([1:15],mplL,'--k');
hold on
plot([1:15],meplL,'-*r');
hold on
plot([1:15],MplL,'-k');
hold on
errorbar([1:15],plLe,plLCI,plLCI,'-b');
xlabel('Group size (N)')
ylabel('Proportion of groups of size N led by laden')


X=[mean(CssC),max(CssC),mean(SC);std(CssC),0,std(SC)]; %mean and max group size over the experiments and mean flow
