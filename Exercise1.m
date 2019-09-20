
function Exercise1()


load('dataGMM.mat');
[d,n] = size(Data);
K = 4;

[centers, gmean] = kmeans(Data',K);
gcov = cell(0);
gpi = zeros(1,K);
for j=1:K
    new_data = Data(:,centers==j)';
    gcov{j} = cov(new_data);
    gpi(j) = sum(centers==j)/n;
end

gmm_loglike(1) = 0;
for counter = 2:100 
    resp = zeros(n,K);
    for j=1:size(Data,2)
         

 
    denominator = 0;
    responsibility = zeros(K,1);
    for l=1:K
          ugd=1 / sqrt((2*pi)^(size(Data(:,j)',2)/2)*det(gcov{l})) * exp(-0.5*(Data(:,j)'-gmean(l,:))*inv(gcov{l})*(Data(:,j)'-gmean(l,:))');
        denominator = denominator + gpi(l)*ugd; 
    end
     
    for s=1:K
    A1 = -0.5*(Data(:,j)'-repmat(gmean(s,:),size(Data(:,j)',1),1))*inv(gcov{s});
    B1 = (Data(:,j)'-repmat(gmean(s,:),size(Data(:,j)',1),1));
    
    ex = sum(bsxfun(@times,A1,B1),2);
   
    mgd= 1 / sqrt((2*pi)^(size(Data(:,j)',2)/2)*det(gcov{s}))*exp(ex);
     
        responsibility(s) = gpi(s)*mgd ./ denominator;
    end
    [~, cluster] = max(responsibility);

    resp(j,:)=responsibility;
    centers(j)=cluster;
        
end

  
    gmean_old = gmean;
    gcov_old = gcov;
    gpi_old = gpi;
    for p=1:K
        nk = sum(resp(:,p));
        gmean(p,:) = 1/nk * resp(:,p)'*Data';
        gcov{p} = 1/nk *(repmat(resp(:,p),1,2).*(Data' - repmat(gmean(p,:)',1,n)'))'*(Data' - repmat(gmean(p,:)',1,n)');
        gpi(p) = nk/n;
    end
   log1 = 0;
    log2 = 0;
    for j=1:n
        for k = 1: K
            ugd2=1 / sqrt((2*pi)^(size(Data(:,j)',2)/2)*det(gcov{k})) * exp(-0.5*(Data(:,j)'-gmean(k,:))*inv(gcov{k})*(Data(:,j)'-gmean(k,:))');

            log2 = log2 + gpi(k) * ugd2;
        end
        log1 = log1 + log(log2);
    end
    gmm_loglike(counter) = log1;
    
    a=log1;
    b=gmm_loglike(counter-1); 

 r1=true;
    tol = 10e-7;
    if(iscell(a))
        for k = 1:size(a,2)
           r1 = r1 && (norm((a{k}-b{k}),2))<tol;
        end
    else
        r1 = r1&& (norm((a-b),2))<tol;
    end
    
    
     r2=true;
    tol = 10e-7;
     a=gmean_old;b=gmean;
    if(iscell(a))
        for k = 1:size(a,2)
           r2 = r2 && (norm((a{k}-b{k}),2))<tol;
        end
    else
        r2 = r2 && (norm((a-b),2))<tol;
    end
    
     r3=true;
    tol = 10e-7;
    a=gcov_old;b=gcov;
    if(iscell(a))
        for k = 1:size(a,2)
           r3 = r3 && (norm((a{k}-b{k}),2))<tol;
        end
    else
        r3 = r3 && (norm((a-b),2))<tol;
    end
    
     r4=true;
    tol = 10e-7;
     a=gpi_old;b=gpi;
    if(iscell(a))
        for k = 1:size(a,2)
           r4 = r4 && (norm((a{k}-b{k}),2))<tol;
        end
    else
        r4 = r4 && (norm((a-b),2))<tol;
    end
    
    
    if r1||r2||r3||r4
        break
    end
    


end
end