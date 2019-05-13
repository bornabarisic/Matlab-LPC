close all;
clear all;
clc;

% -------------------------------------------------------------------------
% Uèitavanje .waw audio datoteke te množenje audio signala s hammingovim 
% prozorom od L = 320 frameova kako bi založili signal na manje djelove
% Dovivamo listu vektora sa svim prozorima (lista_vektora{i})

[Y,FS,WMODE,FIDX] = v_readwav('vrem.wav','s',-1,-1);

% Generiranje funkcije prozora
L = 320;
window = hamming(L);

% Ispis podataka o sound datoteci
Podaci = FIDX;

% figure(1)
% plot(window)
% grid on;
% title('Hamming prozor')
% xlim([0 320])
% ylim([0 1.1])
% 
% figure(2)
% plot(Y)
% grid on;
% title('Audio signal')
% xlim([0 160082])

lista_vektora = {};

buffer = 0;
j = 1;
index_glasova = 1;

for i = 1:1:FS;
    if mod(i, L) ~= 0
        buffer(j) = Y(i);
        j = j + 1;
    else         
        buffer(j) = Y(i);      
        prozor = buffer.*transpose(window); % prozori umnozak hamm i signala 80frame
        j = 1;
        lista_vektora{index_glasova} = prozor; 
        index_glasova = index_glasova + 1;
        % % staviti u petlji ispod varijable rez za prikaz svih frameova
%         figure()
%         plot(prozor)
%         hold on
%         plot(window)
%         hold on
%         plot(Y)
%         grid on;
%         xlim([0 L])
%         ylim([-1.1 1.1])
%         legend('sig','win','Y')    
    end
end

% Dobivena lista vektora
lista_vektora;
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Uèitavanje .lab datoteke i spremanje podataka o glasovima i njihovim
% trajanjima
fileName = 'vrem.lab';
fileID = fopen(fileName,'r');
podaci = textscan(fileID, '%f %f %s');
fclose(fileID);

start_vrijeme = podaci{1};
stop_vrijeme = podaci{2};
glasovi = podaci{3};

% konverzija vremena zapoèinjanja glasa i završavanja glasa u ms
start_ms = start_vrijeme/10000;
stop_ms = stop_vrijeme/10000;

start_ms = start_ms / 10;
stop_ms = stop_ms / 10;

% izraèun trajanja pojedinog glasa u ms 
trajanje_ms = (stop_ms - start_ms);
% konverzija trajanja u frame-ove [1s=16000 => 1ms=16]
trajanje_glas_frame = trajanje_ms * 16;
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Dodjeljivanje slova u svaki prozor 
lista_glasovi_frame = {};
glasovi_frame = {};

broj_prozora = 1;
k = 1;
z = 1;
it = 1;
index = 320;

zbroj = trajanje_glas_frame(1);
razlika = L - zbroj;
glasovi_frame(k) = glasovi(z);

while (broj_prozora < 51);
    
    while (razlika > 0);        
        k = k + 1;
        z = z + 1;
        
        if (z > 137);
            break
        end
        
        glasovi_frame(k) = glasovi(z);      
        zbroj = zbroj + trajanje_glas_frame(z);
        razlika = L - zbroj;
    end 
    
    if (razlika == 0);
        zbroj = 0;
        razlika = L - trajanje_glas_frame(z+1);
        k = 0;
        
    elseif(razlika < 0);
        razlika = razlika * (-1);
        zbroj = razlika - trajanje_glas_frame(z);
        z = z - 1;
        k = 0;
    end
    
    lista_glasovi_frame{it} = glasovi_frame;
    glasovi_frame = {};
    
    it = it + 1;        
    index = index + L;
    broj_prozora = broj_prozora + 1;
end

% Dobivena lista vektora s pripadajuæim slovima 
lista_glasovi_frame;
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Raèunanje zvuènosti/bezvuènosti prozora
lista_zvucnosti = [];
for i = 1:1:length(lista_glasovi_frame);    
    lista_zvucnosti{i} = provjera_zvucnosti(lista_glasovi_frame{i});
end

% Dobivena lista zvuènosti za svaki vektor
lista_zvucnosti;
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Racunanje autokorelacijske LPC analize prozora
p = 12;     % red 
w = 'm';    % hammingov prozor
mode = 'e'; 

lista_coeficijenata = {};

% Dobivamo listu koeficijenata za svaki frame (lista_coeficijenata{i})
for i = 1:1:length(lista_vektora);
    sig = lista_vektora{i};
    [ar, e, k] = v_lpcauto(sig,p,[],w,mode);
    lista_coeficijenata{i} = ar;
end

% Dobivena lista LPC koeficijenata za svaki vektor
lista_coeficijenata;
% ------------------------------------------------------------------------- 

lista_coeficijenata{1}
rez = mean(lista_coeficijenata{1})

