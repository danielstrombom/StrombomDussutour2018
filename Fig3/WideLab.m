function X=WideLab(TT)
%Function to run TT simulations of the Wide trail 
%model with and without Turning and measure proportion of U L O in the central/
%peripheral zones and plot Figure 3.  


%WIDE MODEL WITH THE TURNING RULE

OO=zeros(TT,1); %Cell to store proportion of outbound particles in the central zone in each of the TT simulations.
UU=zeros(TT,1); %Cell to store proportion of unladen particles in the central zone in each of the  TT simulations.
LL=zeros(TT,1); %Cell to store proportion of laden particles in the central zone in each of the  TT simulations.
SC=zeros(TT,1); %Cell to store number of clusters observed in each of the TT simulations.
CSS=cell(TT,1); %Cell to store 
CssT=[]; %Vector to collect all group sizes in all TT simulations 

for t=1:TT   
   % t               %Print simulation number to track progress

    C=WideModel;    %Run the wide trail model once

    sC=size(C,2);   %Calculate number of clusters in most recent simulation
    SC(t,1)=sC;     %Store number of clusters in t:th simulation

    % INITIATE ZONE COUNTS
    O1=0; O2=0; O3=0;
    U1=0; U2=0; U3=0;
    L1=0; L2=0; L3=0;

    %COUNT TYPES IN ZONES
    for i=1:sC

        if C(2,i)==1 %If outbound
            if C(1,i)<1.25 %If in lower peripheral zone
                O1=O1+1;
            elseif C(1,i)>3.75 %If in upper peripheral zone
                O3=O3+1;
            else %If in central zone
                O2=O2+1;
            end
        elseif C(2,i)==2 %If unladen
            if C(1,i)<1.25
                U1=U1+1;
            elseif C(1,i)>3.75
                U3=U3+1;
            else
                U2=U2+1;
            end
        else %If laden
            if C(1,i)<1.25
                L1=L1+1;
            elseif C(1,i)>3.75
                L3=L3+1;
            else
                L2=L2+1;
            end
        end
    end

    O=O1+O2+O3;
    pOC=O2/O; %Proportion Outbound in central zone

    L=L1+L2+L3;
    pLC=L2/L; %Proportion Laden in central zone

    U=U1+U2+U3;
    pUC=U2/U; %Proportion Unladen in central zone

    OO(t,1)=pOC;
    LL(t,1)=pLC;
    UU(t,1)=pUC;
    
    
    %COUNT CLUSTER SIZES
    j=1;
    oC=[];
    iC=[];
    for i=1:size(C,2)-1
        if C(2,i)==1 %Outbound
            if C(2,i+1)==1 %and next also outbound
                j=j+1; %increase count
            else
                oC=[oC,j]; 
                j=1;
            end
        end
        if C(2,i)>1 %Inbound
            if C(2,i+1)>1
                j=j+1;
            else
                iC=[iC,j];
                j=1;
            end
        end
    end
    
    %GROUP SIZES 
    Css=[oC,iC];    
    
    CSS{t,1}=Css;
    CssT=[CssT,Css];

    save OO
    save LL
    save UU
    save SC
    save CSS
    save CssT
end


%WIDE MODEL WITH THE STOPPING RULE INSTEAD OF THE TURNING RULE


OO=zeros(TT,1); %Cell to store proportion of outbound particles in the central zone in each of the TT simulations.
UU=zeros(TT,1); %Cell to store proportion of unladen particles in the central zone in each of the  TT simulations.
LL=zeros(TT,1); %Cell to store proportion of laden particles in the central zone in each of the  TT simulations.
SC=zeros(TT,1); %Cell to store number of clusters observed in each of the TT simulations.
CSS=cell(TT,1); %Cell to store 
CssT=[]; %Vector to collect all group sizes in all TT simulations 

for t=1:TT   
    t               %Print simulation number to track progress

    C=WideModelRO;    %Run the wide trail model once

    sC=size(C,2);   %Calculate number of clusters in most recent simulation
    SC(t,1)=sC;     %Store number of clusters in t:th simulation

    % INITIATE ZONE COUNTS
    O1=0; O2=0; O3=0;
    U1=0; U2=0; U3=0;
    L1=0; L2=0; L3=0;

    %COUNT TYPES IN ZONES
    for i=1:sC

        if C(2,i)==1 %If outbound
            if C(1,i)<1.25 %If in lower peripheral zone
                O1=O1+1;
            elseif C(1,i)>3.75 %If in upper peripheral zone
                O3=O3+1;
            else %If in central zone
                O2=O2+1;
            end
        elseif C(2,i)==2 %If unladen
            if C(1,i)<1.25
                U1=U1+1;
            elseif C(1,i)>3.75
                U3=U3+1;
            else
                U2=U2+1;
            end
        else %If laden
            if C(1,i)<1.25
                L1=L1+1;
            elseif C(1,i)>3.75
                L3=L3+1;
            else
                L2=L2+1;
            end
        end
    end

    O=O1+O2+O3;
    pOC=O2/O; %Proportion Outbound in central zone

    L=L1+L2+L3;
    pLC=L2/L; %Proportion Laden in central zone

    U=U1+U2+U3;
    pUC=U2/U; %Proportion Unladen in central zone

    OO(t,1)=pOC;
    LL(t,1)=pLC;
    UU(t,1)=pUC;
    
    
    %COUNT CLUSTER SIZES
    j=1;
    oC=[];
    iC=[];
    for i=1:size(C,2)-1
        if C(2,i)==1 %Outbound
            if C(2,i+1)==1 %and next also outbound
                j=j+1; %increase count
            else
                oC=[oC,j]; 
                j=1;
            end
        end
        if C(2,i)>1 %Inbound
            if C(2,i+1)>1
                j=j+1;
            else
                iC=[iC,j];
                j=1;
            end
        end
    end
    
    %GROUP SIZES 
    Css=[oC,iC];    
    
    CSS{t,1}=Css;
    CssT=[CssT,Css];

end   

ROOO=OO;
ROLL=LL;
ROUU=UU;
ROSC=SC;
ROCSS=CSS;
ROCssT=CssT;

    save ROOO
    save ROLL
    save ROUU
    save ROSC
    save ROCSS
    save ROCssT
    
    
    WidePlotAB

X=[mean(CssT),max(CssT),mean(SC),std(CssT),0,std(SC);mean(ROCssT),max(ROCssT),mean(ROSC),std(ROCssT),0,std(ROSC)];

