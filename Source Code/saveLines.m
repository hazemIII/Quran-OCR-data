function [] = saveLines(y)
    lines = cell(1);
    load('lines.mat');
    dirName = strcat('lines\page (',int2str(y),')');
    mkdir(dirName);
    for i =1:length(lines)
        data = logical(lines{i});
        name = strcat(dirName,'/img(',int2str(i),').png');
        imwrite(data,name);
    end
end