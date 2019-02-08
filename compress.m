% Lab 2 - Application of 2-D DCT to Image Compression

% compress the image with 3 quality levels 10, 40, 90

% return number of zeros 
% return PSNR

% B is the image to be operated on 
% q is the quality (1-100)
function compress(B, q)

hold on
figure, imshow(B, [0, 255])
title('original')

%
% step 1: Level off and 2-D DCT
%

% level off 
Bleveled = B-128;
% check the maximum value is not over 128
mx = max(max(Bleveled));

% 2-D DCT 
C = dct2(Bleveled);

%
% step 2: Quantization
%

% Q50 = quantization matrix 
Q50 = [16 11 10 16 24 40 51 61; 12 12 14 19 26 58 60 55; ...
     14 13 16 24 40 57 69 56; 14 17 22 29 51 87 80 62; ...
     18 22 37 56 68 109 103 77; 24 35 55 64 81 104 113 92; ...
     49 64 78 87 103 121 120 101; 72 92 95 98 112 100 103 99];

n = max(size(B))/8;         % image size divided by 8
N = 8*ones(1,n);             % number of matrices to split C into

Cdiv = mat2cell(C, N, N);   % divide C into 8x8 matrices

size(Cdiv);                 % size of matrix Cdiv
size(Cdiv{1,2});            % size of matrix 1,2 in Cdiv 

% create Quantization matrix
if q == 50
    Q = Q50;
elseif q < 50
    Q = round(50/q.*Q50);
elseif q > 50
    Q = round((100-q)/50.*Q50);
end

% compute the s matrix using Q50 quantization matrix 
for i = 1:n
    for j=1:n        
        S{i,j} = round(Cdiv{i,j}./Q);
    end
end 
sz = size(S);
sz1 = size(S{1});

%
% Step 3: Decompression
% 

% Pointwise multiplication of matrix S with the quantization matrix Q
for i = 1:n
    for j=1:n
        R{i,j} = S{i,j}.*Q;
    end
end
 
% make R into a 256x256 matrix
E = cell2mat(R);
size(E);

% Apply 2-D inverse DCT to matrix R
Eidct = idct2(E);

Bcompressed = Eidct + 128;

figure, imshow(Bcompressed, [0,255])
title(q)

%
% Analyze Quality 
%

mli = 255^2;         % max light intensity
mse = mean(mean((Bcompressed-B).^2));   % mean squared error
psnr = 10*log10(mli/mse);        % peak signal-to-noise ratio

psnr

