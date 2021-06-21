% from precip_init.f90

gam3 = 3.;
gamr1 = 3.+b_rain;
gamr2 = (5.+b_rain)/2.;
gamr3 = 4.+b_rain;
gams1 = 3.+b_snow;
gams2 = (5.+b_snow)/2.;
gams3 = 4.+b_snow;
gamg1 = 3.+b_grau;
gamg2 = (5.+b_grau)/2.;
gamg3 = 4.+b_grau;
gam3 = gamma(gam3);
gamr1 = gamma(gamr1);
gamr2 = gamma(gamr2);
gamr3 = gamma(gamr3);
gams1 = gamma(gams1);
gams2 = gamma(gams2);
gams3 = gamma(gams3);
gamg1 = gamma(gamg1);
gamg2 = gamma(gamg2);
gamg3 = gamma(gamg3);

for k=1:num_z
        
  pratio = sqrt(1.29 / rho(k));

  rrr1=393./(tabs0(k)+120.)*(tabs0(k)/273.)^1.5;
  rrr2=(tabs0(k)/273.)^1.94*(1000./pres0(k));

  estw = 100.0*esatw(tabs0(k)); % convert to Pa
  esti = 100.0*esati(tabs0(k)); % convert to Pa

% accretion by snow:

  coef1 = 0.25 * pi * nzeros * a_snow * gams1 * pratio/ ...
            (pi * rhos * nzeros/rho(k) ) ^ ((3+b_snow)/4.);
  coef2 = exp(0.025*(tabs0(k) - 273.15));
  accrsi(k) =  coef1 * coef2 * esicoef;
  accrsc(k) =  coef1 * esccoef;
  coefice(k) =  coef2;

% evaporation of snow:

  coef1  =(lsub/(tabs0(k)*rv)-1.)*lsub/(therco*rrr1*tabs0(k));
  coef2  = rv*tabs0(k)/(diffelq*rrr2*esti);
  evaps1(k)  =  0.65*4.*nzeros/sqrt(pi*rhos*nzeros)/(coef1+coef2)/sqrt(rho(k));
  evaps2(k)  =  0.49*4.*nzeros*gams2*sqrt(a_snow/(muelq*rrr1))/ ...
       (pi*rhos*nzeros)^((5+b_snow)/8.) / (coef1+coef2) ...
               * rho(k)^((1+b_snow)/8.)*sqrt(pratio);

% accretion by graupel:

  coef1 = 0.25*pi*nzerog*a_grau*gamg1*pratio/...
          (pi*rhog*nzerog/rho(k))^((3+b_grau)/4.);
  coef2 = exp(0.025*(tabs0(k) - 273.15));
  accrgi(k) =  coef1 * coef2 * egicoef;
  accrgc(k) =  coef1 * egccoef;

% evaporation of graupel:

  coef1  =(lsub/(tabs0(k)*rv)-1.)*lsub/(therco*rrr1*tabs0(k));
  coef2  = rv*tabs0(k)/(diffelq*rrr2*esti);
  evapg1(k)  = 0.65*4.*nzerog/sqrt(pi*rhog*nzerog)/(coef1+coef2)/sqrt(rho(k));
  evapg2(k)  = 0.49*4.*nzerog*gamg2*sqrt(a_grau/(muelq*rrr1))/ ...
        (pi * rhog * nzerog)^((5+b_grau)/8.) / (coef1+coef2) ...
               * rho(k)^((1+b_grau)/8.)*sqrt(pratio);


% accretion by rain:

  accrrc(k)=  0.25 * pi * nzeror * a_rain * gamr1 * pratio/ ...
              (pi * rhor * nzeror / rho(k))^((3+b_rain)/4.)* erccoef;

% evaporation of rain:

  coef1  =(lcond/(tabs0(k)*rv)-1.)*lcond/(therco*rrr1*tabs0(k));
  coef2  = rv*tabs0(k)/(diffelq * rrr2 * estw);
  evapr1(k)  =  0.78 * 2. * pi * nzeror / ...
        sqrt(pi * rhor * nzeror) / (coef1+coef2) / sqrt(rho(k));
  evapr2(k)  =  0.31 * 2. * pi  * nzeror * gamr2 * ...
                0.89 * sqrt(a_rain/(muelq*rrr1))/ ...
        (pi * rhor * nzeror)^((5+b_rain)/8.) / (coef1+coef2) ...
             * rho(k)^((1+b_rain)/8.)*sqrt(pratio);

end % for


% from precip_fall
crain = b_rain / 4.;
csnow = b_snow / 4.;
cgrau = b_grau / 4.;
vrain = a_rain * gamr3 / 6. / (pi * rhor * nzeror)^crain;
vsnow = a_snow * gams3 / 6. / (pi * rhos * nzeros)^csnow;
vgrau = a_grau * gamg3 / 6. / (pi * rhog * nzerog)^cgrau;

for k = 1:num_z
   rhofac(k) = sqrt(1.29/rho(k)); % Factor in precipitation velocity formula
end

