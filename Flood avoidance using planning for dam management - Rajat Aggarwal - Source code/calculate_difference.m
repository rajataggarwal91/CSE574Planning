  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
 %Now we start designing our heurisitics for the action nodes. The lesser
 %there is difference between the present levelnode and the goal state
 %range, the more chances of that node to be traversed.
 % Cost = summation(for every dam)[abs(Goal state - levelnode)]
 %.We design child nodes and traverse only the ones which gives us the least
 %cost. 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = calculate_difference(levelnode_levels,damcount,dam)
mini(2:damcount-1) = 10000; %inf
for j = 2 : damcount -1  
       % for every dam traverse the entire safe structure and see which gives
    % the minimum count
    for p = 1 : size(dam(j).safe,2)
      if abs(levelnode_levels(j) - dam(j).safe(p)) < mini(j)
        mini(j) = abs(levelnode_levels(j) - dam(j).safe(p));
      end;
    end;
end;
    
 X = sum(mini);
return; 



%  %This matches the actionnode with combination of safe nodes  
%  for l =2:timelimit
%        for i =1 : 2^damcount-1
%           solutionflag = 0;
%           equalflag = 1; 
%            for j = 2 : damcount - 1
%                display(actionnode(l,i,j));
%                if ~ismember(actionnode(l,i,j),dam(j).safe)
%                    equalflag = 0;
%                end;
%           end; 
%                
%                if equalflag == 1
%                    display(l);
%                    display(i);
%                    input('found the solution');
%                    
%             end;
%        end;
%  end;
 
        






