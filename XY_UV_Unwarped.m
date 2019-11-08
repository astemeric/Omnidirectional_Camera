%Jason Kreitz
%Code to create a panoramic view from a parabolic omnicamera

%Clears any existing variables
clear;
%Bring in picture to matlab
distorted = imread('Good_Res1.jpg');
%Display distorted picture
figure(1)
imshow(distorted);

%Enter in parameters of mirror from distorted image
diameter = 1200;
centerrow = 1135;
centercolumn = 1015;
inner_diameter = 90;
r = round(diameter / 2);

circumference = round(2 * pi * r + 1);

%generate the matrices
undistorted = uint8(zeros(r,circumference,3));
newcolumn_array = uint16(zeros(r,circumference));
newrow_array = uint16(zeros(r,circumference));

%Generate a transformation matrix to u,v
for i = 1:1:r
   for j = 1:1:circumference
   
       %i = ith row of new image
       %j = jth column of new image
       u = round(i * cos(2 * pi * j/circumference));
       v = round(i * sin(2 * pi * j/circumference));
       
       %u = x of old image
       %v = y of old image
       u = centerrow - u;
       v = centercolumn - v;
       
       %disp(i);
       %disp(j);
       %disp(u);
       %disp(v);
       
       newcolumn_array(i, j) = v;
       newrow_array(i, j) = u;
       
       %disp(newcolumn_array(i, j));
       %disp(newrow_array(i,j));
   end
end

%Transform old image to new image
for i = 1:1:r
   for j = 1:1:circumference
   
       newC = newcolumn_array(i, j);
       newR = newrow_array(i, j);
             
        for k = 1:1:3
            undistorted(i, j, k) = distorted(newR,newC,k);
        end 
   end
end

undistorted = flip(undistorted, 1);
transform = [1/2 0 0; 0 1 0; 0 0 1];
t_form = affine2d(transform);
undistorted = imwarp(undistorted, t_form);

%Show undistorted image
figure(2)
imshow(undistorted)