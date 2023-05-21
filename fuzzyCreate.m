close all, clc
%%

d = {'dNO','dES','dWE'};

fis = mamfis('Name','behaviour');

eGMF = {'N','M','F'};
fis = addVar(fis,"input",'eG',[0 13],eGMF,[0 3]);

alphaGMF = {'SOn','SE','ES','NE','NO','NW','WE','SW','SOp'};
fis = addVar(fis,"input",'alphaG',[-pi,pi],alphaGMF,[-pi,pi]);

eMF = {'S','M','B'};
fis = addVar(fis,'output','e',[0 3],eMF,[0 5]);

alphaMF = {'SOn','SE','ES','NE','NO','NW','WE','SW','SOp'};
fis = addVar(fis,"output",'alpha',[-pi,pi],alphaMF,[-pi,pi]);

for i = 1:numel(d)
    fis = addInput(fis,[0 1],'Name',d{i});
    fis = addMF(fis,d{i},'trapmf',[-0.25,0,0.35,0.5],'Name','S');
    fis = addMF(fis,d{i},'trimf',[0.25,0.5,0.75],'Name','B');
    fis = addMF(fis,d{i},'trapmf',[0.5,0.75,1,1.25],'Name','OR');
end

fisGS = addRule(fis,[ ...
    [(2:3)',zeros(2,1),-ones(2,3),(2:3)',zeros(2,1),ones(2)];...
    [-ones(9,1),(1:9)',-ones(9,4),(1:9)',ones(9,2)];...
    [ones(9,1),(1:9)',-ones(9,1),zeros(9,2),ones(9,1),(1:9)',ones(9,2)];...
    ]);
fisOA = addRule(fis,[ ...
    [zeros(2),(1:2)',zeros(2),(1:2)',zeros(2,1),ones(2)];...
    [zeros(2),(1:2)',-3*ones(2,1),-ones(2),flip(6:7)',ones(2)];...
    [zeros(2),(1:2)',-ones(2,1),-3*ones(2,1),zeros(2,1),(3:4)',ones(2)];...
    [zeros(2),(1:2)',-ones(2),zeros(2,1),(3:4)',ones(2)];...
    ]);
fisTR = addRule(fis,[ ...
    [zeros(5,1),(1:5)',zeros(5,1),-3*ones(5,1),zeros(5,1),2*ones(5,1),5*ones(5,1),ones(5,2)];...
    [zeros(4,1),(6:9)',zeros(4,1),zeros(4,1),-3*ones(4,1),2*ones(4,1),5*ones(4,1),ones(4,2)];...
    ]);

%%
function fisOut = addVar(fisIn,type,name,range,MF,MFRange)
    if type == "input"
        fisOut = addInput(fisIn,range,'Name',name);
    elseif type == "output"
        fisOut = addOutput(fisIn,range,'Name',name);
    end
    
    for i = 1:numel(MF)
        params = (i - [2,1,0])*diff(MFRange)/(numel(MF)-1) + MFRange(1);
        fisOut = addMF(fisOut,name,'trimf',params,'Name',MF{i});
    end
end
%%