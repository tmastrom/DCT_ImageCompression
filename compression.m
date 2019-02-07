% Lab 2 - Application of 2-D DCT to Image Compression

% compress the image with 3 quality levels 10, 40, 90

% return number of zeros 
% return PSNR

% B is the image to be operated on 
function compression(B)

hold on
imshow(B, [0, 255])
title('original')

%
% step 1 - Level off and 2-D DCT
%

% level off 
Bleveled = B-128;
% check the maximum value is not over 128
mx = max(max(Bleveled));

% 2-D DCT 
C = dct2(Bleveled);



%
% step 2 - Quantization
%

% Q50 = quantization matrix 
Q50 = [16 11 10 16 24 40 51 61; 12 12 14 19 26 58 60 55; ...
     14 13 16 24 40 57 69 56; 14 17 22 29 51 87 80 62; ...
     18 22 37 56 68 109 103 77; 24 35 55 64 81 104 113 92; ...
     49 64 78 87 103 121 120 101; 72 92 95 98 112 100 103 99];

N = 8*ones(1,32);
% divide C into 32x32 8x8 matrices
Cdiv = mat2cell(C, N, N);
% size of matrix Cdiv
size(Cdiv);
% size of matrix 1,2 in Cdiv 
size(Cdiv{1,2});

size(Q50);
% quality level 10, tau = 50/10 = 5 
Q10 = round(5.*Q50);
Q40 = round(5/4.*Q50);
Q90 = round((100-90)/50.*Q50);


% compute the s matrix using Q50 quantization matrix 
for i = 1:32
    for j=1:32
        c_matrix = Cdiv{i,j};
        S{i,j} = round(Cdiv{i,j}./Q10);
        s_matrix = S{i,j};
    end
end 
sz = size(S);
sz1 = size(S{1});

%
% Decompression
% 

% Pointwise multiplication of matrix S with the quantization matrix Q
for i = 1:32
    for j=1:32
        R{i,j} = S{i,j}.*Q10;
    end
end
 
% make R into a 256x256 matrix
E = cell2mat(R);
size(E)

% Apply 2-D inverse DCT to matrix R
Eidct = idct2(E);

Bcompressed = Eidct+128;

imshow(Bcompressed, [0,255])
title('compressed')


