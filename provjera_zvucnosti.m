function [vrsta] = provjera_zvucnosti(glasovi)

    % Ova funkcija raèuna da li je prozor zvuèan ili bezvuèan

    brojac_z = 0;
    brojac_b = 0;
    brojac_n = 0;
    
    for i = 1:1:length(glasovi);
        if strcmp(glasovi(i),'a') || strcmp(glasovi(i),'a:') || strcmp(glasovi(i),'e')|| strcmp(glasovi(i),'e:') || strcmp(glasovi(i),'i')|| strcmp(glasovi(i),'i:') || strcmp(glasovi(i),'o')|| strcmp(glasovi(i),'o:') || strcmp(glasovi(i),'u')|| strcmp(glasovi(i),'u:') || strcmp(glasovi(i),'j') || strcmp(glasovi(i),'l') || strcmp(glasovi(i),'lj') || strcmp(glasovi(i),'r') || strcmp(glasovi(i),'m') || strcmp(glasovi(i),'n') || strcmp(glasovi(i),'nj')
            brojac_z = brojac_z + 1;
        elseif strcmp(glasovi(i),'p') || strcmp(glasovi(i),'t') || strcmp(glasovi(i),'k') || strcmp(glasovi(i),'s') || strcmp(glasovi(i),'š') || strcmp(glasovi(i),'è') || strcmp(glasovi(i),'æ') || strcmp(glasovi(i),'f') || strcmp(glasovi(i),'h') || strcmp(glasovi(i),'c')
            brojac_b = brojac_b + 1;
        elseif strcmp(glasovi(i),'sil');
            brojac_n =  brojac_n + 1;
        else
            brojac_n =  brojac_n + 1;
        end
    end
    
    if (brojac_z > brojac_b) && (brojac_z > brojac_n);
        vrsta = 'zvuèan';
    elseif (brojac_b > brojac_z) && (brojac_b > brojac_n);
        vrsta = 'bezvucan';
    elseif (brojac_n > brojac_z) && (brojac_n > brojac_b);
        vrsta = 'neodreðeno';
    elseif (brojac_z == brojac_b) || (brojac_z == brojac_n);
        vrsta = 'zvuèan';
    elseif (brojac_b == brojac_n);
        vrsta = 'bezvuèan';
    end
end

