function Exercise3()

iter = zeros(16,1);
for i=1:16
[~, iter(i)] = WalkPolicyIteration(i);
WalkQLearning(i)
end
end
