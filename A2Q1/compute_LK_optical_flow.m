function [Vx,Vy] = compute_LK_optical_flow(frame_1,frame_2)

% You have to implement the Lucas Kanade algorithm to compute the
% frame to frame motion field estimates. 
% frame_1 and frame_2 are two gray frames where you are given as inputs to 
% this function and you are required to compute the motion field (Vx,Vy)
% based upon them. 
% -----------------------------------------------------------------------%
% YOU MUST SUBMIT ORIGINAL WORK! Any suspected cases of plagiarism or 
% cheating will be reported to the office of the Dean.  
% You CAN NOT use packages that are publicly available on the WEB.
% -----------------------------------------------------------------------%

im1 = single(rgb2gray(frame_1));
im2 = single(rgb2gray(frame_2));

% complete the code here and define Vx, Vy
% set parameters
ws = 65; 
sigma = 6;
sigma_t = 0.5;
% smooth the frames
I1 = imgaussfilt(im1,sigma,'FilterDomain',"spatial");
I2 = imgaussfilt(im2,sigma,'FilterDomain',"spatial");
% initialize Vx and Vy
Vx = zeros(size(I1));
Vy = zeros(size(I1));
% get the partial derivatives
[Gx, Gy] = imgradientxy(I1,'prewitt');
% smooth in time
stack = cat(3,I1,I2);
smoothstack = smoothdata(stack,3,'gaussian','SmoothingFactor',sigma_t);
Gt = smoothstack(:,:,1)-smoothstack(:,:,2);


w = round(ws/2);
% slide horizontally and then vertically
for i = w+1 : size(Gx,1)-w
   for j = w+1 : size(Gx,2)-w
       % (i,j) is the center of the window
       % get the windows
       Ix = Gx(i-w:i+w, j-w:j+w);
       Iy = Gy(i-w:i+w, j-w:j+w);
       It = Gt(i-w:i+w, j-w:j+w);
       A = [Ix(:) Iy(:)]; % rows of A are (dIdx,dIdy)
       M = (A')*A; % the second moment matrix
       b = (A')*(It(:));
       V = M\b;       
       Vx(i,j) = V(1);
       Vy(i,j) = V(2);
   end
end

end
