%{
    This is the formal version of Cambrian Line BFS
    Script will perform automatic search throughout
    the entire 4 regions, seperated by 4 steps.

    step 1: Aberystwyth - Dover Junction 
            (The Cambrian Main Line)
    step 2: areas at Dovey Junction
            (which require 2 RBC search)
    step 3: Cambrian Coast Line
    step 4: rest of the Cambrian Main Line

    whole area:  112420*59248

    Author @Xinnan Lyu

%}
clear 

tic
load('CambrianData.mat')

RBCnum=1;  %initial number

percent=99.8; %this is the minimum coverage allowed
txPower=37; % 43dBm=20Watt 37dBm=5W 40dBm=10W
threshold=-95;

xmin=0;
ymin=0;
xmax=0;
ymax=0;

step1=1;
step2=0;
step3=0;
step4=0;


%% Step 0: Generate LUT to reduce scale

%fprintf('Generating Path Loss LUT.....\n');
%tic
PL_LUT=zeros(1,200000);
RBC_LUT=[0,0];

for i=1:200000
    Train_LUT=[i,0];
    PL_LUT(i)=plain(Train_LUT,RBC_LUT);
end
%timer=toc;
%fprintf('Generation Complete! time=%2.3fs\n',timer);

%% Step 1: Aberystwyth - Dovey Junction
fprintf('Step 1 Start!\n');
xmax=35000;
ymax=1000;

samples=2906;
interval=500;               %sample interval
thresholdDistance=500;      %distance from track

while ymax<15001
    
    fprintf('Finding RBC%2.0f...\n',RBCnum);
    
    finder1=1;
    finder2=0;
    
    while finder1==1 && finder2==0
        Cambrian_1_RBC;
        
        if maxvalue<percent
            finder1=0;
            finder2=1;
            ymax=ymax-100;
        else
            ymax=ymax+1000;
        end
    end
    
    while finder1==0 && finder2==1
        Cambrian_1_RBC;
        
        if maxvalue>percent
            finder2=0;
            ymax=ymax+1000;
        else
            ymax=ymax-100;
        end
    end
        
        RBC(RBCnum,1)=RBCoptimal(resulti,1);
        RBC(RBCnum,2)=RBCoptimal(resulti,2);
        
        fprintf('Optimal RBC site found at x=%4.0f\ty=%4.0f\n\n',RBC(RBCnum,1),RBC(RBCnum,2));
        RBCnum=RBCnum+1;
end

%% Step 2: Dovey Junction Area
fprintf('Step 2 Start!\n');
RBCnum=RBCnum+1;  %This is to make sure 2 new RBC added before running the calculatin loop.

while ymax<25001
    
    fprintf('Finding RBC%2.0f & RBC%2.0f...\n',RBCnum-1,RBCnum);
    
    finder1=1;
    finder2=0;
    
    while finder1==1 && finder2==0
        Cambrian_2_RBC;
        
        if maxvalue<percent
            finder1=0;
            finder2=1;
            ymax=ymax-100;
        else
            ymax=ymax+1000;
        end
    end
    
    while finder1==0 && finder2==1
        Cambrian_2_RBC;
        
        if maxvalue>percent
            finder2=0;
            ymax=ymax+1000;
        else
            ymax=ymax-100;
        end
    end
            
        RBC(RBCnum-1,1)=RBCoptimal(resulti,1);
        RBC(RBCnum-1,2)=RBCoptimal(resulti,2);
        RBC(RBCnum,1)=RBCoptimal(resultj,1);
        RBC(RBCnum,2)=RBCoptimal(resultj,2);
        
        fprintf('Optimal RBC site found at x=%4.0f\ty=%4.0f\n',RBC(RBCnum,1),RBC(RBCnum,2));
        fprintf('Optimal RBC site found at x=%4.0f\ty=%4.0f\n\n',RBC(RBCnum-1,1),RBC(RBCnum-1,2));
        RBCnum=RBCnum+2;
end


%% Step 3: Dovey Junction - Pwillheli
fprintf('Step 3 Start!\n');
RBCnum=RBCnum-1;  %Same as above, only 1 new RBC added.

while ymax<61001
    
    fprintf('Finding RBC%2.0f...\n',RBCnum);
    
    finder1=1;
    finder2=0;
    
    while finder1==1 && finder2==0
        Cambrian_1_RBC;
        
        if maxvalue<percent 
            finder1=0;
            finder2=1;
            ymax=ymax-100;
        elseif ymax<(59248+thresholdDistance)
            ymax=ymax+1000;
        else
            break
        end
    end
    
    while finder1==0 && finder2==1
        Cambrian_1_RBC;
        
        if maxvalue>percent
            finder2=0;
            ymax=ymax+1000;
        elseif ymax<(59248+thresholdDistance)
            ymax=ymax-100;
        else
            break
        end
    end
   
        RBC(RBCnum,1)=RBCoptimal(resulti,1);
        RBC(RBCnum,2)=RBCoptimal(resulti,2);
        
        fprintf('Optimal RBC site found at x=%4.0f\ty=%4.0f\n\n',RBC(RBCnum,1),RBC(RBCnum,2));
        RBCnum=RBCnum+1;
        
        
        if ymax>59248
            break
        end
                
end




%% Step 4: Dovey Junction - Shrewsbury 
fprintf('Step 4 Start!\n');
ymax=59300;


while xmax<113001
    
    fprintf('Finding RBC%2.0f...\n',RBCnum);
    
    finder1=1;
    finder2=0;
    
    while finder1==1 && finder2==0
        Cambrian_1_RBC;
        
        if maxvalue<percent
            finder1=0;
            finder2=1;
            xmax=xmax-900;
        elseif xmax<(112420+thresholdDistance)
            xmax=xmax+1000;
        else
            break
        end
    end
    
    while finder1==0 && finder2==1
        Cambrian_1_RBC;
        
        if maxvalue>percent
            finder2=0;
            xmax=xmax+1000;
        elseif xmax<(113000+thresholdDistance)
            xmax=xmax-100;
        else
            break
        end
    end
    


        RBC(RBCnum,1)=RBCoptimal(resulti,1);
        RBC(RBCnum,2)=RBCoptimal(resulti,2);
        
        fprintf('Optimal RBC site found at x=%4.0f\ty=%4.0f\n\n',RBC(RBCnum,1),RBC(RBCnum,2));
        RBCnum=RBCnum+1;
        
        if xmax>112420
            break
        end
        
        
end

RBCnum=RBCnum-1;
timer=toc;
fprintf('All RBC found! RBCnum=%2.0f\n',RBCnum);
fprintf('Time=%5.1fs\n',timer);