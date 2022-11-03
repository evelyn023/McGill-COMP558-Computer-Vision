function draw_epipolar_lines(I1,I2,F,matched1,matched2)
    figure; 
    subplot(121);
    imshow(I1); 
    title('Inliers and Epipolar Lines in First Image'); hold on;
    plot(matched1(:,1),matched1(:,2),'go')
    epiLines1 = epipolarLine(F',matched2);
    points1 = lineToBorderPoints(epiLines1,size(I1));
    line(points1(:,[1,3])',points1(:,[2,4])');
    
    subplot(122); 
    imshow(I2);
    title('Inliers and Epipolar Lines in Second Image'); hold on;
    plot(matched2(:,1),matched2(:,2),'go')
    epiLines2 = epipolarLine(F,matched1);
    points2 = lineToBorderPoints(epiLines2,size(I2));
    line(points2(:,[1,3])',points2(:,[2,4])');
    hold off;
end

