function Y=NarrowModel
%Function to simulate traffic on the narrow bridge using the priority
%rules.

%OUTPUT: Cell array Y={sC,C} where C contains the sequence of particles crossing the
%middle of the bridge. For each crossing the heading of the particle (+1 (outbound) or
%-1 (inbound)) and the type of ant (1 (outbound), 2 (unladen), 3 Laden) is
%recorded.

rng('shuffle')

%PARAMETERS FROM THE EXPERIMENTS
L=300; %Length of bridge [cm]
sou=2.3; %Speed of non-laden ants [cm/s]
sl=1.9; %Speed of laden ants [cm/s]
al=1; %Ant length [cm]
p=0.24; %Proportion become laden
Tc=900; %Measurement start time
T=4500; %Total experiment time, T-Tc=3600 s

mu=1; %Rate parameter for Poisson process of leaving leaf/nest

%TIME STEP AND TS SCALED SPEEDS
ts=0.1; %Time step
sou=sou*ts; %Displacement of non-laden ant per ts
sl=sl*ts; %Displacement of laden ant per ts

%INITIATE POLULATION MATRIX, LEAVING TIMES and SEQUENCE COLLECTOR
tN=exprnd(mu); %First leaving nest time
tL=exprnd(mu); %First leaving leaf time
P=[]; %Initiate population matrix. P(i,:)=[x-coord,speed,heading,delay after meeting laden].
C=[]; %to collect sequence of inbound (-1) and outbound (+1) at middle of bridge
k=0; %Time counter
kk=1; %Timestep for plotting
kkx=1; %Timestep for plotting

while k<T %While current time k is less than total simulation time T
    
%---SEND ANTS OUT FROM NEST AND LEAF SOURCE------------
    
    if tN<=k %If ant to be sent out from nest
        P=[P;[0.1*rand,sou,1,0]]; %Add particle to population matrix
        tN=tN+exprnd(mu); %Generate next leave nest time
    end

    if tL<=k %If ant to be sent out from leaf source
        if rand<p %If ant to become laden
            speed=sl; %set speed of laden
        else
            speed=sou; %set speed of non-laden
        end
        P=[P;[L-0.1*rand,speed,-1,0]]; %Add ant to population matrix
        tL=tL+exprnd(mu); %Generate next leave leaf source time
    end
    
%---REMOVE ANTS REACHING NEST AND LEAFS--
  
    sP=size(P,1); %Number of ants currently on the bridge
    
 %   delta=1;
    if sP>1 %If any ants on the bridge
        j=0;
        i=1;
        while i<=sP-j %Go through all ants on the bridge
            if (P(i,3)==1 && P(i,1)>L-0.01) || (P(i,3)==-1 && P(i,1)<0.01) %If ant i either arrived at the Leaf source OR arrived at the Nest in this time step
                P=[P(1:i-1,:);P(i+1:sP-j,:)]; %Remove ant i from the population matrix.
                j=j+1;
            end
            i=i+1;
        end
        
%---INTERACTION RULES AND POSITIONAL UPDATE-------------------------------

        sP=size(P,1); %Number of ants still on the bridge (i.e. did not reach nest or leafs in this time step)
        P=sortrows(P); %Sort by distance from nest
        
        PP=zeros(sP,1); %Initiate post interactions population matrix
        
        for i=1:sP %For all ants currently on the bridge
             
            %OUTBOUND INTERACTIONS
            if P(i,3)==1 %If outbound ant
                
                if i<sP %and not ant closest to the leaf site
                    
                    P(i,4)=P(i,4)-0.1; %reduce waiting time by 1 ts
                    
                    if P(i,4)<0 %If waiting time now negative 
                        P(i,4)=0; %Stop waiting
                    end
                    
                    if P(i+1,1)-P(i,1)>al+2*sou %If no neighbor within interaction range
                            delta=1; %Walk
                    else %If neighbour within interaction range
                        
                        if P(i+1,3)==1 %and it is outbound 
                        
                            delta=0; %Stop
                        
                        elseif P(i+1,2)*P(i+1,3)==-sl %and it is laden
                            
                            %COOPERATIVE RULE (Probabilities of letting X
                            %unladen pass behind a laden from Dussutour et al 2008)
                            
                            r1=rand; %Uniformly distributed random numer in [0,1]
                            if r1<0.012 %With probability 0.012 
                                X=15; %let 15 unladen ants pass after the laden ant
                            elseif r1<0.025
                                X=14;
                            elseif r1<0.037
                                X=13;
                            elseif r1<0.062
                                X=12;
                            elseif r1<0.087
                                X=11;
                            elseif r1<0.087 
                                X=10; %Let 10 pass
                            elseif r1<0.14
                                X=9;
                            elseif r1<0.17
                                X=8;
                            elseif r1<0.22
                                X=7;
                            elseif r1<0.28
                                X=6;
                            elseif r1<0.37 %Let 5 pass
                                X=5;
                            elseif r1<0.48
                                X=4;
                            elseif r1<0.61
                                X=3;
                            elseif r1<0.74
                                X=2;
                            elseif r1<0.99
                                X=1;
                            else
                                X=0; %Let none pass
                            end                                    
                            P(i,4)=X*al; %Wait for X unladen after laden (1 sec=ant)
                            delta=0; %Stop
                            
                        else %and it is inbound unladen
                            
                            if P(i,4)==0 %and not behind laden (So no waiting time)
                                delta=1; %Walk
                            else    
                                delta=0;
                            end
                        end
                    end

                else %If ant closest to leaf site
                    delta=1; %Walk
                end
            end

            %UNLADEN INTERACTIONS
            if P(i,2)*P(i,3)==-sou %If inbound unladen ant
                if i>1 %If not ant closest to the nest
                    if P(i,1)-P(i-1,1)>al+2*sou %if no other ant within interaction range
                        delta=1; %Walk
                    elseif P(i-1,3)==1 %if other ant within interaction range and it is Outbound
                        if P(i-1,4)>0 %and waiting
                            delta=1; %Walk
                        else %and not waiting
                                delta=0; %Stop
                        end
                    else %if ant within interaction range and it is inbound or laden
                        delta=0; %Stop
                    end
                else %If ant closest to the nest
                    delta=1; %Walk
                end  
            end

            %LADEN INTERACTIONS 
            if P(i,2)*P(i,3)==-sl %If laden ant
                if i>1 %and not the inbound ant closest to the nest
                    if P(i,1)-P(i-1,1)>al+2*sou %if no within interaction range
                        delta=1; %Walk
                    elseif P(i-1,2)*P(i-1,3)==-sl %if other laden ant within interaction range
                        delta=0; %Stop
                    elseif P(i-1,2)*P(i-1,3)==-sou %if unladen ant within interaction range
                            delta=1; %Walk
                    else %if outbound within interaction range
                        delta=1; %Walk
                    end
                else %If ant closest to the nest
                    delta=1; %Walk
                end 
            end  

            %Update post interaction position for ant i
            PP(i,1)=P(i,1)+delta*P(i,2).*P(i,3);         
        end
        
        %Record ants that passed the middle of the bridge (x=L/2=150) in this
        %timestep
        for i=1:size(P,1)
            if k>Tc %If warm up period Tc over
                if P(i,1)>L/2 && PP(i,1)<L/2 %If inbound ant (cross middle of bridge from leaf source towards nest)
                    if P(i,2)*P(i,3)==-sou %and it is unladen
                        C=[C,[-1;2]]; %record heading -1 and type 2 (unladen)
                    else %and it is laden
                        C=[C,[-1;3]]; %record heading -1 and type 3 (laden)
                    end
                end
                if P(i,1)<L/2 && PP(i,1)>L/2 %If outbound any (cross bridge middle from nest to leafs)
                    C=[C,[1;1]]; %Record heading +1 and typ 1 (Outbound)
                end
            end
        end
        
        P=[PP,P(:,2:4)]; %Update the population matrix with all post interaction positions of ants on the bridge
    end
    
    
%     %PLOTTING (flow separated into outbound, unladen, laden in animation)
%     if k>Tc
%         kk=kk+1;
%         if mod(kk,10)==0
%             sP=size(P,1);
%             for r=1:sP
%                if P(r,2)*P(r,3)==sou %outbound
%                     plot(P(r,1),0.5,'r.','markersize',10);
%                elseif P(r,2)*P(r,3)==-sou %inbound
%                     plot(P(r,1),0.25,'b.','markersize',10);
%                else %laden
%                     plot(P(r,1),0,'k.','markersize',10);
%                end
%                hold on
%             end
%             hold off
%             axis([-1 L+1 -0.25 0.75]);
%             xlabel('X position')
%             ylabel('Y position')
%             axis manual
%             M(kkx)=getframe; %makes a movie fram from the plot
%              kkx=kkx+1; %Update the discrete time for plotting
%         end
%     end

       
%k
         
    k=k+ts; %Update the time
    
end

sC=size(C,2); %number or recorded bridge middle crossing during the simulation from Tc to T. 

Y={sC,C}; %Return the flow sequence C and the number of elements in the flow sequence sC.
    
        
            
            