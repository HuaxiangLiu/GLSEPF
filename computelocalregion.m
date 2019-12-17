function [f1,f2] = computelocalregion(Img, Ksigma, Hu)

   KI=conv2(Img,Ksigma,'same');    
   KONE=conv2(ones(size(Img)),Ksigma,'same');
   
   I=Img.*Hu;
   c1=conv2(Hu,Ksigma,'same');
   c2=conv2(I,Ksigma,'same');
   f1=c2./(c1);
   f2=(KI-c2)./(KONE-c1);                                                         
end