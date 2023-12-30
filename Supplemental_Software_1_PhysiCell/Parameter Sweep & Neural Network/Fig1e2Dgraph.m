%%inputs
%a = alphaPSM, b = alphaNC, c = alphaEX, d = alphaPN, e=alphaPE
%%outputs
%thickness length ratio angle

testinput=[];
%These values can be changed according to the variable you wish to vary
for i=0:2.5:100
    for j=0:2.5:100
        for k=0:2.5:100
        temp=[i/100, j/100, k/100, 0.5, 0.5];
        testinput=[testinput;temp];
        end
    end
end

testoutput = myNeuralNetworkFunction2(testinput);

%convert to RGB lower thickness = more red, longer length = more green
%unscale = @(data, l, u, inmin, inmax) (data - l) * (inmax - inmin) / (u - l) + inmin;

thick = testoutput(:,1);
length = testoutput(:,2);
angle= testoutput(:,4);
thin = 1-thick


%These values can be changed according to the variable you wish to plot
plot(testinput(:,1),length)




