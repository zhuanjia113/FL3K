function  salient_value = GetSalientValue_PointCloud(points_XYZ)

% geometric saliency
points_num = size(points_XYZ,1);
kdtreeVertices = KDTreeSearcher(points_XYZ,'Distance','euclidean');
[idx,dist] = knnsearch(kdtreeVertices, points_XYZ,'k',2,'Distance','euclidean');
pointcloud_res = mean(dist(:,2));

% CED salient value
r = 15*pointcloud_res; 
[neighborIdx,neighborDis]= rangesearch(kdtreeVertices,points_XYZ,r); 

CED_dist = zeros(1,points_num);
for i = 1:points_num

    point1 = points_XYZ(i,:);
    indices = neighborIdx{i}(2:end);

    if(isempty(indices))
        continue;
    end

    point2 = mean(points_XYZ(indices,:));


    CED_dist(i) = norm(point1-point2);

    indices = [];

end


D_geo = CED_dist/r;


R = 40*pointcloud_res;                   % large neighborhoods

D_high = zeros(1,points_num);

[neighborIdx2,neighborDis2]= rangesearch(kdtreeVertices,points_XYZ,R); 

for i = 1:points_num

    C_index2 = neighborIdx2{i}(2:end);

    D_high(i) = 1-exp(-mean(D_geo)/(length(C_index2)+eps));

end

D_geo = (D_geo-min(D_geo))/(max(D_geo)-min(D_geo));                  % Max-min norm
D_high = (D_high-min(D_high))/(max(D_high)-min(D_high)+eps);         % Max-min norm

% Non-linear Suppression aggregration
salient_value = Get_NonLinear_Suppression(D_geo) + Get_NonLinear_Suppression(D_high);
