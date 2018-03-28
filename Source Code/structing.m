function structing(name)

load('page.mat')
load('labels.mat')
cells = page;
[rows,~] = size(cells);
totalPage = cell(rows,1);

for i=1:rows
    
    % initi
    aya = struct;
    aya.size = [0,0];
    aya.mainBodyComp = cell(1);
    aya.mainBodyIndex = [];
    aya.mainSecComp = cell(1);
    aya.secComp = cell(1);
    aya.mainSecPos = cell(1);
    aya.secPos = cell(1);
    aya.mainSecPixel = cell(1);
    aya.secPixel = cell(1);
    aya.mainSecLabel = cell(1);
    aya.secLabel = cell(1);
    mainCount = 1;
    secCount = 1;
    mainSecCount = 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mainComp = cells(i,1);
    aya.mainBodyComp = mainComp{1,1};
    aya.mainBodyIndex = cells{i,5};
    aya.size = cells{i,4};
    if iscell(labels)
        labelData = labels{i};
    else
        labelData = labels;
    end
    data = cells(i,2);
    data = data{1,1};
    cent = cells(i,3);
    cent = cent{1,1};
    pixel = cells{i,6};
    [row,~] = size(labelData);
    
    for j = 1:row
        label = labelData(j,:);
        label = label(label ~= ' ');
        comp = data{j};
        pos = cent{j};
        pixelsList = pixel(j);
        if strcmp(label,'two_points') || strcmp(label,'point') || strcmp(label,'mad') || strcmp(label,'hamza') || strcmp(label,'hamza2') || strcmp(label,'three_points')
            aya.mainSecComp(mainSecCount) = {comp};
            aya.mainSecLabel(mainSecCount) = {label};
            aya.mainSecPos(mainSecCount) = {pos};
            aya.mainSecPixel(mainSecCount) = {pixelsList};
            mainSecCount = mainSecCount+1;
        else
            aya.secComp(secCount) = {comp};
            aya.secLabel(secCount) = {label};
            aya.secPos(secCount) = {pos};
            aya.secPixel(secCount) = {pixelsList};
            secCount = secCount+1;
        end   
    end
    totalPage(i) = {aya};
end
save(name,'totalPage')
end