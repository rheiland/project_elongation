%%inputs
%a = alphaPSM, b = alphaNC, c = alphaEX, d = alphaPN, e=alphaPE
%%outputs
%thickness length ratio angle


%These values can be changed according to the variable you wish to vary
testinput=[]
for i=0:5:100
    for j=0:5:100
        for k=0:5:100
        temp=[i/100, j/100, k/100, 0.5, 0.5];
        testinput=[testinput;temp];
        end
    end
end

testoutput = myNeuralNetworkFunction2(testinput);

%convert to RGB lower thickness = more red, longer length = more green
%unscale = @(data, l, u, inmin, inmax) (data - l) * (inmax - inmin) / (u - l) + inmin;

thick = 1-testoutput(:,1);
length = testoutput(:,2);

%scale the outputs to 0 - 1
colmin=min(thick);
colmax=max(thick);
scaledthick = rescale(thick,'InputMin',colmin,'InputMax',colmax);

colmin=min(length);
colmax=max(length);
scaledlength = rescale(length,'InputMin',colmin,'InputMax',colmax);

RGBoutput = [scaledthick,scaledlength,zeros(numel(thick),1)];
% RGBoutput = [thick,length,zeros(numel(thick),1)];




%These strings can be changed to change the colorscheme
col=strings;
for i = 1:numel(thick)
col=[col;strcat(string(RGBoutput(i,2)),',',string(RGBoutput(i,3)),',',string(RGBoutput(i,1)))];
end

axis equal
for i = 1:numel(thick)
plot3(testinput(i,1),testinput(i,2),testinput(i,3),'.','Color',[col(i+1)],'MarkerSize',27)
 xlim([0,1]);
 ylim([0,1]);
 zlim([0,1]);
hold on
end

      



