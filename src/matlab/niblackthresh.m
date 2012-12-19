function output = niblackthresh(img, win_size, k_value)
%NIBLACKTHRESH Compute an image threshold value using Niblack's
% algorithm. NIBLACKTHRESH returns a binarized image using the
% Niblack's binarization algorithm.
%
%  Synopsis: 
%            output = niblackthresh(img) 
%            output = niblackthresh(img, win_size) 
%            output = niblackthresh(img, win_size, k_value)
%
%  Input: 
%         img = input image to be segmented (required) 
%         win_size = window size around each pixel (required) 
%         k_value = constant ranging between 0.2 for bright objects 
%                   (default) and -0.2 for dark objects
%
%  Output: 
%         output = binarized image according to the threshold value
%                  computed by the algorithm.
%
%  Reference: 
%        Niblack, W (1986), An introduction to Digital Image Processing" Prentice-Hall"
%
%  Author: Daniel Martín
%
%  This file is part of Thresh-mat.
%
%  Thresh-mat is free software; you can redistribute it and/or
%  modify it under the terms of the GNU General Public License as
%  published by the Free Software Foundation; either version 2 of
%  the License, or (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%  General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with Thresh-mat; If not, see
%  <http://www.gnu.org/licenses/>.

%  Created: December 2012

if nargin < 2 || nargin > 3
  error('niblackthresh: you must provide an input image and a window size.'); 
elseif nargin == 2
  k_value = 0.2;
end	

% Window size must be positive and odd
if win_size <= 0 || mod(win_size, 2) == 0
  error('niblackthresh: window size must be positive and odd');
end

% Check if input image is rgb and convert to a gray-level image
if ndims(img) == 3
  img = rgb2gray(img);
end

% Convert the input image to double before doing the computations
img = double(img);

mean           = imfilter(img, fspecial('average', win_size));
stdeviation    = stdfilt(img, ones(win_size, win_size));

threshold = (mean .* k_value .* stdeviation);

diff = threshold - img;

bw          = (diff >= 0);
output      = imcomplement(bw);
