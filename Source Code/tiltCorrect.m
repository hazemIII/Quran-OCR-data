%%%%%%%%%%%%%%%%%%%%%%%    Tilt Correct   %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%    inputs: Binary Image
%%%%%%%%%%%%%%%%%%%%%%%    output: Binary Image
%%%%%%%%%%%%%%%%%%%%%%%    note this function do NOT convert to BW !!
%%%%%%%%%%%%%%%%%%%%%%% Input should be black background!!

function outImage = tiltCorrect(inImage)
%check tilt and get the tilt angle if there. 
Angle = regionprops(inImage , 'Orientation' , 'Area');
angle = struct2cell(Angle);
angle = cell2mat(angle(1:2,:));
[maxArea, index]= max(angle(1,:));
while(maxArea > 250000)
angle(1,index)=0;
[maxArea, index]= max(angle(1,:));
end
tilt = angle(2,index);
%tilting back
 if (tilt < 0 ) 
         outImage = imrotate(inImage , -1*(tilt+90));
 else if (tilt > 0 ) 
         outImage = imrotate(inImage , -1*(tilt-90));
     end
 end
outImage = ~ outImage;
