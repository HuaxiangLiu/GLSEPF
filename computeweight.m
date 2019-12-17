function [w1,w2] = computeweight(Img,rad)
if size(Img,3)>1
    Img = rgb2gray(Img);
end

img=double(Img);
[m,n]=size(img);
lvar = 0;
for x=1:m
    for y=1:n
        xneg = n-rad; xpos = n+rad;      %get subscripts for local regions
        yneg = m-rad; ypos = m+rad;
        xneg(xneg<1)=1; yneg(yneg<1)=1;  %check bounds
        xpos(xpos>n)=n; ypos(ypos>m)=m;          
        lwc = Img(yneg:ypos,xneg:xpos);        
        lvar =lvar+ var(lwc(:));      
    end
end

a1=var(img(:)); % image variance
w1 = a1/(a1+lvar);
w2 = lvar/(a1+lvar);
end