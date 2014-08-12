%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%>
% Generate a stack of images in the specified color space separated by a border
% and scaled to have the same contrast.
%
% @author Matthew Zeiler
% @date Mar 11, 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%>
% @copybrief sdispims.m
%
% @param imstack the filters in xdim x ydim x color_planes x num_images
% @param COLOR_TYPE [optional] 'gray','rgb','ycbcr','hsv' specifying the
% colorspace of the input images. Default is 'rgb' (doesn't do anything to the
% resulting image before displaying it).
% @param n2 [optional] the number of number of rows in the resulting plot.
% Defaults to ceil(sqrt(num_feature_maps)).
% @param titles [optional] Defaults to 'none': \li 'none' for no titles li 'auto' for numbered titles
% automatically generates \li {cell} passed in for different specified titles
% per subplot.
% @param scalar [optional] a multiplicative constant to change the constrast of
% the plot. Defaults to 1.
% @param border [optional] the size of the border between plots. Defaults to 2.
% @param fud [optional] flips the images up-down. Defaults to 0.
% @retval imdisp the entire image displayed together is returned.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Modified by Chengyao as gendisp.m
% Date: Jan 2, 2013
function [imdisp] = gendisp(imstack,n2,border_color,COLOR_TYPES,scalar,border,fud)

if(isempty(imstack))
    fprintf('\nX\nX\nX\nX\nX\n sdispims input is empty \nX\nX\nX\nX\nX\nX\n');
   return 
end

imstack = double(imstack);

minA = min(imstack(:));
rangeA = max(imstack(:)-min(imstack(:))); % need to use imstack so that each display is set consistently over the whole figure.



if(ndims(imstack)==4)
    [drows,dcols,numcolors,N]=size(imstack);
elseif(ndims(imstack)==3) % If only one sample, it may appear as a 3D array.
    [drows,dcols,N]=size(imstack);
    if N==3
        imstack=reshape(imstack,[drows,dcols,N,1]);
        numcolors=3;
        N=1;
    else
        imstack=reshape(imstack,[drows,dcols,1,N]);
        numcolors=1;
    end
elseif(ndims(imstack)==2)
    [drows,dcols] = size(imstack);
    N=1;
    numcolors=1;
    imstack = reshape(imstack,[drows,dcols,1,1]);
    %     error('dispims3: imstack must be a 3 or 4 dimensional array');
end

if(nargin<7) fud=0; end
if(nargin<6) border=2; end
if(nargin<5) scalar=1; end
if(nargin<2)
    n2=ceil(sqrt(N));   % n2 is number of rows of images.
%     if(N<=100 && N~=1)
%         n2 = n2+2;
%     elseif(N<400 && N ~=1)
%         n2=n2+2;
%     end
end
if(nargin<4)
    COLOR_TYPES = 'rgb';   % rgb is deault and doesn't do anything.
end
if(nargin<3)
    border_color = 1/4; % 0 is black
end
% If not titles are passed in and it's not auto titles, then no titles
% should be used.



% Size of each square.
drb=drows+border;
dcb=dcols+border;

% Initialize the image size to -1 so that borders are black still.
imdisp=zeros(n2*drb-border,ceil(N/n2)*dcb-border,numcolors);
border_indices = ones(n2*drb-border,ceil(N/n2)*dcb-border,numcolors);

for nn=1:N
    
    ii=rem(nn,n2); if(ii==0) ii=n2; end
    jj=ceil(nn/n2);
    patch=imstack(:,:,:,nn);
    if sum(patch(:).^2)~=0
        imdisp(((ii-1)*drb+1):(ii*drb-border),((jj-1)*dcb+1):(jj*dcb-border),:) ...
            = patch;
        border_indices(((ii-1)*drb+1):(ii*drb-border),((jj-1)*dcb+1):(jj*dcb-border),:) = 0;

    end
end

if(fud)
    imdisp=flipud(imdisp);
end

%%%%%%%%%%
%% Scale the input values to be between zero and one.
A = scalar*imdisp;
% scaleStack = imstack([1 2 end-1 end],[1 2 end-1 end],:,:);  % Don't use the
% boundaries for scaling.
% scaleStack = imstack(6:end-5,6:end-5,:,:);  % Don't use the boundaries for scaling.
A = (imdisp-minA);  % shifts the bottom of the array to 0.
% maxA = max(A(:)); % need to use imstack so that each display is set consistently over the whole figure.

A = A/rangeA;
A(border_indices==1)=border_color;   % Set the borders back to zero.

% zeroind = find(imdisp(:)==0,1,'first')
% if(isempty(zeroind))
%     zeroind = 1;
% end
% A = A - (A(zeroind)-0.5); % Set the zero pixels to 0.5.
imdisp = uint8(round(A*255)); % Convert to unsigned in and scale if needed.

%%%%%%%%%%
%
% Make the border pixels black after scalin (otherwise scaling would be
% altered).
switch COLOR_TYPES
    case 'gray'
        imdisp = rgb2gray(imdisp);
    case 'rgb'
        
    case 'ycbcr'
        imdisp = ycbcr2rgb(imdisp);
    case 'hsv'
        imdisp = hsv2rgb(imdisp*255.0);
end

% Make the borders different colors baed on majority of elements.
% if(sum(vect_array(imdisp==0))>(numel(imdisp)/2))
%     imdisp(find(border_indices==1)) = 255;
% else
%     imdisp(find(border_indices==1)) = 0;
% end

end

