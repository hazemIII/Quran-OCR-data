function [] = diacritics(y)
    load('ayat.mat');
    ayat = ayatAndNumCell(:,1);
    [rows,~] = size(ayat);
    dirName = strcat('diacritics\page (',int2str(y),')');
    mkdir(dirName);
    for i=1:rows
        data = ayat{i};
        if ~isempty(data)
            summation = sum(data,2);
            [~,index] = max(summation);
            conncomp=bwconncomp(data); % finding the baseline
            count=conncomp.NumObjects;
            % finding the box
            box=regionprops(conncomp,'BoundingBox');
            box=reshape([box.BoundingBox],[4 count])';
            box(:,3)=box(:,1)+box(:,3);
            box(:,4)=box(:,2)+box(:,4);
            % determine the main body components
            for k=1:count
                if box(k,4) > index && box(k,2) < index
                    data(conncomp.PixelIdxList{k}) = 0;
                end
            end
                
                dicName = strcat(dirName,'/img(',int2str(i),').png');
                imwrite(data,dicName);
        end
    end     
end