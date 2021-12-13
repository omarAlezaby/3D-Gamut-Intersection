%% color engineering tool box function
profile_1 = "profiles/sRGB_v4_ICC_preference.icc";
profile_2 = "profiles/PSOsc-b_paper_v3_FOGRA54.icc"; 
%profile_2 = "profiles/ITU-R_BT2020(beta).icc"; 

tic
[vertices_1, faces_1]=gamutfromprofile(profile_1);
toc


figure, trisurf(faces_1,vertices_1(:,2),vertices_1(:,3),vertices_1(:,1), 'FaceColor','cyan','FaceAlpha',0.3);

[vertices_2, faces_2]=gamutfromprofile(profile_2);
figure, trisurf(faces_2,vertices_2(:,2),vertices_2(:,3),vertices_2(:,1), 'FaceColor','cyan','FaceAlpha',0.3);

% run the first intersection version function
tic

[faces_intr, vertices_intr] = intersection_gamut(faces_2, vertices_2, faces_1, vertices_1);
figure, trisurf(faces_intr,vertices_intr(:,2),vertices_intr(:,3),vertices_intr(:,1), 'FaceColor','cyan','FaceAlpha',0.3);
toc

% run the second version intersection function
tic

[faces_intr, vertices_intr] = intersection_profile(profile_2, profile_1);
figure, trisurf(faces_intr,vertices_intr(:,2),vertices_intr(:,3),vertices_intr(:,1), 'FaceColor','cyan','FaceAlpha',0.3);
toc