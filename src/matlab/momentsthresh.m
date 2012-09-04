function threshold = momentsthresh(img)
%MOMENTSTHRESH Compute an image threshold value using preservation of image moments, as proposed by Tsai.
%  MOMENTSTHRESH returns an integer between 0 and 1 that represents a normalized image threshold value 
%  that segments the input image, according to Tsai's moment-preservation algorithm (see reference).
%  
%  Synopsis:
%      threshold = momentsthresh(img)
%
%  Input:
%      img       = input image to be segmented (required)
%  
%  Output:
%      threshold = value between 0 and 1 representing the threshold.
%
%  Reference:
%      Tsai W. (1985) Moment-preserving thresholding: a new approach, Computer Vision, Graphics, and Image Processing, vol. 29, pp. 377-393
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

%  Created: September 2012

if nargin < 1 || nargin > 1
  error('momentsthresh: you must provide an input image');
end	

% Check if input image is rgb and convert to a gray-level image
if ndims(img) == 3
  img = rgb2gray(img);
end 

n = 256;

[histogram,x] = imhist(im2double(img));

% Normalize histogram
norm_hist = histogram ./ sum(histogram);

% Calculate the first four order moments
m0 = 1.0;
m1 = 0.0;
m2 = 0.0;
m3 = 0.0;

for ix = 1:n
  m1 = m1 + ix * norm_hist(ix);
  m2 = m2 + ix * ix * norm_hist(ix);
  m3 = m3 + ix * ix * ix * norm_hist(ix);
end

cd = m0 * m2 - m1 * m1;
c0 = (-m2 * m2 + m1 * m3) / cd;
c1 = (m0 * -m3 + m2 * m1) / cd;
z0 = 0.5 * (-c1 - sqrt(c1 * c1 - 4.0 * c0));
z1 = 0.5 * (-c1 + sqrt(c1 * c1 - 4.0 * c0));

p0 = (z1 - m1) / (z1 - z0);

partial_sum = 0.0;

for ix = 1:n
  partial_sum = partial_sum + norm_hist(ix);
  if partial_sum > p0
    threshold = ix;
    break
  end
end

threshold = threshold / n;
