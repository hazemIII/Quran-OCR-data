function [ayatAndNumCell] = ayaDetection (count)
  %%%%%%%%%%%%%%Aya Pattern Detection Function %%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%  Binary Cell of Single page %%%%%%%%%%%%%%%
 %%%%%Binary Cell of Two Columns first is Aya second is its Number image %%%%%
 %%%%%%%%%%%%%%%%  Function Description  %%%%%%%%%%%%%%%%
 %%%Function takes page spiltted into lines and detects each pattern of aya number %%%
 %%%It also merges all aya in many lines to one line and saves it in first column and%%%
 %%%It removes the aya pattern from line and put it seperately in second column of %%%
 %%%%%%%%%%%%%%%%%% the Output Cell%%%%%%%%%%%%%%%%%%
 %% Initialize Number of ayas according to the pagecand work on line by line

 lines = [];
 name = strcat('lines/lines (',int2str(count),').mat');
 load(name);
 bwLinesCell = lines;
 sizeCell = max(size(bwLinesCell));
 ayatNum = 1;
 ayaLine = 1;
    for counter = 1:sizeCell
       lineImg = cell2mat(bwLinesCell(1,counter))== 1;              %read one line from the cell page
                   lineImg = bwmorph(lineImg,'open');
       %% Detection of aya pattern
       [lineImgH,lineImgW] = size(lineImg);
       ratio = min(lineImgH/40,lineImgW/389);               %ratio of the current line and our standard line
       filledImage = imfill(lineImg,'holes');
%        f = figure;
%        imshow(lineImg);
       resizedLine = imresize(filledImage ,1/ratio);                %resized the current line according to our standard line
%        [centerDark,radiiDark]= imfindcircles(resizedLine,[11 35],'ObjectPolarity','dark');              %detection of dark circles in the line 
       [centerBright,radiiBright]= imfindcircles(resizedLine,[11 35],'ObjectPolarity','bright');                %detection of bright circles in the line 
       emptyLabel = isempty(centerBright);%+isempty(centerDark);              %zero when circles detected in both, one if one of both has circles
       if emptyLabel                                                                                      %two when both have no circles so no pattern detected
           ayatSepLineCell(ayatNum,ayaLine) = {lineImg};                             %so it pass this line and get the next
           ayaLine = ayaLine + 1;               %line of the same aya is incremented but the number of the aya doesn't we are in the same aya
       else
              %% Getting the centers and radii of the detected circles
            %  if isempty(centerDark)&&~isempty(centerBright)                %in case of bright circles are detected only
                    centers = centerBright * ratio;                                     
                    centers = sortrows(centers);
                    radii = radiiBright * ratio;
                  %  viscircles(centers, radii,'EdgeColor','b');                %uncomment when imshow is found to be abel to see the detected circles
                    innerLabelRaduis = 8.3 *ratio;
                    outerLabelRaduis = 2.3 *ratio;
                    centers = sortrows(centers,-1);
%               else
%                   if ~isempty(centerDark)&&isempty(centerBright)            %in case of dark circles are detected only
%                     centers = centerDark *ratio;
%                     centers = sortrows(centers);
%                     radii = radiiDark * ratio;
%                     viscircles(centers, radii,'EdgeColor','r');                %uncomment when imshow is found to be abel to see the detected circles
%                     innerLabelRaduis = 3*ratio;
%                     outerLabelRaduis = 8.3*ratio;
%                     centers = sortrows(centers,-1);
%                   
%                   else
%                         if size(centerDark)== size(centerBright)                %in case of both bright and dark circles are detected we concatenate the two matrices
%                             radiiBright = radiiDark;                                          %of centers and radii of dark and bright circles
%                             diff = abs(centerDark-centerBright)>10*ratio;
%                             index = find(~diff(:,1));
%                                    for counter2 = 1:size(index)
%                                       centerBright(counter2,:)=[];
%                                       radiiBright(counter2,:)=[];
%                                    end  
%                         else 
%                             for counter2 = 1:size(centerDark)  
%                                 index = find(abs(centerBright(:,1)- centerDark(counter2,1))<=10*ratio);
%                                     for counter3 = 1:size(index)
%                                       centerBright(counter3,:)=[];
%                                       radiiBright(counter3,:)=[];
%                                    end  
%                             end
%                         end 
%                         centers =reshape(union(centerBright,centerDark),[],2) *ratio;
%                         centers = sortrows(centers);
%                         radii(1,length(centers)) = radiiDark(1) * ratio;
%                         viscircles(centers, radii,'EdgeColor','r');                %uncomment when imshow is found to be abel to see the detected circles
%                         radii = radii';
%                         innerLabelRaduis = 3*ratio;
%                         outerLabelRaduis = 8.3*ratio;  
%                         centers = sortrows(centers,-1);
%                   end
%               end
           %% check that all circles are patterns
            se = [1 1 0 ; 1 0 1 ; 0 1 1];
            filledImage = imerode(filledImage,se);
            se = [0 1 0 ; 0 1 0; 0 1 0];
            filledImage = imerode(filledImage,se);
            filledImage = imerode(filledImage,se);
            filledImage = imerode(filledImage,se);
            filledImage = imerode(filledImage,se);
            filledImage = imerode(filledImage,se);
            filledImage = imerode(filledImage,se);
            filledImage = imerode(filledImage,se);
            filledImage = imerode(filledImage,se);
            se = [1 1 1 ; 1 1 1 ; 1 1 1];
            filledImage = imdilate(filledImage,se);
            filledImage = imdilate(filledImage,se);
            se = [ 0 1 0; 0 1 0; 0 1 0];
            filledImage = imdilate(filledImage,se);
            filledImage = imdilate(filledImage,se);
            filledImage = imdilate(filledImage,se);
            filledImage = imdilate(filledImage,se);
            filledImage = imdilate(filledImage,se);
            filledImage = bwmorph(filledImage,'open');
%             figure
%             imshow(filledImage);
            filledConn = bwconncomp(filledImage);
            filledBox = regionprops(filledImage,'BoundingBox');
            filledBox = {filledBox.BoundingBox};
            patternComp = zeros(size(centers,1),1);
             for counter2 = 1 : size(centers,1)
                   for counter3 = 1 : size(filledBox,2)
                       if (centers(counter2,1) > filledBox{1,counter3}(1,1) && centers(counter2,1) < (filledBox{1,counter3}(1,1)+filledBox{1,counter3}(1,3)))
                           if (centers(counter2,2) > filledBox{1,counter3}(1,2) && centers(counter2,2) < (filledBox{1,counter3}(1,2)+filledBox{1,counter3}(1,4)))
                           patternComp(counter2) = counter3;
                           end
                       end
                   end
             end
             
            for counter2 = 1 : size(centers,1)
                 colVector = filledImage(:,ceil(centers(counter2,1)));
                 onePix = 0;
                 transitionVer = 0;
                 for counter3 = 2 :size(colVector,1) 
                     if ~(colVector(counter3) == onePix)
                          onePix = colVector(counter3);
                          transitionVer = transitionVer+1;
                     end
                 end
                 if(transitionVer <= 2 && patternComp(counter2) ~= 0)
                       checkImage = imcrop(filledImage,filledBox{1,patternComp(counter2)});
                        rowVector = checkImage(ceil(size(checkImage,1)/2),:);
                        area =  regionprops(checkImage,'FilledArea');
                        area = cell2mat({area.FilledArea});
                        area = sum(area);
                        onePix = 0;
                        transitionHor = 0;
                        for counter3 = 2 :size(rowVector,2) 
                            if ~(rowVector(counter3) == onePix)
                                onePix = rowVector(counter3);
                                transitionHor = transitionHor+1;
                            end
                        end
                 if(transitionHor <= 2 )
                 if(area < 25000|| (filledBox{1,patternComp(counter2)}(1,3)/filledBox{1,patternComp(counter2)}(1,4) > 1.21 || filledBox{1,patternComp(counter2)}(1,3)/filledBox{1,patternComp(counter2)}(1,4) < 0.9))
                        
                              centers(counter2,:) = 0;
                              radii(counter2,:) = 0;
                              patternComp(counter2,:) = 0;

                 end 
                 else 
                     centers(counter2,:) = 0;
                              radii(counter2,:) = 0;
                              patternComp(counter2,:) = 0;
                 end
                 else
                     centers(counter2,:) = 0;
                              radii(counter2,:) = 0;
                              patternComp(counter2,:) = 0;
                 end
             end
             centers(centers==0) = [];
             centers = reshape(centers,[],2);
             radii(radii==0) = [];
             patternComp(patternComp==0) = [];
%              viscircles(centers, radii,'EdgeColor','r');  
            if isempty(centers)                                                                                     
           ayatSepLineCell(ayatNum,ayaLine) = {lineImg};                          
           ayaLine = ayaLine + 1;  
            end
           %% Get the position of the text after and before the aya pattern
           
                Temp_line = lineImg ;
           for counter2 = 1:size(centers,1)                  %get the boundaries of the pattern 
                leftSideLabel =centers(counter2,1);
                rightSideLabel = centers(counter2,1);
                topSideLabel = centers(counter2,2);
                bottomSideLabel =centers(counter2,2);
                outerLeftLabel = leftSideLabel - outerLabelRaduis;
                outerRightLabel = rightSideLabel + outerLabelRaduis;
                TempLine2 = zeros(size(lineImg));
                TempLine2(filledConn.PixelIdxList{patternComp(counter2)}) = Temp_line(filledConn.PixelIdxList{patternComp(counter2)})  ;
                Temp_line(filledConn.PixelIdxList{patternComp(counter2)}) =0;
                  if outerLeftLabel < 100           %in case of the pattern is the last component in the line 
                      outerLeftLabel =1;
                  end      
                  if outerRightLabel > size(Temp_line,2)
                      outerRightLabel  =  size(Temp_line,2);
                  end
                %% Save separate aya in each column with separate line in each coloumn with the number at last column
                if counter2 > 1
                  prevAya = Temp_line(:,outerRightLabel:prevLabel);
                else    
                  prevAya = Temp_line(:,outerRightLabel:end);             %line before pattern
                end
                nextAya = Temp_line(:,1:outerLeftLabel);                %line after pattern
                ayaNumPatt = imcrop(TempLine2,filledBox{1,patternComp(counter2)});
                ayatSepLineCell(ayatNum,ayaLine) = {prevAya};               %save line before pattern in the current aya
                ayaLine = ayaLine + 1;
                ayatSepLineCell(ayatNum,ayaLine) = {ayaNumPatt};            %save aya pattern in the last unempty column
                ayaLine = 1 ;
                ayatNum = ayatNum + 1 ;
                 if ~(outerLeftLabel == 1) && (counter2 == size(centers,1)  )                %save line after pattern in the next aya 
                    ayatSepLineCell(ayatNum,ayaLine) = {nextAya};
                    ayaLine = ayaLine + 1;
                 end    
                 prevLabel = outerLeftLabel;
           end    
             
       end
           %saveas(f,strcat('E:\GP\PROJECT_CODE\ayaDetection\old\fig',num2str(c),'_',num2str(counter),'.png'))
   end
 
   
%% merging all lines of each aya in one line

  rows = size (ayatSepLineCell,1);
   for counter = 1: rows
     cellRow = ayatSepLineCell(counter,:);
     lastCol = find(cellfun(@isempty,cellRow), 1 ) -2 ;             %get the last non empty element after the aya pattern
     if isempty(lastCol)                %if there is no empty cells so it is the maximum column
         lastCol = size(ayatSepLineCell,2)-1;
     end
     if lastCol <= 0           
        continue;
     end
     wholeAya = cell2mat (cellRow(lastCol));                   %get the main body line and get its difference between upper and lower limit
     [stdImageHeight,stdImageLength] = size(wholeAya);%the images must be in the same size with one main body line to be concatenated
     summation=sum(wholeAya,2);
     [~,stdMainBody]=max(summation);
     stdUpperLimit = stdMainBody;
     stdLowerLimit = stdImageHeight - stdMainBody ;
     for counter2 = lastCol-1:-1:1
         tempImage = cell2mat ( cellRow(counter2));
         [imageHeight,imageLength] = size(tempImage);
         summation=sum(tempImage,2);
         [~,MainBody]=max(summation);
         upperLimit = MainBody;
         lowerLimit = imageHeight - MainBody ;
         upperDiff = 0; 
         lowerDiff = 0;
         if stdUpperLimit > upperLimit         %padding the remaining difference with zeros 
            upperDiff = stdUpperLimit-upperLimit;
            tempImage = padarray(tempImage,[upperDiff 0],'pre');
         elseif stdUpperLimit<upperLimit
             upperDiff = upperLimit-stdUpperLimit ;
             wholeAya = padarray(wholeAya,[upperDiff 0],'pre');
             stdUpperLimit = upperLimit;
         end
         if stdLowerLimit > lowerLimit
            lowerDiff = stdLowerLimit-lowerLimit;
            tempImage = padarray(tempImage,[lowerDiff 0],'post');
         elseif stdLowerLimit<lowerLimit
             lowerDiff = lowerLimit-stdLowerLimit ;
             wholeAya = padarray(wholeAya,[lowerDiff 0],'post');
             stdLowerLimit = lowerLimit;
         end
         wholeAya = cat(2,wholeAya,tempImage);
     end

        se = [ 1 1 1 ; 1 1 1; 1 1 1];
        wholeAya = imerode(wholeAya,se);
                wholeAya = bwareaopen(wholeAya,ceil(25*size(lineImg,2)/3008));
%         figure
%          imshow(wholeAya);
        %% adding aya line and pattern of aya in output cell
        ayatAndNumCell(counter,1) = {wholeAya};
        ayatAndNumCell(counter,2) = ayatSepLineCell(counter,lastCol+1);
%                 figure
%         imshow(  ayatAndNumCell{counter,2});
   end
       save('ayat.mat','ayatAndNumCell')
end
