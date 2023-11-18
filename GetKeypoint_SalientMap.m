function final_keypoint = GetKeypoint_SalientMap(points_XYZ,salient_value)

% points_XYZ:  XYZ coordinate   N*3
% salient_value: saliency value of each point pi for 3D point cloud  N*1


points_num = size(points_XYZ,1);
kdtreeVertices = KDTreeSearcher(points_XYZ,'Distance','euclidean');
[idx,dist] = knnsearch(kdtreeVertices, points_XYZ,'k',2,'Distance','euclidean');
pointcloud_res = mean(dist(:,2));

ln = 10*pointcloud_res; 
[neighborIdx,neighborDis]= rangesearch(kdtreeVertices,points_XYZ,ln); 


% Non-maximum Suppression
Tg = mean(salient_value);                    % Threshold for 3D distance


%keypoint = [];
index = 1;
for i = 1:points_num
    if(salient_value(i)<Tg)
        continue;
    end
  
   maximum = 1;

   nn_index = neighborIdx{i}(2:end);


   for j = 1:length(nn_index)
       if(salient_value(i)<salient_value(nn_index(j)))
           maximum = 0;
       end

   end

   if (maximum == 1)
       %keypoint = [keypoint;points_XYZ(i,:)];
       keypoint(index,:) = points_XYZ(i,:);
       index = index + 1;

   end

end

final_keypoint = keypoint;
