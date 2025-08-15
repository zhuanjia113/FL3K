function  predict_3DKeypoint = Get_3DKeyPoint_FL3K(points_XYZ)


 salient_value = GetSalientValue_PointCloud(points_XYZ);                      % compute the geometric and high-level semantic saliency


 predict_3DKeypoint = GetKeypoint_SalientMap(points_XYZ,salient_value);       % Generate the stable keypoint from the saient value
 

