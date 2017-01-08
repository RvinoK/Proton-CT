function [ ind ] = myradonBig( x, y)
% forward or backproject from img
% A is intial position, B is final position

%ind = [];
%d = 1; % spacing between planes
%N = 461; % number of planes

d = 0.25;
N = 1001;

% X1 = A(1);
% X2 = B(1);
% Y1 = A(2);
% Y2 = B(2);

% set up the planes
if (mod(N,2) == 0)
    Xp0 = -125;
    Yp0 = -125;
else
    Xp0 = -125;
    Yp0 = -125; % same as Yp0 above
end

Xp = Xp0 + ((1:1:N) - 1) * d;  % X coordinates of planes
Yp = Yp0 + ((1:1:N) - 1) * d;

%Xp
%Yp
% draw the grid

% figure;
% hold on;
% for i = 1:length(Xp)
%     for j = 1:length(Yp)
%         line([Xp(i) Xp(i)], [Yp(1) Yp(end)]);
%         line([Xp(1) Xp(end)], [Yp(i) Yp(i)]);
%     end
% end


% plot(A(1),A(2),'o');
% plot(B(1),B(2),'*');
% plot([A(1) B(1)], [A(2) B(2)], 'r');

ind = zeros(700,3);
counter = 0;
for k = 1:length(x)-1 

    X1 = x(k);
    X2 = x(k+1);
    Y1 = y(k);
    Y2 = y(k+1);
    
ax = [];
ay = [];
a = [];
amin = [];
amax = [];
imin = [];
imax = [];
jmin = [];
jmax = [];
if (X2 - X1) ~= 0
    ax = (Xp - X1)/(X2-X1);
else
    ax = [];
end
if (Y2 - Y1) ~= 0
    ay = (Yp - Y1)/(Y2-Y1);
else
    ay = [];
end

if (isempty(ax) == 0 & isempty(ay) == 0)
    amin = max([0 min(ax(1), ax(N)) min(ay(1), ay(N))]);
    amax = min([1 max(ax(1), ax(N)) max(ay(1), ay(N))]);
    %a = unique([ax ay]);
elseif(isempty(ax))
    
    amin = max([0 min(ay(1), ay(N))]);
    amax = min([1 max(ay(1), ay(N))]);
    %a = unique(ay);
elseif(isempty(ay))
    amin = max([0 min(ax(1), ax(N))]);
    amax = min([1 max(ax(1), ax(N))]);
    %a = unique(ax);
end

if isempty(ax) == 0
    if (X2 - X1) >= 0
        imin = N - (Xp(N) - amin*(X2-X1) - X1)/d;
        imax = 1 + (X1 + amax*(X2-X1) - Xp(1))/d;
        imin = ceil(imin);
        imax = floor(imax);
        ax = ax(imin:imax);
    end
    
    if (X2 - X1) < 0
        imin = N - (Xp(N) - amax*(X2-X1) - X1)/d;
        imax = 1 + (X1 + amin*(X2-X1) - Xp(1))/d;
        imin = ceil(imin);
        imax = floor(imax);
        ax = ax(imax:-1:imin);
    end
end

if isempty(ay) == 0
    if (Y2 - Y1) >= 0
        jmin = N - (Yp(N) - amin*(Y2-Y1) - Y1)/d;
        jmax = 1 + (Y1 + amax*(Y2-Y1) - Yp(1))/d;
        jmin = ceil(jmin);
        jmax = floor(jmax);
        ay = ay(jmin:jmax);
    end
    
    if (Y2-Y1) < 0
        jmin = N - (Yp(N) - amax*(Y2-Y1) - Y1)/d;
        jmax = 1 + (Y1 + amin*(Y2-Y1) - Yp(1))/d;
        jmin = ceil(jmin);
        jmax = floor(jmax);
        ay = ay(jmax:-1:jmin);
    end
end
a = unique([amin ax ay amax]);

%pathLength = sum(diff(a))*((X2-X1)^2 + (Y2-Y1)^2)^(1/2);
pathLength = 0;
length(a);
for m=1:length(a)-1
    amid = (a(m+1) + a(m))/2;
    i = 1 + (X1 + amid*(X2-X1) - Xp(1))/d;
    j = 1 + (Y1 + amid*(Y2-Y1) - Yp(1))/d;
    i = floor(i);
    j = floor(j);
    if (i>0 & j>0) & (i <=N-1 & j <= N-1)
        counter = counter+1;
        %pathLength = pathLength + (a(m+1) - a(m))*((X2-X1)^2 + (Y2-Y1)^2)^(1/2) * img(j,i);
        pathLength = (a(m+1) - a(m))*((X2-X1)^2 + (Y2-Y1)^2)^(1/2);
        %ind = [ind; j i]; % pathLength]; % i = column label (x pos), j = row label (y position)
        ind(counter,:) = [j i pathLength];
    end
end

end
% idx = any(ind(:,1)==0,2);
% ind(idx,:) = [];
% ind = unique(ind,'rows');
[u, id1, id2] = unique(ind(:,1:2), 'rows');
%%size(id2)
%size(ind)
%max(id2)
%size(accumarray(id2,ind(:,2)))
ind = [u accumarray(id2,ind(:,3))];
ind(1,:) = [];

end

