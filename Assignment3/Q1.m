%% Image1
% Manually detect 8 pairs of points
% a row is [x1 y1 x2 y2]
I11 = imread("stereo-pairs\p11.jpg");
I12 = imread("stereo-pairs\p12.jpg");
pixel_pairs1 = [114 151 10 158;
    294 87 449 79;
    497 101 539 87;
    704 92 746 64;
    697 315 739 315;
    271 374 179 365;
    525 348 476 347;
    194 146 351 140];

F1_8point = fundamental_matrix(pixel_pairs1);
rank(F1_8point);
draw_epipolar_lines(I11,I12,F1_8point,pixel_pairs1(:,1:2),pixel_pairs1(:,3:4));


%% Image2
I21 = imread("stereo-pairs\p21.jpg");
I22 = imread("stereo-pairs\p22.jpg");
pixel_pairs2 = [360 82 348 84;
    211 325 168 325;
    282 308 256 307;
    320 390 263 389;
    393 410 281 408;
    541 294 494 295;
    139 414 63 410;
    575 380 463 381];

F2_8point = fundamental_matrix(pixel_pairs2);
rank(F2_8point);
draw_epipolar_lines(I21,I22,F2_8point,pixel_pairs2(:,1:2),pixel_pairs2(:,3:4));
