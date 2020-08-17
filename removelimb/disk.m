function [ im ] = disk(M,N,r0)
[X, Y]=meshgrid(-N/2:N/2-1,-M/2:M/2-1);
r=(X).^2+(Y).^2;
r=sqrt(r);
im=r<r0;

end

