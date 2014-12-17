function fullaction =    hill_climbing(levelnode,timelimit,damcount,A,dam)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Approach 2 : Greedy search - Hill Climbing%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        solutionflag = 0;
        mininode = 1;
        fullaction = [];
        for i =1:timelimit %level of tree
            root = mininode;
            id = root;
            mini = 1000;
            %expanded only for the intersted child node (root)
           for c = 1 : 2^damcount
                 levelnode(id).children(c)= [(id * (2^(damcount) ) + c) - 2^damcount]; %id for children = (2^damcount)
                 levelnode(levelnode(id).children(c)).id = [(id * (2^(damcount) ) + c) - 2^damcount];
                 levelnode(levelnode(id).children(c)).parent = id;
                 levelnode(levelnode(id).children(c)).action = A(c,:);
           end;
               
           
           %calculate levelnode.levels of each child
           for c = 1 : 2^damcount % represents the levelnode [1-32]
               id = levelnode(root).children(c); 
               for k =1 : damcount  % represent damno.
               
               %levelnode of children
                   levelnode(id).levels(k) = levelnode(levelnode(id).parent).levels(k) - A(c,k) * dam(k).outflow + A(c,(dam(k).lparent)) * dam(k).linflow;
               if (~isnan(dam(k).rparent))
                   levelnode(id).levels(k) = levelnode(id).levels(k) + A(c,(dam(k).rparent)) * dam(k).rinflow;
               end;
               end;
               
                levelnode(id).cost = calculate_difference(levelnode(id).levels,damcount,dam);
                 
                %overflow check
                if (overflow_check(id,levelnode,timelimit,damcount,A,dam) == 1)
                        levelnode(id).cost = 100000; %infinity
                 end;
             
                if (levelnode(id).cost) == 0
                     solutionflag = 1;
                     display('Found a solution');
                     path = find_path(id,damcount,levelnode);
                     display(path);
                     fullaction = [];
                       for q = 1 : size(path,2)
                          fullaction = [fullaction ; levelnode(path(q)).action];
                       end;
                       %display(fullaction);
                     return;
                  end;
                if levelnode(id).cost<mini
                    mini = levelnode(id).cost;
                    mininode = id;
                end;
           end;
           
        end;
        
        if solutionflag ==0
            display('No solution found');
        end;
        
    return;