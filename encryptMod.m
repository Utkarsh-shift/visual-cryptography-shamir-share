function [ shadows ] = encryptMod( A, k, n, p, x )

velicinaSlike = size(A);
brojPiksela = velicinaSlike(1)*velicinaSlike(2); 
brojPikselaSenke = brojPiksela/k; 

a = int64(sqrt(brojPikselaSenke));
for i = a:-1:1
    if( rem(brojPikselaSenke,i) == 0 )
        a = i;
        break;
    end
end
b = brojPikselaSenke/a;

shadows = zeros(b,a,n);

for i = 1:brojPikselaSenke
    polinom = A(i:brojPikselaSenke:end);  
    shadows( i:brojPikselaSenke:i+(n-1)*brojPikselaSenke ) = mod(polyval(polinom,x),p);
end

end