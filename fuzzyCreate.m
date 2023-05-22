close all, clc
%%

d = {'dNO','dES','dWE'};

fis = mamfis('Name','behaviour');

eGMF = {'N','M','F'};
fis = addVar(fis,"input",'eG',[0 3],eGMF);

fis = addInput(fis,[-pi,pi],'Name','alphaG');
fis = addMF(fis,'alphaG','trapmf',[-2*pi,-pi,-pi/6,0],'Name','ES');
fis = addMF(fis,'alphaG','trimf',[-pi/6,0,pi/6],'Name','NO');
fis = addMF(fis,'alphaG','trapmf',[0,pi/6,pi,2*pi],'Name','WE');

eMF = {'S','M','B'};
fis = addVar(fis,'output','e',[0 3],eMF);

alphaMF = {'ES','NE','NO','NW','WE'};
fis = addVar(fis,"output",'alpha',[-pi/2,pi/2],alphaMF);

for i = 1:numel(d)
    fis = addInput(fis,[0 1],'Name',d{i});
    fis = addMF(fis,d{i},'trapmf',[-0.25,0,0.3,0.5],'Name','S');
    fis = addMF(fis,d{i},'trimf',[0.3,0.5,0.7],'Name','B');
    fis = addMF(fis,d{i},'trapmf',[0.5,0.7,1,1.25],'Name','OR');
end

fisGS = addRule(fis,[ ...
    [3,0,0,0,0,3,0,1,1];...
    [2,0,0,0,0,2,0,1,1];...
    [1,0,0,0,0,1,0,1,1];...
    ]);
fisOA = addRule(fis,[ ...
    [zeros(2),(1:2)',zeros(2),(1:2)',zeros(2,1),ones(2)];...
    [zeros(2),(1:2)',ones(2,1),zeros(2,1),zeros(2,1),flip(4:5)',ones(2)];...
    [zeros(2),(1:2)',zeros(2,1),ones(2,1),zeros(2,1),(1:2)',ones(2)];...
    ]);
fisTR = addRule(fis,[ ...
    [0,1,0,-3,0,2,3,1,1];...
    [0,2,0,0,0,2,3,1,1];...
    [0,3,0,0,-3,2,3,1,1];...
    ]);

%%
function fisOut = addVar(fisIn,type,name,range,MF)
    if type == "input"
        fisOut = addInput(fisIn,range,'Name',name);
    elseif type == "output"
        fisOut = addOutput(fisIn,range,'Name',name);
    end
    
    for i = 1:numel(MF)
        params = (i - [2,1,0])*diff(range)/(numel(MF)-1) + range(1);
        fisOut = addMF(fisOut,name,'trimf',params,'Name',MF{i});
    end
end
%%