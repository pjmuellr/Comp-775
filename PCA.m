function newPDM = PCA(pdm,eigenvalues,eigenSTDs)
%Perform PCA
newPDM = zeros(size(pdm,1),1);
product = zeros(15,1);
%Apply Eigenvalues and Change if Above or Below 3STD
for i=1:7
    maxstd=3*eigenSTDs(i);
    product(i)=dot(eigenvalues(:,i),pdm);
    if product(i)>maxstd
        product(i)=maxstd;
    else if product(i)<-maxstd
            product(i)=-maxstd;
        end
    end
end
%Create new PDM
for i=1:7
    newPDM=newPDM+product(i)*eigenvalues(:,i);
end
