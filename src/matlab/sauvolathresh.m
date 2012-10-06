function output = sauvolathresh(img, win_size, k_value, r_value)
%SAUVOLATHRESH Compute an image threshold value using Sauvola/Pietaksinen algorithm.
%  SAUVOLATHRESH returns a binarized image using the Sauvola/Pietaksinen's document binarization algorithm.
%  
%  Synopsis:
%      output = sauvolathresh(img)
%      output = sauvolathresh(img, win_size)	 
%      output = sauvolathresh(img, win_size, k_value)
%      output = sauvolathresh(img, win_size, k_value, r_value)
%
%  Input:
%      img = input image to be segmented (required)
%      win_size = window size around each pixel (required)
%      k_value = constant ranging between 0.2 and 0.5 (default)
%      r_value = estimated maximum value of the standard deviation (128 works well for grayscale documents)
%  
%  Output:
%      output = binarized image according to the threshold value computed by the algorithm.
%
%  Reference:
%      Sauvola, J & Pietaksinen, M (2000), "Adaptive Document Image Binarization", Pattern Recognition 33(2): 225-236
%
%  Copyright (C) 2012 Daniel Martín 
%
%  This file is part of Thresh-mat.
%
%  Thresh-mat is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with Thresh-mat; If not, see <http://www.gnu.org/licenses/>.

%  Created: October 2012

if nargin < 1 || nargin > 4
  error('sauvolathresh: you must provide an input image and a window size.'); 
elseif nargin == 2
  k_value = 0.5;
  r_value = 128.0;
elseif nargin == 3
  r_value = 128.0;
end	

% Window size must be positive and odd
if win_size <= 0 || mod(win_size, 2) == 0
  error('sauvolathresh: window size must be positive and odd');
end

% Check if input image is rgb and convert to a gray-level image
if ndims(img) == 3
  img = rgb2gray(img);
end

% Convert the input image to double before doing the computations
img = double(img);

mean           = imfilter(img, fspecial('average', win_size));
stdeviation    = stdfilt(img, ones(win_size, win_size));

threshold = (mean .* (1.0 + k_value .* ((stdeviation ./ r_value) - 1.0)));

diff = threshold - img;

bw          = (diff >= 0);
output      = imcomplement(bw);
