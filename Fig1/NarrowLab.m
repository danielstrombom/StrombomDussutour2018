function X=NarrowLab(TT)
%Function to run the Narrow trail model TT times and calculate various 
%distribution describing the traffic generated by the model. 


%INITIATE DISTRIBUTIONS

    pGT=[]; %For collecting the cluster size distributions over the TT trials
    LUsT=[]; %For collecting the proportion of laden in clusters of a certain size over the TT trials
    pPT=[]; %For collecting the proportion of laden in certain position over the TT trials
    plLT=[]; %For collecting the proportion of clusters of size N led by laden over the TT trials
    ME=[]; %For collecting the mean cluster sizes over the TT trials
    MA=[]; %For collecting the max cluster sizes over the TT trials
    SC=[]; %For collecting the total number of crossings in each trial over the TT trials
    CssC=[]; %For collecting all cluster sizes over the TT trials

for num=1:TT 
    num %print run to track progress
    tic
    Y=NarrowModel; %Run the Narrow bridge model
    C=Y{2}; % Sequence matrix
    sC=Y{1}; % Length of sequence matrix (=total number of crossings during the simulation)
    
    j=1; %Initiate cluster size counter
    oC=[]; %To store outbound cluster sizes
    iC=[]; %To store inbound cluster sizes
    p=1; %Initiate number of Inbound clusters counter
    Gs=cell(800,1); %Initiate cell for collecting inbound clusters (will be less than 800, will count actual number on line 96 and use that number later)
   
    %COUNT MID-BRIDGE CROSSINGS
    for i=1:size(C,2)-1 %for each mid line crossing occuring in the simulation (Except the last one) do
        if C(1,i)==1 %if crossing i is made by Outbound
            if C(1,i)==C(1,i+1) %and if the next crossing (i+1) is also by an Outbound
                j=j+1; %increase cluster size count
            else %and if the next crossing Not by an outbound outbound
                oC=[oC,j]; %Record the size of the recent inbound cluster (j) in the outbound cluster size vector oC
                j=1; %and reset the cluster counter
            end
        end
        if C(1,i)==-1 %if crossing i is made by Inbound (Unladen or Laden)
            if C(1,i)==C(1,i+1) %and next also inbound
                j=j+1; %Increase count
            else %if next is not inbound
                iC=[iC,j]; %Record size of inbound cluster
                Gs{p,1}=C(2,(i-j+1):i); %Collect the Types of particles in the inbound cluster  (Vector of 2's (unladen) and 3's (laden) in the order the ants passed the bridge)
                p=p+1; %Increase number of inbound clusters counter
                j=1; %Reset cluster counter
            end
        end
    end

    %ADJUST p
    p=p-1; %last count p=p+1 on line 46 should be discarded
    
    %CREATE cluster SIZE DISTRIBUTION
    Css=[oC,iC]; %Collect all recorded cluster/cluster sizes
    maxGrp=max(Css); %Calculate the maximum cluster size
    B=zeros(1,15); %For collecting number of clusters of a certain size (1 to 14, and >=15)
    for i=1:size(Css,2) %Go through all recorded cluster sizes
        if Css(1,i)>14 %If cluster larger than or equal to 15
            B(1,15)=B(1,15)+1; %increase count
        else
            for j=1:14 %Find number of clusters of size 1,2,...,14
                if Css(1,i)==j
                    B(1,j)=B(1,j)+1;
                end
            end
        end
    end
    pG=(1/sum(B))*B; %The cluster size distribution for this simulation

    %CREATE PROPORTION OF LADEN IN clusterS OF SIZE N DISTRIBUTION
    LU=zeros(2,15);
    for i=1:p %Go through all recorded inbound clusters
        A=Gs{i,1};
        sA=size(A,2); %Number of ants in the cluster
        if sA>14 %If more than 14 ants in the cluster 
            la=sum(A(1,:)==3); %Number of laden in inbound cluster i
            LU(1,15)=LU(1,15)+la; %Update number of laden in clusters of size >=15
            LU(2,15)=LU(2,15)+(sA-la); %Update number of unladen in clusters of size >=15
        else
            for j=1:14 %For each cluster size 1-14
                if sA==j
                    la=sum(A(1,:)==3); %count number of laden
                    LU(1,j)=LU(1,j)+la; %add laden count
                    LU(2,j)=LU(2,j)+(sA-la); %add unladen count
                end
            end
        end
    end
    LUs=LU(1,:)./(LU(1,:)+LU(2,:)); %Proportion of laden in clusters of certain size 1-14, >15
    
    %CREATE PROPORTION OF LADEN IN A CERTAIN POSITION DISTRIBUTION
    if maxGrp<20   
        maxGrp=20;
    end
    
    P=zeros(p,maxGrp+1);
    for i=1:p
        A=Gs{i,1};
        sA=size(A,2);
        P(i,:)=[A,zeros(1,maxGrp-sA+1)];
    end
    
    pPo=zeros(2,20);
    for j=1:20
        nL=sum(P(:,j)==3); %number of laden in the j:th position
        nU=sum(P(:,j)==2); %number of unladen in the j:th position
        pPo(1,j)=nL;
        pPo(2,j)=nU;
    end
    
    pP=pPo(1,:)./(pPo(1,:)+pPo(2,:)); %proportion of laden in each position
    
    %CREATE PROPORTION OF CLUSTERS OF SIZE N LED BY LADEN DISTRIBUTION
    glL=zeros(2,15);
    for i=1:p %for each inbound cluster
        A=Gs{i,1}; %get sequence of unladen or laden
        sA=size(A,2);
        if sA>14 %For cluster size larger than 14
            if A(1,1)==3 %if laden
                glL(1,15)=glL(1,15)+1; %increase count of group >14 lead by laden
            else
                glL(2,15)=glL(2,15)+1; %increase count of group >14 lead by unladen
            end
        else
            for j=1:14 %for each group size <15
                if sA==j
                    if A(1,1)==3 %if laden
                        glL(1,j)=glL(1,j)+1; %increase count led by laden
                    else
                        glL(2,j)=glL(2,j)+1; %increase count led by unladen
                    end
                end
            end
        end
    end
    
    plL=glL(1,:)./(glL(1,:)+glL(2,:)); %proportion of clusters led by laden for each grp size.

    %ADD distributions from simulation t to matrix containing distributions
    %over all TT simulations
    pGT=[pGT;pG];
    LUsT=[LUsT;LUs];
    pPT=[pPT;pP];
    plLT=[plLT;plL];
    ME=[ME,mean(Css)];
    MA=[MA,max(Css)];
    CssC=[CssC,Css];
    SC=[SC,sC];
    toc
    
    
end

save pGT
save LUsT
save pPT
save plLT
save ME
save MA
save SC
save CssC




%FOR COLLECTING THE
mpG=[]; %Minimum cluster sizes
mepG=[]; %Mean cluster sizes
MpG=[]; %Max cluster sizes

mLU=[]; %Minimum prop of laden in clusters of size N
meLU=[]; %Mean prop of laden in clusters of size N
MLU=[]; %Max prop of laden in clusters of size N

mpP=[]; %Min prop laden in position P
mepP=[]; %Mean prop laden in position P
MpP=[]; %Max prop laden in position P

mplL=[]; %Min prop clusters of size N leb by laden
meplL=[]; %Mean prop clusters of size N leb by laden
MplL=[]; %Max prop clusters of size N leb by laden

for i=1:15 %Use distributions created over the TT simulations to fill out above vectors
    
   
    mpG=[mpG,min(pGT(:,i))];
    mepG=[mepG,mean(pGT(:,i))];
    MpG=[MpG,max(pGT(:,i))];

    mLU=[mLU,min(LUsT(:,i))];
    meLU=[meLU,mean(LUsT(:,i))];
    MLU=[MLU,max(LUsT(:,i))];

    mplL=[mplL,min(plLT(:,i))];
    meplL=[meplL,mean(plLT(:,i))];
    MplL=[MplL,max(plLT(:,i))];

end

for i=1:20
    mpP=[mpP,min(pPT(:,i))];
    mepP=[mepP,mean(pPT(:,i))];
    MpP=[MpP,max(pPT(:,i))];
end




%PLOT DISTRIBUTIONS FROM SIMULATIONS AND EXP DATA
NarrowPlotCI;

X=[mean(ME),max(MA),mean(SC);std(ME),0,std(SC)]; %mean and max group size over the experiments and mean flow


