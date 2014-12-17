%Project - Flood avoidance using planning for dam control
% By Rajat Aggarwal -
% created for CSE574 - Planning & Learning in AI methods
% Instructor : Prof. Georgios Fainekos 

%Some work to be done later
% As an enhancement, the values of hierarchy and properties can be read
% from an xml file, to be done later.

clc
clear all;


%====================Variable definition=====================
%dam : structure that stores hierarchy of physical dams
%A : binary string of action for each dam {0,1}* 0-closed, 1- open
%damcount : number of dams
%DG : directed graph of hierarchy
%actionnode : state of system after applying action
%timelimit : till what iteration the system works (also = level of actionnode)
%order  : dfs path of dam
%sfullaction : sequence of string returned from BFS search (0:dam closed, 1: dam open, position of string defines the dam starting from dam2 to dam4)
%fullaction : sequence of string returned from greedy search.
%
%temperory variables : a,b,l,i,j,temp
%   
%Dam structure paramters are entered manually at the beginning of planning
%Level = Present value of water level when the planning is started.
%Inflow = Rate at which water level is increasing from  parent dams. It is dependent on outflow speed of parent dams. 
%Outflow = Rate at which water gets released when dam gates are opened. Outflow is not dependent on inflow.
%limit = upper hard constraint on level of water in dam.
%Id = Just an identifier for each dam

%mountain node/root node for problem [always gates on]
dam.level = 5;
dam.safe = [0 1 2 3 ]; % this might or might not be of geological interest, it is not matched in our test for solution
dam.linflow=4.0;
dam.outflow=4.0;
dam.id = 1;

dam(2).level = 8;
dam(2).safe = [ 10 11];
dam(2).linflow = 1.0; %needs to be entered
dam(2).outflow = 2.0;
dam(2).limit = 14;
dam(2).id = 2;

dam(3).level = 4;
dam(3).safe = [ 4 5];
dam(3).linflow = 2.0; %needs to be entered
dam(3).outflow = 3.0;
dam(3).limit = 8;
dam(3).id = 3;

dam(4).level = 8;
dam(4).safe = [7 8 9];
dam(4).linflow = 2.0;
dam(4).rinflow = 3.0
dam(4).outflow = 3.0;
dam(4).limit = 10;
dam(4).id = 4;

%sea is the leaf node for every leaf node present
%we dont care about sea level for this project.
dam(5).level = 10000
dam(5).limit = 1000000;
dam(5).linflow = 0.0;
dam(5).outflow = 0.0; %evaporation but actually we dont care
dam(5).id=5;

%Create a structure defining river flows.
%for this project we assuming that a river can have atmost two child or
%parent. As there can be more than one parent, this will be a graph.
%There is only one exception in this graph, water cannot flow backward, so
%not only this graph is directional but, there cannot be any cycle.
dam(1).lparent = 1; %structurally incorrect but will help in implementation
dam(1).rparent = NaN;
dam(1).lchild = 2;
dam(1).rchild = 3;

dam(2).lparent = 1;
dam(2).rparent = NaN;
dam(2).lchild = 4;
dam(2).rchild = NaN;


dam(3).lparent = 1;
dam(3).rparent = NaN;
dam(3).lchild = 4;
dam(3).rchild = NaN;


dam(4).lparent = 2;
dam(4).rparent = 3;
dam(4).lchild = 5;
dam(4).rchild = NaN;

dam(5).lparent = 4;
dam(5).rparent = NaN;
dam(5).lchild = NaN;
dam(5).rchild = NaN;

damcount = size(dam,2); %removing mountain node from count.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculating inflow rate of each dam according to hierarchy
for i = 2 : damcount
    if ~isnan(dam(i).lparent)
      if isnan(dam(dam(i).lparent).lchild) || isnan(dam(dam(i).lparent).rchild) %dont change value of 1 parent 2 child node system.
        dam(i).linflow = dam(dam(i).lparent).outflow;
      end;
       end;
    if ~isnan(dam(i).rparent)
      if isnan(dam(dam(i).rparent).lchild) || isnan(dam(dam(i).rparent).rchild) %dont change value of 1 parent 2 child node system.
        dam(i).rinflow = dam(dam(i).rparent).outflow;
        
      end;
   end;
end;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    %Now we have tree of structure, we need to create action-space search tree
    %for all the water level starting from 0-10 on every dam.
    %So we also might have nodes with water level {-ve,0-10, >l1}* but
    %these will be eradicated later.
    timelimit = 3; %defines time interval, t=1 will be represented by level 1 of tree
    b = repmat ([0,1],damcount);
    a = b(1,:);
    %a(:,1) = 1; %mountain node with always water on.
    A = unique(combnk(a(1,:),damcount),'rows');
    %A(:,1) = 1;
    %A = unique(A,'rows');
    A(:,1)=1; %Mountains always provide water,no obstacles.
    %'A' : binary string of action{open/closed}created
         
    
    %Initializing root levelnode (common for both the methods)
    levelnode(1).id = 1;
    levelnode(1).children = [2:33];
    for temp = 1 : damcount
        levelnode(1).levels(temp) = dam(temp).level;
    end;

    tic;
    %Calling sequentual
    sfullaction = sequential(levelnode,timelimit,damcount,A,dam)
    display(sfullaction(:,2:damcount-1));
    toc
    
    
    tic;
     %Calling hill_climbing
     fullaction = hill_climbing(levelnode,timelimit,damcount,A,dam);
     display(fullaction(:,2:damcount-1));
    toc;