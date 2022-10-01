function trackingAndHomography

w = VideoReader('football2.mp4'); %test.mp4
objectFileReader = vision.VideoFileReader('football2.mp4'); %test.mp4
videoPlayer = vision.VideoPlayer('Position', [580 600 1000 700]);

%objectFrame = objectFileReader('Position', [580 600 1000 700]);

objectFrame = objectFileReader();

figure; 
imshow(objectFrame); 
title('First, define the attacking player');
objectRegion=round(getPosition(imrect));
title('secondly, define the injured player');
objectRegion7=round(getPosition(imrect));
title('thirdly, choose 4 points on the ice');
objectRegion2=round(getPosition(imrect));
objectRegion3=round(getPosition(imrect));
objectRegion4=round(getPosition(imrect));
objectRegion5=round(getPosition(imrect));



%objectImage = insertShape(objectFrame,'Rectangle',objectRegion,'Color','red');
%objectImage = insertShape(objectImage,'Rectangle',objectRegion7,'Color','cyan');
%objectImage = insertShape(objectImage,'Rectangle',objectRegion2,'Color','green');
%objectImage = insertShape(objectImage,'Rectangle',objectRegion3,'Color','black');
%objectImage = insertShape(objectImage,'Rectangle',objectRegion4,'Color','blue');
%objectImage = insertShape(objectImage,'Rectangle',objectRegion5,'Color','yellow');


%figure;
%imshow(objectImage);
%title('Boxes shows object regions')

% Creates a number of corner points in the frame that we are tracking
Points.points = detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion);
Points.points2 = detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion2);
Points.points3 = detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion3);
Points.points4 = detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion4);
Points.points5 = detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion5);
Points.points7 = detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion7);

pointImage = insertMarker(objectFrame,Points.points.Location,'+','Color','red');
pointImage = insertMarker(pointImage,Points.points2.Location,'+','Color','green');
pointImage = insertMarker(pointImage,Points.points3.Location,'+','Color','black');
pointImage = insertMarker(pointImage,Points.points4.Location,'+','Color','blue');
pointImage = insertMarker(pointImage,Points.points5.Location,'+','Color','yellow');
pointImage = insertMarker(pointImage,Points.points7.Location,'+','Color','cyan');

% Show image with points
figure;
imshow(pointImage);
title('Detected interest points');

%% Initialize the trackers
% MaxBidirectionalError is ideally set to 1 but can be higher in order to
% follow the desired regions better. Ideally the error is set to a number
% between 1-3. This error should be set to the same values in the function
% "testpoint2track".
Tracker.tracker1 = vision.PointTracker('MaxBidirectionalError',3);
initialize(Tracker.tracker1,Points.points.Location,objectFrame);
Tracker.tracker2 = vision.PointTracker('MaxBidirectionalError',1);
initialize(Tracker.tracker2,Points.points2.Location,objectFrame);
Tracker.tracker3 = vision.PointTracker('MaxBidirectionalError',1);
initialize(Tracker.tracker3,Points.points3.Location,objectFrame);
Tracker.tracker4 = vision.PointTracker('MaxBidirectionalError',1);
initialize(Tracker.tracker4,Points.points4.Location,objectFrame);
Tracker.tracker5 = vision.PointTracker('MaxBidirectionalError',1);
initialize(Tracker.tracker5,Points.points5.Location,objectFrame);
Tracker.tracker7 = vision.PointTracker('MaxBidirectionalError',3);
initialize(Tracker.tracker7,Points.points7.Location,objectFrame);

i=1;
nrOfframes =0;

%% Track the points in each frame
while ~isDone(objectFileReader)
      frame = objectFileReader();
      nrOfframes = nrOfframes +1; 
      
      %% Object1 human

      [p,Validity.validity] = Tracker.tracker1(frame);
      out = insertMarker(frame,p(Validity.validity, :),'+','Color','red');
      % p gives an array of x- and y-values of the points. Validity shows 
      % if the values of the points are valid or not. If they aren't valid 
      % the points fall out. Markers are inserted  to see which points that
      % are tracked in each frame.
      
      % Save the xy coordinates in array for the attacking player
      XValues.xValues(:,i)=p(:,1);
      YValues.yValues(:,i)=p(:,2);
      
      %% Object2 human
      [p7,Validity.validity7] = Tracker.tracker7(frame);
      % Insert the points that are tracked in the "out" image
      out = insertMarker(out,p7(Validity.validity7, :),'+','Color','cyan');
      
      % Save the xy coordinates in array for the injured player 
      XValues.xValues7(:,i)=p7(:,1);
      YValues.yValues7(:,i)=p7(:,2);   
      %% Object2
      [p2,Validity.validity2] = Tracker.tracker2(frame);
      out = insertMarker(out,p2(Validity.validity2, :),'+','Color','green');
      
      % Save the xy coordinates in array for point 1
      XValues.xValues2(:,i)=p2(:,1);
      YValues.yValues2(:,i)=p2(:,2);
      %% Object3
      [p3,Validity.validity3] = Tracker.tracker3(frame);
      out = insertMarker(out,p3(Validity.validity3, :),'+','Color','black');
      
      % Save the xy coordinates in array for point 2
      XValues.xValues3(:,i)=p3(:,1);
      YValues.yValues3(:,i)=p3(:,2);
      %% Object 4
      [p4,Validity.validity4] = Tracker.tracker4(frame);
      out = insertMarker(out,p4(Validity.validity4, :),'+','Color','blue');
      
      % Save the xy coordinates in array for point 3
      XValues.xValues4(:,i)=p4(:,1);
      YValues.yValues4(:,i)=p4(:,2);
      %% Object 5
      [p5,Validity.validity5] = Tracker.tracker5(frame);
      out = insertMarker(out,p5(Validity.validity5, :),'+','Color','yellow');
      
      % Save the xy coordinates in array for point 4
      XValues.xValues5(:,i)=p5(:,1);
      YValues.yValues5(:,i)=p5(:,2);
   
      %% Show video
      i=i+1;     
      videoPlayer(out)
end
%% Create a folder with images of the video
% this since you need to insert some points in some of the images in the
% video sequence.
 OutVideoDir = sprintf('Movie_Frames');
 
 % Create the folder if it doesn't exist already.
if ~exist(OutVideoDir, 'dir')
    mkdir Movie_Frames;
end
    for i = 1:nrOfframes
        img = read(w,i);
        baseFileName = sprintf('%d.jpg', i); % e.g. "1.jpg"
        
        fullFileName = fullfile(OutVideoDir, baseFileName); 
        imwrite(img, fullFileName);
    end
   




[Point2track] =point2track2(out,Validity,nrOfframes,XValues, YValues);

[ZLength,Posmatrix]=homography2(w,Point2track, XValues, YValues,nrOfframes);
end
