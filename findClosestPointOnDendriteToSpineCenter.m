% Ali Ozgur Argunsah, UZH, Feb, 2017

function spineSeedPoint = findClosestPointOnDendriteToSpineCenter(spineStack,spine2d,seg_Dend_ROI_skel, centroids_small)

[skel_y,skel_x] = find(seg_Dend_ROI_skel);

% figure, imshow(seg_Dend_ROI_skel)

CX_small = round(centroids_small(1,1));
CY_small = round(centroids_small(1,2));


[idx, dist] = knnsearch([skel_y,skel_x],[CY_small,CX_small],'dist','euclidean','k',1);

spineSeedPoint = [skel_x(idx),skel_y(idx)];
% 
% figure, imshow(spine2d,[]);
% hold on, plot(CX_small,CY_small,'ro');
% plot(skel_x(idx),skel_y(idx),'rx');

% 
% % find unique points
% clear skel_uniques;
% skel_uniques = unique([skel_x(idx), skel_y(idx)], 'rows');
% % 
% % unique(X, 'rows')
% %         figure, imshow(max(seg_Dend_ROI_skel,[],3),[])
% %         hold on;
% %         plot(skel_x(idx),skel_y(idx),'ro')
% %         
% % find closest candidates to spine head center
% %         num_cand = 10;
% %         dend_idcs = knnsearch([r_bp,c_bp],[CY_small,CX_small],'K',num_cand);
% 
% candidates_x = skel_uniques(:,1); % r_bp(dend_idcs);
% candidates_y = skel_uniques(:,2); % c_bp(dend_idcs);

candidates_x = skel_x(idx);
candidates_y = skel_y(idx);

z_profile_bp   = double(squeeze(spineStack(candidates_y,candidates_x,:))); 
z_profile_bp_1 = double(squeeze(spineStack(candidates_y+0,candidates_x+1,:)));
z_profile_bp_2 = double(squeeze(spineStack(candidates_y+0,candidates_x-1,:)));
z_profile_bp_3 = double(squeeze(spineStack(candidates_y+1,candidates_x+0,:)));
z_profile_bp_4 = double(squeeze(spineStack(candidates_y-1,candidates_x+0,:)));

z_profile_bp_Average  = smooth((z_profile_bp+z_profile_bp_1+z_profile_bp_2+z_profile_bp_3+z_profile_bp_4)/5);

%[val,candidates_z] = max(smooth(z_profile_bp));
[val,candidates_z] = max((z_profile_bp_Average));
     
% figure, plot(z_profile_bp)

spineSeedPoint = [candidates_x; candidates_y; candidates_z];
