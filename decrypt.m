function [ original ] = decrypt( shadows, x, p, originalVelicina )

original = ones( originalVelicina(1),originalVelicina(2));

[visina,sirina,brojSenki] = size(shadows);
brojPikselaSenke = visina*sirina;

k = (originalVelicina(1)*originalVelicina(2))/(visina*sirina);
if brojSenki > k
    brojSenki = k;
    x = x(1:k); 
end

for i = 1:visina*sirina
     y = shadows(i:brojPikselaSenke:i + (brojSenki-1)*brojPikselaSenke);  
     koeficijenti = lagrangeInterpolation(x,y,p);    
    pocetak = (i-1)*brojSenki + 1;
    kraj = pocetak + brojSenki - 1;
    original(pocetak:kraj) = koeficijenti;    
end

end
