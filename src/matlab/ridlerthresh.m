function threshold = ridlerthresh(img, tolerance)
%RIDLERTHRESH Compute an image threshold value using Ridler/Calvard's algorithm.
%  RIDLERTHRESH returns an integer between 0 and 1 that represents a normalized image threshold value 
%  that segments the input image, according to Ridler/Calvard's algorithm.
%  
%  Synopsis:
%      threshold = ridlerthresh(img)
%      threshold = ridlerthresh(img, tolerance)
%
%  Input:
%      img       = input image to be segmented (required)
%      tolerance = amount of difference between a current and previous threshold value
%                  until convergence is determined. Default = 0.5
%  
%  Output:
%      threshold = value between 0 and 1 representing the threshold.
%
%  Reference:
%      Ridler TW, Calvard S. (1978) "Picture thresholding using an iterative selection method", IEEE Trans. System, Man and Cybernetics, SMC-8: 630-632
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

%  Created: August 2012

if nargin < 1
  error('ridlerthresh: you must provide an input image'); 
elseif nargin < 2
  tolerance = 0.5;
end	

% Check if input image is rgb and convert to a gray-level image
if ndims(img) == 3
  img = rgb2gray(img);
end 

[hist,x] = imhist(img);

m = mean2(img);

% Our initial estimation is the mean value
new_thresh = m;

while true
  prev_thresh = new_thresh;
  threshold = round(prev_thresh);

  mb = mean2(img(img <= threshold));
  mo = mean2(img(img > threshold));

  new_thresh = (mb+mo) / 2;
  if abs(new_thresh-prev_thresh) <= tolerance
    break
  end
end	
threshold = threshold / 255;

end
