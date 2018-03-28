function [text] = knn(binimg,req)

conncomp = bwconncomp(binimg);
per = cell2mat(struct2cell(regionprops(conncomp,'Perimeter')));
[~,D] = knnsearch(req,per');
[~,index] = min(D);
box = regionprops(conncomp,'BoundingBox');
rect = box(index).BoundingBox;
rect = [rect(1)+5 rect(2)+5 rect(3)-10 rect(4)-10] ;
text = ~imcrop(binimg,rect);

end