function [spectrogramPatches] = SparseFilteringPatches(smallerSpectrogram,exampleSizeTime, numExamples, save)
%   function [spectrogramPatches] = SparseFilteringPatches(smallerSpectrogram,exampleSizeTime, numExamples, save)
% columns = Examples
%row = features
counter = 1;
smallerSpectrogramSmol = [];
for i = 1:1:numExamples
    if(size(smallerSpectrogram,2)>=exampleSizeTime*numExamples)
    example = smallerSpectrogram(:,counter:1:exampleSizeTime*i);
    else
        uialert("TOOBIG");
    end
example = reshape(example, 1, []);
smallerSpectrogramSmol = [smallerSpectrogramSmol; (example)];
counter = exampleSizeTime*i+1;
example = [];
end
spectrogramPatches = smallerSpectrogramSmol';
if (save==1)
save('spectrogramPatches.mat', 'spectrogramPatches');
end
end

