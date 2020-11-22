function [ B ] = prepare( A, p )


B = double(A);
B( B >= p ) = p - 1;

end