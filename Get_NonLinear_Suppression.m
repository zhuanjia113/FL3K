function salient_value_new = Get_NonLinear_Suppression(salient_value)

% Time:2023-8-21
% Function: non-linear suppression operator for salient value
% INPUT:
% salient_value: Input a salient value of 3D point cloud
% OUTPUT:
% salient_value_new: update the salient value of 3D point cloud


%local maxima excluding the global maximum

TF = islocalmax(salient_value);
localMax_value = salient_value(TF);

if(isempty(localMax_value))
    salient_value_new = salient_value;

else

    ind1 = find(localMax_value==max(salient_value));
    if(isempty(ind1))
        w1 = max(salient_value)-mean(localMax_value);
    
    else
        localMax_value(ind1) = [];
        w1 = max(salient_value)-mean(localMax_value);
    end
    
    salient_value_new = w1^2*salient_value;

end



% TF = islocalmax(salient_value);
% localMax_value = salient_value(TF);
% ind1 = find(localMax_value==max(salient_value));
% if(isempty(ind1))
%     w1 = max(salient_value)-mean(localMax_value)+eps;
% 
% else
%     localMax_value(ind1) = [];
%     w1 = max(salient_value)-mean(localMax_value)+eps;
% end
% 
% salient_value_new = w1^2*salient_value;

