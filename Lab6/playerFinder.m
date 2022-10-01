function playerFinder
workingDir = 'C:\Users\coziz\Downloads\Lab6-20220928T084142Z-001\Lab6';

video = VideoReader('football2.mp4');

i = 1;
while(hasFrame(video))   
    img = readFrame(video);
    [bboxes, scores] = detect(detector,img);
    img = insertObjectAnnotation(img,'rectangle', bboxes, scores);
    filename = [sprintf('%03d',i) '.jpg'];
    fullname = fullfile(workingDir, 'images',filename);
    imwrite(img,fullname);
    i=i+1;
end

imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile(workingDir,'football_out.avi'));
outputVideo.FrameRate = video.FrameRate;
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,'images',imageNames{ii}));
   writeVideo(outputVideo,img)
end

close(outputVideo)

footballAvi = VideoReader(fullfile(workingDir,'football_out.avi'));



