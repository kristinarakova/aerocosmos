function mutualInformation = mutualInfCalc(im1, im2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[~,~,indrow] = unique(im1(:)); %// Change here
[~,~,indcol] = unique(im2(:)); %// Change here

%// Same code
jointHistogram = accumarray([indrow indcol], 1);
jointProb = jointHistogram / numel(indrow);
indNoZero = jointHistogram ~= 0;
jointProb1DNoZero = jointProb(indNoZero);
jointEntropy = -sum(jointProb1DNoZero.*log2(jointProb1DNoZero));

histogramImage1 = sum(jointHistogram, 1);
histogramImage2 = sum(jointHistogram, 2);

%// Find non-zero elements for first image's histogram
indNoZero = histogramImage1 ~= 0;

%// Extract them out and get the probabilities
prob1NoZero = histogramImage1(indNoZero) / numel(histogramImage1);

%// Compute the entropy
entropy1 = -sum(prob1NoZero.*log2(prob1NoZero));

%// Repeat for the second image
indNoZero = histogramImage2 ~= 0;
prob2NoZero = histogramImage2(indNoZero) / numel(histogramImage2);
entropy2 = -sum(prob2NoZero.*log2(prob2NoZero));

%// Now compute mutual information
mutualInformation = entropy1 + entropy2 - jointEntropy;
end

