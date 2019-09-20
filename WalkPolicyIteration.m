
function [policy, iter] = WalkPolicyIteration(initial_state)
% initial_state=8

gamma = 0.94;

delta = [2 4 5 13; 
    1 3 6 14;
    4 2 7 15;
    3 1 8 16;
    6 8 1 9 ;
    5 7 2 10;
    8 6 3 11;
    7 5 4 12;
    10 12 13 5;
    9 11 14 6;
    12 10 15 7;
    11 9 16 8;
    14 16 9 1;
    13 15 10 2;
    16 14 11 3;
    15 13 12 4];

rew = [ 0 0 0 0;
    0 1 -1 0;
    0 -1 -1 -1;
    0 0 0, 0;
    -1 -1 0 1;
    0 0 0 0;
    0 0 0 0;
    -1 1 0 0;
    -1 -1 0 -1;
    0 0 0 0;
    0 0 0 0;
    -1 0 0 0;
    0 0 0 0;
    0 0 -1 1;
    0 -1 -1 1;
    0 0 0 0];

policy = ceil(rand(16,1)*4);
ex_pol = policy;


iter = 0;
while(true)
    iter = iter + 1;
    
    b1 = [];
    b2 = eye(16);
    for s = 1:16       
        b1 =[b1; rew(s, policy(s))];        
        b2(s,delta(s,policy(s))) = -gamma;
    end
    Value = b2\b1;
    
    
    for s = 1:16
        V_th = -inf;
        for j = 1:4       
            if(rew(s,j) + gamma * Value(delta(s,j)) > V_th)
                policy(s) = j;
                V_th = rew(s,j) + gamma * Value(delta(s,j));
            end
        end
    end
    
   
    if(~all(ex_pol == policy))
    else
        break;
    end
    ex_pol = policy;
end



 
% s_sequence=[initial_state];
% s_sub=[];
% s_sequence=[initial_state];
% for cout = 2:16
%     
%   
% end
 s_sequence = zeros(16,1);
for cout = 1:16
   
    if cout==1   
     s_sequence(cout) = initial_state;
    elseif cout==2
     s_sequence(cout) = delta(initial_state,policy(initial_state));
    else
     s_sequence(cout) = delta(s_sequence(cout-1),policy(s_sequence(cout-1)));

end
end

figure
walkshow(s_sequence.');
title(strcat("WalkPolicyIteration with Starting State ", num2str(initial_state)));
end