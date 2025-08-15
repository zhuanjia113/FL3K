function  IOUs = Get_3DKeyPoint_IOU(model_keypoints, predict_keypoints)

% Time:2023-5-21
% Function: Compute the Intersection over Unions(IoU) index
% Parameter：
% model_keypoints：human labeling keypoint               M*3
% predict_keypoints: predict keypoint of the algorithm   N*3


model_num = length(model_keypoints);        % KeyPointNet  
predict_num = length(predict_keypoints);  


% 1.Euclidean distance
% dist = zeros(predict_num,model_num);
% for i = 1:predict_num
%     p_XYZ = predict_keypoints(i,:);
%     for j = 1:model_num
%         m_XYZ = model_keypoints(j).xyz;
%         dist(i,j) = norm(p_XYZ-m_XYZ);
% 
%     end
% end

for i = 1:model_num
    human_Keypoints(i,:) = model_keypoints(i).xyz;
end

%human_Keypoints = model_keypoints;

dist = pdist2(predict_keypoints,human_Keypoints);



%distance_thresholds = 0.1;
index = 1;
for thresholds = 0:0.01:0.1

    distance_thresholds = thresholds;

    %minVal = min(dist,[],2);   % min value for each row
    minVal2 = min(dist);       % min value for each column
    
    True_Positive = length(find(minVal2<=distance_thresholds));
    False_Positive = predict_num - True_Positive;
    False_Negative = model_num - length(find(minVal2<=distance_thresholds));
    
    
    IOU = True_Positive/(True_Positive+False_Positive+False_Negative);

    IOUs(index) = IOU;
    index = index + 1;


end





 





