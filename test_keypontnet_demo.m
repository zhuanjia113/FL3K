
% Time:2023-11-18
% Function: Fast compute the keypoint from a point cloud
% Reference: Chengzhuan Yang et al. A Fast and Lightweight Unsupervised 3D Keypoint Detector, submitted to CVPR2024
% @author：Chengzhuan Yang (czyang@zjnu.edu.cn)


addpath('include/jsonlab-master/');                 % matlab read json

clear;clc;close all;

tic;

% 1. read all json file
json_filename = 'data/KeypointNet/annotations/';
all_jsonFiles = dir(strcat(json_filename,'*.json'));

json_Count = length(all_jsonFiles);        % the number of jsons
pcd_file = 'data/KeypointNet/pcds/';
class_RepRatio = cell(1,json_Count);
class_mIOU = cell(1,json_Count);
eachclass_mIOU = zeros(json_Count,11);
for i = 1:json_Count

    fprintf('handle %d of %d\n', i, json_Count);

    jsonData = loadjson(strcat(json_filename,all_jsonFiles(i).name));

    model_nums = length(jsonData);         % the number of 3D models for each class

    All_RepRatio = zeros(1,model_nums);
    for j = 1:model_nums
        disp(j);
        class_name = jsonData(j).class_id;
        model_name = jsonData(j).model_id;
        model_keypoints = jsonData(j).keypoints;

        ptCloud = pcread(strcat(pcd_file,class_name,'/',model_name,'.pcd'));

        points_XYZ = double(ptCloud.Location);
        
       
        predict_keypoints = Get_3DKeyPoint_FLUK(points_XYZ);                              % Detect the 3D keypoint 


        IOUs = Get_3DKeyPoint_IOU(model_keypoints, double(predict_keypoints));

        mIOU(j,:) = IOUs;

        IOUs = [];

    end

    class_mIOU{i} = mIOU;
    eachclass_mIOU(i,:) = mean(mIOU);

    mIOU = [];

end

toc;

