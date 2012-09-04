## Copyright (C) 2012 Daniel Martín 
##
## This file is part of Thresh-mat.
##
## Thresh-mat is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Thresh-mat; If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {} ridlerthresh (@var{img},@var{tolerance})
## RIDLERTHRESH(img) returns an integer between 0 and 1 that represents a normalized image threshold value 
## that segments the input image, according to Ridler/Calvard's algorithm.
## @end deftypefn

## Author: Daniel Martín <dmartin1@estumail.ucm.es>
## Created: August 2012

function threshold = ridlerthresh(img, tolerance)
  
  if (nargin < 1 || nargin > 2)
    print_usage();
  elseif (nargin < 2)
    tolerance = 0.5;
  endif	

  ## Check if input image is rgb and convert to a gray-level image
  if (ndims(img) == 3)
    img = rgb2gray(img);
  endif

  n = 256; 

  m = mean2(img);

  ## Our initial estimation is the mean value
  new_thresh = m;

  while true
    prev_thresh = new_thresh;
    threshold = round(prev_thresh);

    mb = mean2(img(img <= threshold));
    mo = mean2(img(img > threshold));

    new_thresh = (mb+mo) / 2;
    if (abs(new_thresh-prev_thresh) <= tolerance)
      break
    endif
  endwhile	
  
  threshold = threshold / n;

endfunction
