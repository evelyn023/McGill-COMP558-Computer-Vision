function F = fundamental_matrix(pixel_pairs)
% input: 8*4 matrix which stores a corresponding pixel pair coordinates in
% a row as [x1, y1, x2, y2]
% output: the fundamental matrix

    % Data normalization
    m = mean(pixel_pairs,1);
    sigma1 = sqrt((sum((pixel_pairs(:,1)-m(1)).^2) + sum((pixel_pairs(:,2)-m(2)).^2))/16);
    sigma2 = sqrt((sum((pixel_pairs(:,3)-m(3)).^2) + sum((pixel_pairs(:,4)-m(4)).^2))/16);
    M1 = [1/sigma1 0 -m(1)/sigma1;
        0 1/sigma1 -m(2)/sigma1;
        0 0 1];
    M2 = [1/sigma2 0 -m(3)/sigma2;
        0 1/sigma2 -m(4)/sigma2;
        0 0 1];

    % Use normalized data to build matrix A
    A = zeros(9,9); % the last row of A is all zeros
    for i=1:8
        p1 = M1*[pixel_pairs(i,1); pixel_pairs(i,2); 1];
        p2 = M2*[pixel_pairs(i,3); pixel_pairs(i,4); 1];
        r = reshape(p1*transpose(p2),1,9);
        A(i,:) = r;
    end
    % Least square
    [~,~,V] = svd(A);
    Fn = transpose(reshape(V(:,9),3,3));

    % Rank 2 approximation
    [UF,SF,VF] = svd(Fn);
    SF(3,3) = 0;
    Fn_rank2 = UF*SF*(VF.');

    % Denormalize
    F = (M2.') * Fn_rank2 * M1;
    F = F / norm(F);
end