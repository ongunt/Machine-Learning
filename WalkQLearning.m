function [s_sequence] = WalkQLearning( initial_state )
% initial_state=8

eps = 0.3;
iter = 60000;      
alpha = 0.8;        
gamma = 0.95;     


greedy = true;
if(greedy)
else
    eps = 0;
end

s_show = initial_state;
Q = zeros(16,4);
policy_v = zeros(16,1);

% Calculate policy
for j=1:iter
    if rand()<1-eps
        rew=-inf;
        for act=1:4
            
reward_robot = [ 0 0 0 0; 0 1 -1 0; 0 -1 -1 -1; 0 0 0 0; 
               -1 -1 0 1;0 0 0 0;0 0 0 0;-1 1 0 0;
               -1 -1 0 -1; 0 0 0 0; 0 0 0 0; -1 0 0 0;
                  0 0 0 0;0 0 -1 1; 0 -1 -1 1; 0 0 0 0];


delta_robot = [2 4 5 13; 1 3 6 14; 4 2 7 15; 3 1 8 16;
         6 8 1 9 ; 5 7 2 10; 8 6 3 11; 7 5 4 12;
         10 12 13 5; 9 11 14 6; 12 10 15 7; 11 9 16 8;
         14 16 9 1; 13 15 10 2; 16 14 11 3; 15 13 12 4];
        

new_s = delta_robot(initial_state, act);
new_reward= reward_robot(initial_state, act);
            
            
            
            if new_reward>rew
                action = act;
            end
        end
        Q(initial_state,action)=Q(initial_state,action)+alpha*(new_reward+gamma*max(Q(new_s,:))-Q(initial_state,action));

        
    else       
        action = ceil(rand()*4);                   
reward_robot = [ 0 0 0 0; 0 1 -1 0; 0 -1 -1 -1; 0 0 0 0; 
               -1 -1 0 1;0 0 0 0;0 0 0 0;-1 1 0 0;
               -1 -1 0 -1; 0 0 0 0; 0 0 0 0; -1 0 0 0;
                  0 0 0 0;0 0 -1 1; 0 -1 -1 1; 0 0 0 0];


delta_robot = [2 4 5 13; 1 3 6 14; 4 2 7 15; 3 1 8 16;
         6 8 1 9 ; 5 7 2 10; 8 6 3 11; 7 5 4 12;
         10 12 13 5; 9 11 14 6; 12 10 15 7; 11 9 16 8;
         14 16 9 1; 13 15 10 2; 16 14 11 3; 15 13 12 4];
        
        
        
new_s = delta_robot(initial_state, action);
rew= reward_robot(initial_state, action);
        
        
      new_q=alpha*(rew+gamma*max(Q(new_s,:))-Q(initial_state,action));
        Q(initial_state,action)=Q(initial_state,action)+new_q;
 
            end
    initial_state = new_s;
end
% Policy
for i=1:16
    [a,policy_v(i)]=max(Q(i,:));
end
policy_v'


s_sequence = zeros(16,1);

for i = 1:16
   if i==1
     s_sequence(i) = s_show;  
   else
reward_robot = [ 0 0 0 0; 0 1 -1 0; 0 -1 -1 -1; 0 0 0 0; 
               -1 -1 0 1;0 0 0 0;0 0 0 0;-1 1 0 0;
               -1 -1 0 -1; 0 0 0 0; 0 0 0 0; -1 0 0 0;
                  0 0 0 0;0 0 -1 1; 0 -1 -1 1; 0 0 0 0];


delta_robot = [2 4 5 13; 1 3 6 14; 4 2 7 15; 3 1 8 16;
         6 8 1 9 ; 5 7 2 10; 8 6 3 11; 7 5 4 12;
         10 12 13 5; 9 11 14 6; 12 10 15 7; 11 9 16 8;
         14 16 9 1; 13 15 10 2; 16 14 11 3; 15 13 12 4];
        

s_sequence(i) = delta_robot(s_sequence(i-1), policy_v(s_sequence(i-1)));
   end
end  
    
   

figure
walkshow(s_sequence')
title(strcat("WalkQLearning with Starting State ",num2str(initial_state)));
end

