function [] = mainBody(name)
    load(name);
    ayat = ayatAndNumCell(:,1);
    [rows,~] = size(ayat);
    page = cell(1); % one row for mainbody component and another for secondary component
    insertindex = 1;
    for i=1:rows
        data = ayat{i};
        if ~isempty(data)
            data = bwareaopen(data,20);
            dataSize = size(data);
            mainBodyComp = cell(1);
            secondariesComp = cell(1);
            mainBodyIndex = [];
            secondariesPos = cell(1);
            secondariesPixelId = cell(1);
            mainCount = 1;
            secCount = 1;
            summation = sum(data,2);
            [~,index] = max(summation);
            conncomp=bwconncomp(data); % finding the baseline
            count=conncomp.NumObjects;
            % finding image of each comp
            images = regionprops(conncomp,'Image');
            % get centroid of every component
            cent = regionprops(conncomp,'centroid');
            % finding the box
            box=regionprops(conncomp,'BoundingBox');
            box=reshape([box.BoundingBox],[4 count])';
            box(:,3)=box(:,1)+box(:,3);
            box(:,4)=box(:,2)+box(:,4);
            % determine the main body components
            for k=count:-1:1
                if box(k,4) > index && box(k,2) < index
                    mainBodyComp(mainCount) = {images(k).Image};
                    mainBodyIndex(mainCount) = k;
                    mainCount = mainCount + 1;
                else
                    secondariesComp(secCount) = {images(k).Image};
                    secondariesPos(secCount) = {cent(k).Centroid};
                    secondariesPixelId(secCount) = conncomp.PixelIdxList(k);
                    secCount = secCount + 1;
                end
            end
            page(insertindex,1) = {mainBodyComp};
            page(insertindex,2) = {secondariesComp};
            page(insertindex,3) = {secondariesPos};
            page(insertindex,4) = {dataSize};
            page(insertindex,5) = {mainBodyIndex};
            page(insertindex,6) = {secondariesPixelId};
            insertindex = insertindex+1;
        end        
    end
    save('page.mat','page');
end