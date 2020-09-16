load kmeansdata;
x=X(:,(1:2));
plot(x(:,1),x(:,2),'.')
pause;

[idx3,c] = kmeans(x,3,'distance','city');
[silh3,h] = silhouette(x,idx3,'city');
xlabel('Silhouette Value');
ylabel('Cluster');
mean(silh3)
pause;
plot(x(:,1),x(:,2),'b.',c(:,1),c(:,2),'r+');
pause;

%[idx4,c] = kmeans(x,4, 'dist','city', 'display','iter');
[idx4,c] = kmeans(x,4, 'dist','city', 'replicates',5);
[silh4,h] = silhouette(x,idx4,'city');
xlabel('Silhouette Value')
ylabel('Cluster')
mean(silh4)
pause;
plot(x(:,1),x(:,2),'b.',c(:,1),c(:,2),'r+');
pause;

[idx5,c] = kmeans(x,5,'dist','city','replicates',5);
[silh5,h] = silhouette(x,idx5,'city');
xlabel('Silhouette Value') 
ylabel('Cluster')
mean(silh5)
pause;
plot(x(:,1),x(:,2),'b.',c(:,1),c(:,2),'r+');
pause;

