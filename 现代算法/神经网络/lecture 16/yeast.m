if isempty(ver('bioinfo'))
    errordlg('This demo requires the Bioinformatics Toolbox.');
    return;
end

load yeastdata.mat

emptySpots = strcmp('EMPTY',genes);
yeastvalues(emptySpots,:) = [];
genes(emptySpots) = [];
numel(genes)

nanIndices = any(isnan(yeastvalues),2);
yeastvalues(nanIndices,:) = [];
genes(nanIndices) = [];
numel(genes)

mask = genevarfilter(yeastvalues);
% Use the mask as an index into the values to remove the filtered genes. 
yeastvalues = yeastvalues(mask,:);
genes = genes(mask);
numel(genes)

[mask, yeastvalues, genes] = genelowvalfilter(yeastvalues,genes,...
                                                        'absval',log2(3));
numel(genes)

[mask, yeastvalues, genes] = geneentropyfilter(yeastvalues,genes,...
                                                           'prctile',15);
numel(genes)

yeastvalues = mapstd(yeastvalues');   % Normalize data
pc = processpca(yeastvalues,0.15);    % PCA

figure
scatter(pc(1,:),pc(2,:));
xlabel('First Principal Component');
ylabel('Second Principal Component');
title('Principal Component Scatter Plot');

net = newsom(minmax(pc),[5 3]);
net = train(net, pc);

figure
plot(pc(1,:),pc(2,:),'.g','markersize',20)
hold on
plotsom(net.iw{1,1},net.layers{1}.distances)
hold off

distances = dist(pc',net.IW{1}');
[d,cndx] = min(distances,[],2);

figure
gscatter(pc(1,:),pc(2,:),cndx); legend off;
hold on
plotsom(net.iw{1,1},net.layers{1}.distances);
hold off