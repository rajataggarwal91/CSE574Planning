function X = find_path(id,damcount,levelnode)
X = [id];

while id~=1
    id = levelnode(id).parent;
    X = [id X];
    
end;

     
    