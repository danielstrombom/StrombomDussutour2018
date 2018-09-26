function X=WidePlotAB
%Function for plotting Fig 3A and 3B from simulated data

%load data from simulations (See WideLab.m for description)
load OO
load LL
load UU
load SC
load CSS
load CssT


%Construct matrix holding the proportion of outbound (OO), laden (LL) and
%unladen (UU) WITH the turn rule over the TT simulations as columns
CC=[OO,LL,UU];

%Create side-by-side boxplot of the simulation data WITH turning rule
subplot(1,2,1)
boxplot(CC);

%Plot the measurements from the exepriments on top of the simulation
%boxplots
hold on
plot(1*ones(1,12),[0.6689453 0.6680455 0.6853659 0.6399632 0.6828063 0.5811518 0.5601093 0.7049873 0.5507726 0.6972921 0.5974729 0.7050847],'r*');
hold on
plot(3*ones(1,12),[0.3787196 0.3574833 0.3343783 0.4005877 0.3652850 0.4984584 0.3098446 0.3304598 0.5584112 0.6086449 0.2907609 0.2470930],'b*');
hold on
plot(2*ones(1,12),[0.9427083 0.9207921 0.8974359 0.9764706 0.9573460 0.8684211 0.8933333 0.8819876 0.9263804 0.8394161 0.9198113 0.9197080],'k*');
xlabel('Type')
ylabel('Proportion traveling in the central zone')
xticks([1,2,3])
xticklabels({'Outbound (O)','Laden (L)','Unladen (U)'})
ylim([0 1])




load ROOO
load ROLL
load ROUU
load ROSC
load ROCSS
load ROCssT

%Construct matrix holding the proportion of outbound (OO), laden (LL) and
%unladen (UU) WITHOUT the turn rule over the TT simulations as columns
CCR=[ROOO,ROLL,ROUU];

%Create side-by-side boxplot of the simulation data WITHOUT turning rule
subplot(1,2,2)
boxplot(CCR);

%Plot the measurements from the exepriments on top of the simulation
%boxplots
hold on
plot(1*ones(1,12),[0.6689453 0.6680455 0.6853659 0.6399632 0.6828063 0.5811518 0.5601093 0.7049873 0.5507726 0.6972921 0.5974729 0.7050847],'r*');
hold on
plot(3*ones(1,12),[0.3787196 0.3574833 0.3343783 0.4005877 0.3652850 0.4984584 0.3098446 0.3304598 0.5584112 0.6086449 0.2907609 0.2470930],'b*');
hold on
plot(2*ones(1,12),[0.9427083 0.9207921 0.8974359 0.9764706 0.9573460 0.8684211 0.8933333 0.8819876 0.9263804 0.8394161 0.9198113 0.9197080],'k*');
xlabel('Type')
ylabel('Proportion traveling in the central zone')
xticks([1,2,3])
xticklabels({'Outbound (O)','Laden (L)','Unladen (U)'})
ylim([0 1])


X=[mean(CssT),max(CssT),mean(SC),std(CssT),std(SC);mean(ROCssT),max(ROCssT),mean(ROSC),std(ROCssT),std(ROSC)];
