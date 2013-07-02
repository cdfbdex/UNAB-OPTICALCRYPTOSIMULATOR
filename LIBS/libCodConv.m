function enc=libCodConv(x,k);
%
%  convolenc  -performs convolutional encoding
%  Convolutional Encoder with m shift register stages

%  x- input - the binary data to be encoded
%  input sequence can be of any length
%  k -constraint length
%  k can take any value greater than 3
%  m -number of shift registers
%  L -size of the input array
%  returns encoded bits


%obtain the state changed matrix of the input

L=size(x);
m=k-1;
n=L(2);
for i=1:n
    z(i+m)=x(i);
end
g=size(z);
gen=g(2);
z(n+2*m)=0;
for d=1:gen
    e=d-1;
    for j=1:k
        y(j,d)=z(j+e);
    end
end

%Perform modulo 2 additions

g=1;
for f=1:gen

    r(f)=and(y(g,f),y(g+k-1,f));
    t(f)=or(y(g,f),y(g+k-1,f));
    u(f)=not(r(f));
    v(f)=and(u(f),t(f));
    r1(f)=and(y(g,f),y(g+k-2,f));
    t1(f)=or(y(g,f),y(g+k-2,f));
    u1(f)=not(r1(f));
    v1(f)=and(u1(f),t1(f));
    r2(f)=and(v1(f),y(g+k-1,f));
    t2(f)=or(v1(f),y(g+k-1,f));
    u2(f)=not(r2(f));
    v2(f)=and(u2(f),t2(f));
end

%Multiplex path1 and path2 outputs by merging

c=2*f;
y=0;
for x=1:2:c
    enc(x)=v(x-y);
    y=y+1;
end
a=1;
for z=2:2:c
    enc(z)=v2(z-a);
    a=a+1;
end
enc = fliplr(enc);