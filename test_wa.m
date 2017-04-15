clc;

%testing array and loops
% %a=zeros(2,3);
% for i=1:2
%     for j=1:3
%         a(i,j)=1;
%     end
% end
% a

f1=imread('cameraman.tif')
%imshow(f)
%get number of rows and columns of the image
rows= length(f1(:,1));
columns = length(f1);

%extract a portion of the image%

%x=f(1:100,1:100)

%imshow(x)
a=zeros(rows/2,columns)
b=zeros(rows/2,columns)

%columnwise 1d dwt
for i=1:columns
    [ca,ch]=dwt(f1(:,i)','haar');
    a(:,i)=ca';
    b(:,i)=ch';
end
%imshow(b,[])

%upper branch
c=zeros(rows/2,columns/2)
d=zeros(rows/2,columns/2)

%row wise 1d dwt
for i=1:rows/2
    [ca,ch]=dwt(a(i,:),'haar')
    c(i,:)=ca
    d(i,:)=ch
end

%lower branch
e=zeros(rows/2,columns/2)
f=zeros(rows/2,columns/2)

for i=1:rows/2
    [ca,ch]=dwt(b(i,:),'haar')
    e(i,:)=ca
    f(i,:)=ch
end


subplot(1,5,1), imshow(c,[]) , title('approximation')
subplot(1,5,2), imshow(d,[]), title('horizontal detail')
subplot(1,5,3), imshow(e,[]), title('vertical detail')
subplot(1,5,4), imshow(f,[]), title('diagonal detail')
subplot(1,5,5), imshow(f1,[]), title('original image')    
    
    
    
