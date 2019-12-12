% MATLAB Code for Project: WiFi based Through Wall Imaging
% Code written by Anantha Krishnan R and Shashank Yeole
% Input route values to vectors a1, b1, c1, d1 for four routes
% and run code.
% Images are saved in MATLAB/bin


clear;
close all;
clc;

%input('Enter Route0 Orientation 0 Values');
a1 = [27 27 27 27 54 54 27 27 27 27];

%input('Enter Route1 Orientation 90  Values');
b1 = [27 27 27 27 54 54 27 27 27 27];

%input('Enter Route2 Orientation 180  Values');
c1 = [27 27 27 27 54 54 27 27 27 27];

%input('Enter Route3 Orientation 270  Values');
d1 = [27 27 27 27 54 54 27 27 27 27];

for j=1:numel(a1)
    if a1(j)>=25 && a1(j)<30
        ax(j)=1;   
    elseif a1(j)>=30 && a1(j)<35
        ax(j)=2;
    elseif a1(j)>=35 && a1(j)<40
        ax(j)=3;
    elseif a1(j)>=40 && a1(j)<45
        ax(j)=4;
    elseif a1(j)>=45 && a1(j)<50
        ax(j)=6;
    elseif a1(j)>=50 && a1(j)<55
        ax(j)=7;
    elseif a1(j)>=55 && a1(j)<60
        ax(j)=8;
    elseif a1(j)>=60 && a1(j)<65
        ax(j)=9;
    else
        ax(j)=10;
    end
end

        
for j=1:numel(b1)
    if b1(j)>=25 && b1(j)<30
        bx(j)=1;   
    elseif b1(j)>=30 && b1(j)<35
        bx(j)=2;
    elseif b1(j)>=35 && b1(j)<40
        bx(j)=3;
    elseif b1(j)>=40 && b1(j)<45
        bx(j)=4;
    elseif b1(j)>=45 && b1(j)<50
        bx(j)=6;
    elseif b1(j)>=50 && b1(j)<55
        bx(j)=7;
    elseif b1(j)>=55 && b1(j)<60
        bx(j)=8;
    elseif b1(j)>=60 && b1(j)<65
        bx(j)=9;
    else
        bx(j)=10;
    end
end

        
for j=1:numel(c1)
    if c1(j)>=25 && c1(j)<30
        cx(j)=1;   
    elseif c1(j)>=30 && c1(j)<35
        cx(j)=2;
    elseif c1(j)>=35 && c1(j)<40
        cx(j)=3;
    elseif c1(j)>=40 && c1(j)<45
        cx(j)=4;
    elseif c1(j)>=45 && c1(j)<50
        cx(j)=6;
    elseif c1(j)>=50 && c1(j)<55
        cx(j)=7;
    elseif c1(j)>=55 && c1(j)<60
        cx(j)=8;
    elseif c1(j)>=60 && c1(j)<65
        cx(j)=9;
    else
        cx(j)=10;
    end
end


for j=1:numel(d1)
    if d1(j)>=25 && d1(j)<30
        dx(j)=1;   
    elseif d1(j)>=30 && d1(j)<35
        dx(j)=2;
    elseif d1(j)>=35 && d1(j)<40
        dx(j)=3;
    elseif d1(j)>=40 && d1(j)<45
        dx(j)=4;
    elseif d1(j)>=45 && d1(j)<50
        dx(j)=6;
    elseif d1(j)>=50 && d1(j)<55
        dx(j)=7;
    elseif d1(j)>=55 && d1(j)<60
        dx(j)=8;
    elseif d1(j)>=60 && d1(j)<65
        dx(j)=9;
    else
        dx(j)=10;
    end
end


% ax = a1/7; 
% bx = b1/7;
% cx = c1/7;
% dx = d1/7;

x  = [ax bx cx dx];
ux = sort(unique(x));


r = [0 1 1 0 1 0 1 .5 0 0.5]
g = [0 0 1 0 0 1 1 0 0.5 1]
b = [0 1 0 1 1 1 1 0 0 0]


tot = size(ax,2);
bt = 10;
ay = 10 ;
by = 10 + tot*10;
for i=1:tot
    h = find(ux == ax(i));
    at = bt;
    bt = at + 10;
    x = [at at bt bt at]; 
    y = [ay by by ay ay];
    fill(x,y,[r(h) b(h) g(h)], 'LineWidth',1);
    hold on 
end
ax = gca
ax.Visible = 'off'
axis([0  20+tot*10 0 20+tot*10])
Frame = getframe(gca)
FrameData = Frame.cdata;
or0=imresize(FrameData,[800 800],'lanczos3');
imwrite(or0,'route0_Orient0.png');


bt = 10;
ay = 10 ;
by = 10 + tot*10;
for i=1:tot
    h = find(ux == bx(i));
    at = bt;
    bt = at + 10;
    x = [at at bt bt at]; 
    y = [ay by by ay ay];
    fill(x,y,[r(h) b(h) g(h)], 'LineWidth',1);
    hold on 
end
ax = gca
ax.Visible = 'off'
axis([0  20+tot*10 0 20+tot*10])
Frame = getframe(gca)
FrameData = Frame.cdata;
or90=imresize(FrameData,[800 800],'lanczos3');
or90 = imrotate(or90,90);
imwrite(or90,'route1_Orient90.png');


bt = 10;
ay = 10 ;
by = 10 + tot*10;
for i=1:tot
    h = find(ux == cx(i));
    at = bt;
    bt = at + 10;
    x = [at at bt bt at]; 
    y = [ay by by ay ay];
    fill(x,y,[r(h) b(h) g(h)], 'LineWidth',1);
    hold on 
end
ax = gca
ax.Visible = 'off'
axis([0  20+tot*10 0 20+tot*10])
Frame = getframe(gca)
FrameData = Frame.cdata;
or180=imresize(FrameData,[800 800],'lanczos3');
or180 = imrotate(or180,180);
imwrite(or180,'route2_Orient180.png');


bt = 10;
ay = 10 ;
by = 10 + tot*10;
for i=1:tot
    h = find(ux == dx(i));
    at = bt;
    bt = at + 10;
    x = [at at bt bt at]; 
    y = [ay by by ay ay];
    fill(x,y,[r(h) b(h) g(h)], 'LineWidth',1);
    hold on 
end
ax = gca
ax.Visible = 'off'
axis([0  20+tot*10 0 20+tot*10])
Frame = getframe(gca)
FrameData = Frame.cdata;
or270=imresize(FrameData,[800 800],'lanczos3');
or270 = imrotate(or270,270);
imwrite(or270,'route3_Orient270.png');


%BackGround 
hold on 
ax = gca
ax.Visible = 'off'
axis([0  20+tot*10 0 20+tot*10])
x = [10 10 10+tot*10 10+tot*10 10]; 
y = [10 10+tot*10 10+tot*10 10 10];
fill(x,y,'b');
Frame = getframe(gca)
FrameData = Frame.cdata;
background=imresize(FrameData,[800 800],'lanczos3');
imwrite(background,'background.png');
bck = im2bw(background);


%Square Boundary Area
figure
hold on 
ax = gca
ax.Visible = 'off'
axis([0  20+tot*10 0 20+tot*10])
x = [10 10 10+tot*10 10+tot*10 10]; 
y = [10 10+tot*10 10+tot*10 10 10];
plot(x,y,'b', 'LineWidth',1);
Frame = getframe(gca)
FrameData = Frame.cdata;
area=imresize(FrameData,[800 800],'lanczos3');
imwrite(area,'area.png');
area = im2bw(area);


%Calculate ROI
w1 = ~im2bw(or0);
w2 = ~im2bw(or90);
w3 = ~im2bw(or180);
w4 = ~im2bw(or270);
w = w1+w2+w3+w4;


%Colorview of ROI calculation
figure;
axis([0 800 0 800]);
ax = gca
ax.Visible = 'off'
hold on 

imagesc(w)
Frame = getframe(gca)
FrameData = Frame.cdata;
roi = imresize(FrameData,[800 800],'lanczos3');
close all;
imshow(roi)
imwrite(roi,'color_roi.png');

% %Grayscale of ROI
gw=imread('color_roi.png')
roi_g=rgb2gray(gw);
imshow(roi_g)
imwrite(roi_g,'gray_roi.png');


%B&W ROI
figure;
extracted_roi = ((~area + w));
extracted_roi2 = flipdim(extracted_roi,1);
imwrite(extracted_roi2,'threshold_roi.png');
imshow(extracted_roi2);
