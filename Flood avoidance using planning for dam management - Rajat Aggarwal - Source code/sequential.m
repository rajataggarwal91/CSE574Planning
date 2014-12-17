% This method will be slower as we are moving sequentially checking one by one
  %There will also be some invalid nodes that we will be decoding. Time and space goes
  %exponentially higher with every new iteration.

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Approach 1: Sequential access of traversing nodes
    %All the nodes are traversed, their children are calculated and
    %assigned IDs. No cost heuristics are involved.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function sfullaction = sequential(levelnode,timelimit,damcount,A,dam)

%Creating action space tree now,
id = 2;
sfullaction = [];
            
ssolutionflag = 0;
  while id<((2^damcount)^timelimit) - 1 %just looping to increase id
            % i represents level
         for j =1: 2^damcount % j defines the number of the present node [1-32]
            levelnode(id).id = id;
            levelnode(id).parent = floor(id /(2^damcount)+1);
            levelnode(id).action = A(j,:);
              for c = 1 : 2^damcount
                 levelnode(id).children(c)= [(id * (2^(damcount) ) + c) - 2^damcount]; %id for children = (2^damcount)
              end;
             for k = 1 : damcount % denotes the dam in actionnode [ 5 9 8 10<-]
               levelnode(id).levels(k) = levelnode(levelnode(id).parent).levels(k) - A(j,k) * dam(k).outflow + A(j,(dam(k).lparent)) * dam(k).linflow;
                   if (~isnan(dam(k).rparent))
               levelnode(id).levels(k) = levelnode(id).levels(k) + A(c,(dam(k).rparent)) * dam(k).rinflow;
             end;
         end;            
            
         %check for overflow
         if (overflow_check(id,levelnode,timelimit,damcount,A,dam) == 1)
             continue;
         end;
             
             
             
             
             
             levelnode(id).cost = calculate_difference(levelnode(id).levels,damcount,dam);
            if (levelnode(id).cost) == 0
                     ssolutionflag = 1;
                     display('Found a solution');
                     path = find_path(id,damcount,levelnode);
                     display(path);
                     sfullaction = [];
                       for q = 1 : size(path,2)
                          sfullaction = [sfullaction ; levelnode(path(q)).action];
                       end;
                     return;
              end;
         id = id+1;   
         end;
      
  end;
 
  return;     
  