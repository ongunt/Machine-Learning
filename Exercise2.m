function [Results, mle] = Exercise2()

ObsM = load('Test.txt');
TransM = load('A.txt');   
EmisM= load('B.txt')';    
InitM = load('pi.txt');  

K = size(TransM,1);       
[O,P] = size(ObsM);               

mle=[];
th=-115;
for r = 1:P
    for i = 1:K             
        alpha(1,i) = InitM(i) * EmisM(i,ObsM(1,r));
    end
    for t = 1:(O-1)       
        for j=1:K  
            sub=sum(alpha(t,:)*TransM(:,j));
            alpha(t+1,j) = sub * EmisM(j,ObsM(t+1,r));
        end
    end
    mle=[mle;  log(sum(alpha(O,:)))];   
   
end


mle

Results = repmat('gesture2',P,1);
Results(mle>th,:) = repmat('gesture1',sum(mle>th),1);

end