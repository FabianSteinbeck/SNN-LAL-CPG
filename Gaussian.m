function[y] = Gaussian(x,mu,sigma)

y = 1/(sigma*sqrt(2*pi))*exp(-0.5*((x-mu).^2/(sigma^2)));

end