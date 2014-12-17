function ov_check = overflow_check(id,levelnode,timelimit,damcount,A,dam)

ov_check = 0;
for k = 1: damcount
    if levelnode(id).levels(k) > dam(k).limit
        ov_check = 1;
        return;
    end;
end;

return;
        