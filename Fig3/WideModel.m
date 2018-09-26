function C=WideModel
%Function to simulate traffic on the wide bridge using the priority
%rules.

%OUTPUT C: The sequence of particles crossing the
%middle of the bridge. For each crossing the heading of the particle (+1 (outbound) or
%-1 (inbound)) and the type of ant (1 (outbound), 2 (unladen), 3 Laden) is
%recorded.

rng('shuffle')

%Enter bridge at (truncated normal distribution around center (mean=2.5) and std dev. sigma).


%PARAMETERS FROM THE EXPERIMENTS
L=300;%300 %Length of bridge
w=5; %Width of bridge
sou=2.3; %Speed of non-laden ants
sl=1.9; %Speed of laden ants
al=1; %ant length
pl=0.04; %Proportion that become laden
Tc=900; %Measurement start time (first cross 140s)
T=4500; %Total experiment time, T-Tc=3600 s

mu=0.8; %Rate parameter for Poisson process of leaving leaf/nes
sigma=0.8; %Standard deviation for trucated normal distr of w-entry positions
A=pi/2; %Interaction turning angle

%TIME STEP AND TS SCALED SPEEDS
ts=0.1; %Time step
sou=sou*ts; %Displacement of non-laden ant per ts
sl=sl*ts; %Displacement of laden ant per ts

%INITIATE POLULATION MATRIX, LEAVING TIMES and SEQUENCE COLLECTOR
tN=exprnd(mu); %First leaving nest time
tL=exprnd(mu); %First leaving leaf time
P=[]; %Initiate population matrix. %P(i,:)=[x-coord,y-coord,speed,heading];
C=[]; %to collect sequence of in/out
k=0; %Initiate system time (seconds)
kk=1; %Initiate system time (time steps)

while k<T %While current time k is less than total simulation time T
 
 %---SEND ANTS OUT FROM NEST AND LEAF SOURCE------------
 
    if tN<=k %If ant to be sent out from nest
        wcoord=sigma*randn+2.5; %Enter normally distibuted around middle of bridge
        if wcoord<0
            wcoord=0.1;
        elseif wcoord>5
            wcoord=4.99;
        end
        P=[P;[0.1*rand,wcoord,sou,0]]; %Add particle to population matrix
        tN=tN+exprnd(mu); %Generate next leave nest time
    end

    if tL<=k %If ant to be sent out from leaf source
        if rand<pl %If ant to become laden 
            speed=sl; %set speed of laden
        else
            speed=sou; %set speed of non-laden
        end
        wcoord=sigma*randn+2.5; %Enter normally distibuted around middle of bridge
        if wcoord<0
            wcoord=0.1;
        elseif wcoord>5
            wcoord=4.99;
        end
        P=[P;[L-0.1*rand,wcoord,speed,pi]]; %Add ant to population matrix
        tL=tL+exprnd(mu); %%Generate next leave leaf source time
    end

    
%---REMOVE ANTS REACHING NEST AND LEAFS-----------------------------------

    sP=size(P,1); %Number of ants currently on the bridge

    if sP>1 %If any ants on the bridge
        j=0;
        i=1;
        while i<=sP-j %Go through all ants on the bridge
            if (P(i,4)==0 && P(i,1)>L-0.01) || (P(i,4)==pi && P(i,1)<0.01) %If ant i either arrived at the Leaf source OR arrived at the Nest in this time step
                P=[P(1:i-1,:);P(i+1:sP-j,:)]; %Remove ant i from the population matrix.
                j=j+1;
            end
            i=i+1;
        end
        
     
%---INTERACTION RULES AND POSITIONAL UPDATE-------------------------------
       
        sP=size(P,1); %Number of ants on the bridge after removal
        P=sortrows(P); %Sort by distance from nest
        PP=zeros(sP,2); %Initiate post interactions population matrix
        
        for i=1:sP %For all ants currently on the bridge
            
           %--INTERACTION RULES---
            
            if P(i,4)==0 %If outbound
                if i<sP
                    if P(i+1,1)-P(i,1)>al+2*sou %if no neighbour close in x
                        ang=0;
                    elseif abs(P(i+1,2)-P(i,2))<al/2 %if neighbour close in x and w
                        if P(i+1,3)*P(i+1,4)==pi*sl %if laden close
                            if P(i,2)-P(i+1,2)>0 %if above it
                                ang=A; %turn up
                            else
                                ang=-A; %turn down
                            end
                        elseif P(i+1,3)*P(i+1,4)==pi*sou %if unladen
                                ang=0;
                        else %if outbound (can happen if just turned)
                            if P(i,2)-P(i+1,2)>0 %if above it
                                ang=A; %turn up
                            else
                                ang=-A; %turn down
                            end
                        end
                    else
                        ang=0;
                    end
                else
                    ang=0;
                end
            end
            
            %If inbound
            if P(i,3)*P(i,4)==pi*sou
                if i>1
                    if P(i,1)-P(i-1,1)>al+2*sou %if no neighbour close in x
                        ang=0;
                    elseif abs(P(i,2)-P(i-1,2))<al/2 %If neighbour close in x and w
                        if P(i,4)==pi %if laden or inbound
                            if P(i,2)-P(i-1,2)>0 %if above it
                                ang=-A; %turn up
                            else
                                ang=A; %turn down
                            end
                        else %if outbound
                            if P(i,2)-P(i-1,2)>0 %if above it
                                ang=-A; %turn up
                            else
                                ang=A; %turn down
                            end
                        end      
                    else
                        ang=0;
                    end
                else
                    ang=0;
                end
            end
            
            %If laden
            if P(i,3)*P(i,4)==pi*sl %If laden
                ang=0; %Never turn
            end
            
           %--POSITIONAL UPDATE-----
            
            %Preliminary positions based on interactions
             
             Xprel=P(i,1)+P(i,3)*cos(P(i,4)+ang);
             Yprel=P(i,2)+P(i,3)*sin(P(i,4)+ang);
            
            %No jumping over boundaries
            Si=0;
            if Yprel<0
                PP(i,1)=P(i,1);
                PP(i,2)=0.25;
                Si=1;
            elseif Yprel>w
                PP(i,1)=P(i,1);
                PP(i,2)=w-0.25;
                Si=1;
            end
            if Si==0
                PP(i,1)=Xprel;
                PP(i,2)=Yprel;
            end
            
        end
        
       %--Record ant passing L/2--
        for i=1:size(P,1)
            if k>Tc
                if P(i,1)>L/2 && PP(i,1)<L/2 %If pass the middle of the bridge from right to left (inbound)
                    if P(i,3)*P(i,4)==pi*sou %unladen
                        C=[C,[P(i,2);2]];
                    else %Laden
                        C=[C,[P(i,2);3]];
                    end
                end
                if P(i,1)<L/2 && PP(i,1)>L/2 %If pass middle of bridge from left to right (outbound)
                    C=[C,[P(i,2);1]]; %Outbound
                end
            end
        end
        
        P=[PP,P(:,3:4)]; %Update position
    end
    
%-------PLOTTING---------------------------------------------------------
% if k>Tc
% 
% sP=size(P,1);
%         for r=1:sP
%            if P(r,3)*P(r,4)==0 %outbound
%                 plot(P(r,1),P(r,2),'r.','markersize',10);
%            elseif P(r,3)*P(r,4)==pi*snc %inbound
%                 plot(P(r,1),P(r,2),'b.','markersize',10);
%            else %laden
%                 plot(P(r,1),P(r,2),'k.','markersize',10);
%            end
%            hold on
%         end
%    plot([0,L],[0,0]);
%    plot([0,L],[w,w]);
%    hold off
%    axis([-1 L+1 -1 w+1]);
%    xlabel('X position')
%    ylabel('Y position')
%    axis manual
%          M(kk)=getframe; %makes a movie fram from the plot
% end

    k=k+ts;
    kk=kk+1;

end

    
        
            
            