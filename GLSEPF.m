%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo of "Fuzzy region-based active contours driven by hybrid fitting 
% energy with edge local entropy for image segmentation" submiting to
% IEEE Access
% Huaxiang Liu
% East China University of Technology&&Central South University, Changsha, 
% China
% 18th, Dec, 2019
% Email: felicia_liu@126.com
% The parameter lambda1 = 1 lambda2 = 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u,e1,e2] = GLSEPF(lambuda1,lambuda2,Img,u, K,sigma,position)

%%%----computing the gradient of the------------------------------------%%%
   [ux, uy] = gradient(u);    
    Hu=0.5*(1+(2/pi)*atan(u./sigma));    
    DiracU = Dirac(u,sigma);      
    Ku = curvature_central(u);
    
%%%------------------Computing the local energy---------------------------%
    c1 = sum(sum(Img.*(u<0)))/(sum(sum(u<0)));
    c2 = sum(sum(Img.*(u>=0)))/(sum(sum(u>=0)));
%     [c1,c2]=changepixel(c1,c2,position);
    
    ge1= (Img-c1).^2;
    ge2= (Img-c2).^2;

    if c1<c2
       gespf = ge1-ge2;
    else
       gespf = ge2-ge1;
    end   
    maxgspf = max(abs(gespf(:)));
    norspf = gespf./max(abs(gespf(:)));
    globalForce = 10*norspf*(abs(c1-c2).^2);   
%     globalForce = 26*norspf;   
    
%%%------------------Computing the local energy---------------------------%
    [f1, f2] = computelocalregion(Img, K, Hu);
    [f1, f2] = changepixel(f1, f2, position);    
    
    e1=Img.*Img.*imfilter(ones(size(Img)),K,'replicate')-2.*Img.*imfilter(f1,K,'replicate')+imfilter(f1.^2,K,'replicate');
    e2=Img.*Img.*imfilter(ones(size(Img)),K,'replicate')-2.*Img.*imfilter(f2,K,'replicate')+imfilter(f2.^2,K,'replicate');
    
     localForce = (e2-e1);   
     maxlspf = max(abs(localForce(:)));
    
     if maxgspf>maxlspf
         dataForce = lambuda1*globalForce/maxgspf*maxlspf+lambuda2*localForce;
     else
         dataForce = lambuda1*globalForce+lambuda2*localForce/maxlspf*maxgspf;
     end  

    mu = 6.5;
    penalizeTerm = mu*(4*del2(u)-Ku);
    lengthTerm = DiracU.*Ku;
    s= sqrt(ux.^2 + uy.^2);
    u = u + 0.1*(s.*dataForce+penalizeTerm+lengthTerm);
    u = (u >= 0) - ( u< 0);
    G = fspecial('gaussian', 15, 2.5);
    u = conv2(u, G, 'same');

function f = Dirac(x, sigma)
f=(1/2/sigma)*(1+cos(pi*x/sigma));
b = (x<=sigma) & (x>=-sigma);
f = f.*b;

function k = curvature_central(u)
% compute curvature for u with central difference scheme
[ux,uy] = gradient(u);
normDu = sqrt(ux.^2+uy.^2+1e-10);
Nx = ux./normDu;
Ny = uy./normDu;
[nxx,junk] = gradient(Nx);
[junk,nyy] = gradient(Ny);
k = nxx+nyy;

function [f1,f2]=changepixel(f1,f2,position)
if position==0
    f1=min(f1,f2);
    f2=max(f1,f2);
end
if position==1
    f1=max(f1,f2);
    f2=min(f1,f2);
end
