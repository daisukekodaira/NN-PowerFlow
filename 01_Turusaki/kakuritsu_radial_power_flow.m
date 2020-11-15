%radial power flow
%

clc;
clear all;
tic;

% for N=1:1:10000元はここにあった

global linedata loaddata

%line data of 33 Node Radial Distribution Test System

%      Branch  Sn.   Rc.      Line      Line
%         No   Nd    Nd    Resistance Reactance

linedata =[          1    1      2     0.0922    0.0470   
          2    2      3     0.4930    0.2511    
          3    3      4     0.3660    0.1864  
          4    4      5     0.3811    0.1941    
          4    5      6     0.8190    0.7070    
          6    6      7     0.1872    0.6188   
          7    7      8     0.7114    0.2351 
          8    8      9     1.0300    0.7400   
          9    9      10    1.0440    0.7400   
         10    10     11    0.1966    0.0650   
         11    11     12    0.3744    0.1238   
         12    12     13    1.4680    1.1550   
         13    13     14    0.5416    0.7129   
         14    14     15    0.5910    0.5260    
         15    15     16    0.7463    0.5450   
         16    16     17    1.2890    1.7210   
         17    17     18    0.7320    0.5740  
         18     2     19    0.1640    0.1565    
         19    19     20    1.5042    1.3554  
         20    20     21    0.4095    0.4784   
         21    21     22    0.7089    0.9373    
         22     3     23    0.4512    0.3083    
         23    23     24    0.8980    0.7091  
         24    24     25    0.8960    0.7011   
         25     6     26    0.2030    0.1034   
         26    26     27    0.2842    0.1447    
         27    27     28    1.0590    0.9337    
         28    28     29    0.8042    0.7006   
         29    29     30    0.5075    0.2585  
         30    30     31    0.9744    0.9630   
         31    31     32    0.3105    0.3619   
         32    32     33    0.3410    0.5302];
     
     %Load data of 69 Node Radial Distribution Test System
     
%Bus    -----Load-----    Q
%No.     (kW)   (kVAr)  Injected

loaddata=[  1	0         0  	  0
            2	100       60 	  0
            3	90        40      0  	
            4	120       80	  0  
            5	60        30	  0  
            6	60        20      0 
            7	200       100	  0
            8	200       100	  0 
            9	60        20      0	
            10	60        20 	  0
            11	45        30 	  0
            12	60        35      0 
            13	60        35      0 
            14	120       80      0 
            15	60        10      0 
            16	60        20      0 
            17	60        20      0 
            18	90        40      0 
            19	90        40      0 
            20	90        40      0 
            21	90        40      0
            22	90        40      0 
            23	90        50      0
            24	420       200	  0
            25	420       200	  0
            26	60        25      0  
            27	60        25      0 
            28	60        20      0
            29	120       70      0
            30	200       600	  0
            31	150       70      0  
            32	210       100	  0
            33	60        40      0];

nl=linedata(:,2);% left node = sending node
nr=linedata(:,3);% right node = receiving node
br=length(linedata(:,1));% number of branches 
no=length(loaddata(:,1));% number of buses
MVAb=100;% base MVA
KVb=12.66;% base kV
Zb=(KVb^2)/MVAb;% base impedance

% T1=readtable('P_Data_Of_Buses.csv','ReadRowNames',true);これは1000データの時のコード
% T1=table2array(T1);
% T2=readtable('Q_Data_Of_Buses.csv','ReadRowNames',true);
% T2=table2array(T2);ここまで

T1=readtable('Delta_P_Data_Of_Buses.csv','ReadRowNames',true);
T1=table2array(T1);
T2=readtable('Delta_Q_Data_Of_Buses.csv','ReadRowNames',true);
T2=table2array(T2);

% Per unit Values

%while 1
 %   N=1;

for i=1:br
    R(i,1)=(linedata(i,4))/Zb;
    X(i,1)=(linedata(i,5))/Zb;
end

%N=;

for N=1:1:1000

for i=1:no
    P(i,1)=((T1(i,N))/(1000*MVAb));
    Q(i,1)=((T2(i,N))/(1000*MVAb));
    Qsh(i,1)=((loaddata(i,4))/(1000*MVAb));   
end
    
R;% line resistance
X;% line reactance
j=sqrt(-1);
Z=R+j*X;% line impedance
P;% load active power
Q;% load reactive power
Pt=sum(P);% total active power 
Qt=sum(Q);% total reactive power
C=zeros(br,no);% initilization for zero matrix初期化

%

for i=1:br
    a=linedata(i,2);% left node = sending node
    b=linedata(i,3);% right node = receiving node
    for j=1:no
        if a==j
            C(i,j)=-1;
        end
        if b==j
            C(i,j)=1;
        end
    end
end

C;
e=1;

%

for i=1:no
    d=0;
    for j=1:br
        if C(j,i)==-1
            d=1;
        end
    end
    if d==0
        endnode(e,1)=i;
        e=e+1;
    end
end

endnode;
h=length(endnode);

%

for j=1:h
    e=2;
    
    f=endnode(j,1);
    
   % while (f~=1)
   
   for s=1:no
     if (f~=1)
       k=1;  
       for i=1:br
           if ((C(i,f)==1)&&(k==1))
                f=i;
                k=2;
           end
       end
       k=1;
       for i=1:no
           if ((C(f,i)==-1)&&(k==1))
                f=i;
                g(j,e)=i;
                e=e+1;
                k=3;
           end            
       end
     end
   end
end

%

for i=1:h
    g(i,1)=endnode(i,1);
end

g;
w=length(g(1,:));

%

for i=1:h
    j=1;
    for k=1:no 
        for t=1:w
            if g(i,t)==k
                g(i,t)=g(i,j);
                g(i,j)=k;
                j=j+1;
             end
         end
    end
end

g;

%

for k=1:br
    e=1;
    for i=1:h
        for j=1:w-1
            if (g(i,j)==k) 
                if g(i,j+1)~=0
                    adjb(k,e)=g(i,j+1);            
                    e=e+1;
                else
                    adjb(k,1)=0;
                end
             end
        end
    end
end

adjb;

%

for i=1:br-1
    for j=h:-1:1
        for k=j:-1:2
            if adjb(i,j)==adjb(i,k-1)
                adjb(i,j)=0;
            end
        end
    end
end

adjb;
x=length(adjb(:,1));
ab=length(adjb(1,:));

%

for i=1:x
    for j=1:ab
        if adjb(i,j)==0 && j~=ab
            if adjb(i,j+1)~=0
                adjb(i,j)=adjb(i,j+1);
                adjb(i,j+1)=0;
            end
        end
        if adjb(i,j)~=0
            adjb(i,j)=adjb(i,j)-1;
        end
    end
end

adjb;

%

for i=1:x-1
    for j=1:ab
        adjcb(i,j)=adjb(i+1,j);
    end
end

b=length(adjcb);

% voltage current program

%

for i=1:no
    vb(i,1)=1;
end

for s=1:10
for i=1:no
    nlc(i,1)=conj(complex(P(i,1),Q(i,1)))/(vb(i,1));
end

nlc;

for i=1:br
    Ibr(i,1)=nlc(i+1,1);
end

Ibr;
xy=length(adjcb(1,:));

for i=br-1:-1:1
    for k=1:xy
        if adjcb(i,k)~=0
            u=adjcb(i,k);
            
            %Ibr(i,1)=nlc(i+1,1)+Ibr(k,1);
            
            Ibr(i,1)=Ibr(i,1)+Ibr(u,1);
        end
    end      
end

Ibr;

for i=2:no
      g=0;
      for a=1:b 
          if xy>1
            if adjcb(a,2)==i-1 
                u=adjcb(a,1);
                vb(i,1)=((vb(u,1))-((Ibr(i-1,1))*(complex((R(i-1,1)),X(i-1,1)))));
                g=1;
            end
            if adjcb(a,3)==i-1 
                u=adjcb(a,1);
                vb(i,1)=((vb(u,1))-((Ibr(i-1,1))*(complex((R(i-1,1)),X(i-1,1)))));
                g=1;
            end
          end
        end
        if g==0
            vb(i,1)=((vb(i-1,1))-((Ibr(i-1,1))*(complex((R(i-1,1)),X(i-1,1)))));
        end
end
s=s+1;
end

nlc;
Ibr;
vb;

% vbp=[abs(vb) angle(vb)*180/pi];
% vbp;
% 
toc;
% 
% for i=1:no
%     va(i,2:3)=vbp(i,1:2);
% end
% for i=1:no
%     va(i,1)=i;
% end
% 
% va;


% Ibrp=[abs(Ibr) angle(Ibr)*180/pi];

PL(1,1)=0;
QL(1,1)=0;

% losses

for f=1:br
    Pl(f,1)=(abs(Ibr(f,1))^2)*R(f,1);
    Ql(f,1)=X(f,1)*(abs(Ibr(f,1))^2);
%     Pl(f,1)=(Ibrp(f,1)^2)*R(f,1);
%     Ql(f,1)=X(f,1)*(Ibrp(f,1)^2);
    PL(1,1)=PL(1,1)+Pl(f,1);
    QL(1,1)=QL(1,1)+Ql(f,1);
end

Plosskw=(Pl)*100000;
Qlosskw=(Ql)*100000;
PL=(PL)*100000;
QL=(QL)*100000;

voltage = abs(vb);
Angle = angle(vb);

% voltage = vbp(:,1);
% angle = vbp(:,2)*(pi/180);

for i=1:no
    if i==1
        Pg(i,1)=(Pt*100000)+PL;
        Qg(i,1)=(Qt*100000)+QL;
    else
        Pg(i,1)=0;
        Qg(i,1)=0;
    end
end

%display the power flow results

Vm=voltage';deltad=Angle';Pgen=Pg';Qgen=Qg';Pd=P*100000';Qd=Q*100000';Qinj=Qsh';

Pdt=sum(Pd);Qdt=sum(Qd);Pgent=sum(Pg);Qgent=sum(Qg);Qinjt=sum(Qsh);

n=1:no;

% heading for display results
%{
tech=('                   Radial Distribution Load Flow Solution                       ');
disp(tech)
disp('=============================================================================')
head =['    Bus  Voltage  Angle    ------Load------    ---Substation---   Injected'
       '    No.  Mag.     Degree     kW       kVAr       kW       kVAr       kvar '
       '                                                                          '];
disp(head)
disp('=============================================================================')

% bus information including voltage profile, load profile and substation

for n=1:no
      fprintf(' %5g', n), fprintf(' %7.4f', Vm(n)),
     fprintf(' %8.4f', deltad(n)), fprintf(' %9.4f', Pd(n)),
     fprintf(' %9.4f', Qd(n)),  fprintf(' %10.4f', Pgen(n)),
     fprintf(' %10.4f ', Qgen(n)), fprintf(' %9.4f\n', Qinj(n))
end
disp('=============================================================================') 
    fprintf('      \n'), fprintf('    Total              ')
    fprintf(' %9.4f', Pdt), fprintf(' %9.4f', Qdt),
    fprintf(' %10.4f', Pgent), fprintf(' %10.4f', Qgent), fprintf(' %9.4f\n\n', Qinjt)
disp('=============================================================================') 

% power flow in each branch and losses

SLT = 0;
fprintf('\n')
fprintf('                      Line Flow and Losses \n\n')
disp('=====================================================================') 
fprintf('     --Line--  Power at bus & line flow    --Line loss--\n')
fprintf('     from  to       kW      kVAr            kW      kVAr\n')
disp('=====================================================================') 
for n = 1:no
busprt = 0;
   for L = 1:br % for L = 1:br; になってた 
       if busprt == 0
       fprintf('   \n'), fprintf('%6g', n), fprintf('      %9.4f', Pd(n))
       fprintf('%9.4f\n', Qd(n))
       

       busprt = 1;
       else
       end
       if nl(L)==n     k = nr(L);
       In = (Vm(n) - Vm(k))/Z(L);
       Ik = (Vm(k) - Vm(n))/Z(L);
       Snk = Vm(n)*conj(In)*100000;
       Skn = Vm(k)*conj(Ik)*100000;
       SL  = Snk + Skn;
       SLT = SLT + SL;
       elseif nr(L)==n  k = nl(L);
       In = (Vm(n) - Vm(k))/Z(L);
       Ik = (Vm(k) - Vm(n))/Z(L);
       Snk = Vm(n)*conj(In)*100000;
       Skn = Vm(k)*conj(Ik)*100000;
       SL  = Snk + Skn;
       SLT = SLT + SL;
       else
       end
         if nl(L)==n || nr(L)==n
         fprintf('%12g', k),
         fprintf('%10.4f', real(Snk)), fprintf('%10.4f', imag(Snk)),
         fprintf('%12.4f', real(SL)),
         fprintf('%12.4f\n', imag(SL))
         else
         end
  end
end
disp('=====================================================================') 
In;
Ik;
SLT = SLT/2;
A=SLT;
fprintf('   \n'), fprintf('    Total loss                         ')
fprintf('%12.4f', real(SLT)), fprintf('%12.4f\n', imag(SLT))

clear Ik In SL SLT Skn Snk
%}
% dlmwrite('V_Data_Of_Buses.csv',Vm,'-append');これは1000データの時のコード
% dlmwrite('Delta_Data_Of_Buses.csv',deltad,'-append');ここまで
dlmwrite('Delta_Theta_Data_Of_Buses.csv',Vm,'-append');
dlmwrite('Delta_Epsilon_Data_Of_Buses.csv',deltad,'-append');
%N=N+1;
%if N==1000
%    break;
%end
%end
end