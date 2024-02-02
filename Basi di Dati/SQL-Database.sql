CREATE DOMAIN TipoBigl AS VARCHAR(8)
    CONSTRAINT verificabiglietto CHECK(VALUE IN('intero', 'ridotto'));
	
CREATE DOMAIN Email AS Varchar(30) 
	CONSTRAINT FormatoEmail CHECK(VALUE LIKE '%_@_%._%');
	
	
CREATE DOMAIN statocorsa AS Varchar(9)
    CONSTRAINT checkcorsa CHECK(VALUE IN('annullato', 'ritardo','regolare'));
	
CREATE DOMAIN tipoimbar AS Varchar(9)
    CONSTRAINT checkimbar CHECK(VALUE IN('traghetto', 'motonave','aliscafo'));
	

--Creazione delle tabelle 

CREATE TABLE Compagnia(
	NomeCompagnia 	Varchar(50)			PRIMARY KEY,
	PasswCompagnia VARCHAR(30)			NOT NULL,
	Telefono 		Varchar(11)		NOT NULL, 
	EmailCompagnia	email 			NOT NULL,
	SitoWeb			Varchar(50)		NOT NULL
);


CREATE TABLE Social(
	URL			Varchar(100)		PRIMARY KEY,
	NomeSocial 		Varchar(30)		NOT NULL, 
	CompIsc			Varchar(50)		NOT NULL,
	
	CONSTRAINT CompagniaIscritta FOREIGN KEY(CompIsc) REFERENCES Compagnia(NomeCompagnia)
		ON DELETE cascade
		ON UPDATE cascade
);


CREATE TABLE Imbarcazione(
	CodiceImbarcazione	Varchar(5)			PRIMARY KEY,
	NomeImbarcazione	Varchar(30)			NOT NULL, 
	TipoImbarcazione	tipoimbar			NOT NULL,
	CompPoss			Varchar(50)			NOT NULL,
    NumMaxPersone       int                 NOT NULL,
    NumMaxVeicoli       int                 NOT NULL,
	
	CONSTRAINT Compagnia_che_possiede FOREIGN KEY(CompPoss) REFERENCES Compagnia(NomeCompagnia)
    ON DELETE cascade 
	ON UPDATE cascade
);


CREATE TABLE Corsa(
	CodiceCorsa 	Varchar(10)		PRIMARY KEY,
    CostoCorsa      Numeric(10,2)	NOT NULL,          
	Avviso 			Varchar(40),
    Stato           statocorsa 		NOT NULL,
    FKImb           Varchar(5)      NOT NULL,
    FKComp          Varchar(50)     NOT NULL,
    	
    CONSTRAINT Imbarcazione_Utilizzata FOREIGN KEY(FKImb) REFERENCES Imbarcazione(CodiceImbarcazione)
    ON DELETE cascade 
	ON UPDATE cascade,

    CONSTRAINT FormatoCodCorsa CHECK (CodiceCorsa LIKE 'C_______S0'OR CodiceCorsa LIKE 'C_______S1' OR CodiceCorsa LIKE 'C_______S2'),
    
    CONSTRAINT Compagnia_Offerta FOREIGN KEY(FKComp) REFERENCES Compagnia(NomeCompagnia)
    ON DELETE cascade 
    ON UPDATE cascade
    
);

CREATE TABLE Passeggero(
	CF			char(16)		PRIMARY KEY,
	Nome 			Varchar(20)		NOT NULL, 
	Cognome			Varchar(30)		NOT NULL,
	DataNascita		Date			NOT NULL,
    Email			Email	NOT NULL,
	Passw			Varchar(30)	NOT NULL
);

CREATE TABLE Porto(
	IdPorto 	SERIAL			PRIMARY KEY, 
	NomePorto	Varchar(30)		NOT NULL, 
	Citta		Varchar(30)		NOT NULL,
	Nazione		Varchar(30)		NOT NULL
);




CREATE TABLE Biglietto(
	CodiceBiglietto 	Varchar(5)		PRIMARY KEY,
	TipoBiglietto 		tipobigl		NOT NULL, 
	Prezzo				Numeric(10,2)	,
	DataAcquisto		Date			NOT NULL,
   	Veicolo             boolean,
	NumBagagli			Int	NOT NULL,		
	Prenotazione		boolean 		,
	CFPass				Char(16)		NOT NULL,
	CorAs				Varchar(10)		NOT NULL,

	CONSTRAINT ProprietarioBiglietto FOREIGN KEY(CFPass) REFERENCES Passeggero(CF)
	ON DELETE set NULL 
	ON UPDATE cascade,
	
	CONSTRAINT CorsaAssociata FOREIGN KEY(CorAs) REFERENCES Corsa(CodiceCorsa)
	ON DELETE cascade 
	ON UPDATE cascade
	
);



CREATE TABLE Percorso(
	CorPer 			Varchar(10)		NOT NULL,
	IdPer		        int			NOT NULL,
        TipoPercorso            VarChar(14)              NOT NULL,
	OrarioPartenza 		Time			NOT NULL,
	OrarioArrivo 		Time			NOT NULL,
	DataAttivazione		Date			NOT NULL,
	DataScadenza		Date			NOT NULL,
	
	CONSTRAINT PKPercorso PRIMARY KEY(CorPer, IdPer),
	CONSTRAINT VerificaPercorso CHECK (TipoPercorso IN ('partenza', 'scalo', 'destinazione')),
	
	CONSTRAINT CorsaPercorsa FOREIGN KEY(CorPer) REFERENCES Corsa(CodiceCorsa)
	ON DELETE cascade 
	ON UPDATE cascade,
	
	CONSTRAINT IdPercorso FOREIGN KEY(IdPer) REFERENCES Porto(IdPorto)
	ON DELETE cascade 
	ON UPDATE cascade 	
);





--Creazione dei vari vincoli intra-relazionali

ALTER TABLE Percorso ADD CONSTRAINT checkorario 
	CHECK(((DataAttivazione <= Datascadenza) AND (OrarioPartenza<=OrarioArrivo)) OR ((DataAttivazione < Datascadenza) AND (OrarioPartenza>OrarioArrivo)));
	

ALTER TABLE Passeggero ADD CONSTRAINT emailUnicaP UNIQUE(Email);


ALTER TABLE Compagnia ADD CONSTRAINT emailUnicaC UNIQUE(EmailCompagnia);

ALTER TABLE Imbarcazione ADD CONSTRAINT nomeImbUnica UNIQUE(codiceimbarcazione, nomeimbarcazione);

ALTER TABLE Corsa ADD CONSTRAINT CostoPositivoCorsa CHECK(CostoCorsa>=0.00);
ALTER TABLE Biglietto ADD CONSTRAINT PrezzoPositivoBiglietto CHECK(Prezzo>=0.00);


--Creazione delle funzioni
CREATE OR REPLACE FUNCTION calcoloprezzo()
RETURNS TRIGGER AS $$

DECLARE
	costo Numeric(10,2);
	data_partenza Date;
	preno Boolean;
BEGIN
  
	
	SELECT CostoCorsa INTO costo 
	FROM Corsa
	WHERE CodiceCorsa=new.coras;
	
	SELECT datapartenza INTO data_partenza
	FROM Tabellone
	WHERE new.coras = codicecorsa;
	
	-- Calcola la prenotazione 
	IF(CURRENT_DATE = data_partenza) THEN
		preno = false;
	ELSE
		preno = true;
	END IF;
		
	UPDATE biglietto
	SET prenotazione = preno
	where NEW.codiceBiglietto = codiceBiglietto;

	
 	-- il prezzo di una singola valigia è di 5 euro, mentre quello della prenotazione e di 2 euro
    IF (New.tipobiglietto = 'ridotto') THEN
			IF (preno = true) THEN
		
				UPDATE Biglietto
				SET Prezzo = (costo/2) + (New.numbagagli*5)+2
				WHERE NEW.codiceBiglietto = codiceBiglietto;
		
			ELSE
				
				UPDATE Biglietto
				SET Prezzo = (costo/2) + (New.numbagagli*5)
				WHERE NEW.codiceBiglietto = codiceBiglietto;
        
			END IF;
	ELSE
		
		IF(NEW.numbagagli>0 AND preno = true) THEN
		
			UPDATE Biglietto
			SET Prezzo = costo + (New.numbagagli*5)+2
			WHERE NEW.codiceBiglietto = codiceBiglietto;
	
		-- saranno 2 euro in più
		ELSEIF (preno = true) THEN
		
			UPDATE Biglietto
			SET Prezzo = costo + 2
			WHERE NEW.codiceBiglietto = codiceBiglietto;
		
		ELSEIF(NEW.numbagagli>0) THEN
		
			UPDATE Biglietto
			SET Prezzo = costo + (New.numbagagli*5)
			WHERE NEW.codiceBiglietto = codiceBiglietto;
		ELSE
			UPDATE Biglietto
			SET Prezzo = costo
			WHERE NEW.codiceBiglietto = codiceBiglietto;
		
		END IF;
		
	END IF;

    RETURN NEW;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION controllomax()
RETURNS TRIGGER AS $$

DECLARE
	PostiPersoneDisp INTEGER;
	PostiVeicoliDisp INTEGER;
	
BEGIN
	--vado a prelevare la capienza sia per i passeggeri che veicoli disponibili chiamando la funzione getPostiDisponibili
    select persone, veicoli into PostiPersoneDisp, PostiVeicoliDisp
	FROM getPostiDisponibili(new.coras);

			
	if (PostiPersoneDisp = 0) then
		raise exception 'attenzione: capienza massima dei passeggeri raggiunta';
	end if;
	if(PostiVeicoliDisp = 0 AND new.veicolo=true) then
		raise exception 'attenzione: capienza massima dei veicoli raggiunta';
	end if;
	
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION controllopercorsi()
RETURNS TRIGGER AS $$

DECLARE
    
	numPercorsi Integer;	
BEGIN
	if(new.tipoPercorso='partenza') then
		--se sto inserando un percorso di partenza, vado a vedere se per quella corsa c'è già
		SELECT count(*) into numPercorsi
		FROM percorso
		where corper=new.corper and tipoPercorso='partenza';
		
		if(numPercorsi<>0) then
			raise exception 'attenzione: la corsa (%) ha già un porto di partenza', new.corper;
		end if;
	else
		if(new.tipoPercorso='destinazione') then
			--se sto inserando un percorso di destinazione, vado a vedere se per quella corsa c'è già
			SELECT count(*) into numPercorsi
			FROM percorso
			where corper=new.corper and tipoPercorso='destinazione';
		
			if(numPercorsi<>0) then
				raise exception 'attenzione: la corsa (%) ha già un porto di destinazione', new.corper;
			end if;
		else
			--se sto inserando un percorso di scalo, vado a vedere se per quella corsa c'è già
			SELECT count(*) into numPercorsi
			FROM percorso
			where corper=new.corper and tipoPercorso='scalo';
		
			if(numPercorsi<>0) then
				raise exception 'attenzione: la corsa (%) ha già un porto di scalo', new.corper;
			end if;
		end if;
	end if;
			

    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION corsaValida()
RETURNS TRIGGER AS $$

DECLARE
    
	numPercorsi Integer;	
BEGIN
	SELECT count(*) into numPercorsi
		FROM percorso
		where corper=new.coras and (tipoPercorso='partenza' or tipoPercorso='destinazione');
	
		--se la corsa ha un percorso partenza e destinazione, allora va bene
		
		if(numPercorsi<>2) then
			raise exception 'attenzione: la corsa (%) non è valida. Non ha ancora una destinazione/partenza decisa', new.coras;
		end if;
	

    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION noModificaPercorso()
RETURNS TRIGGER AS $$

BEGIN
	
	raise exception 'attenzione: è vietato modificare i percorsi. Cancella prima la corsa e inserisci di nuovo i percorsi';
	

    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION noModificaCorsaImb()
RETURNS TRIGGER AS $$

BEGIN
	
	raise exception 'attenzione: è vietato cambiare imbarcazione';
	

    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION imbarcazioniGiorni()
RETURNS TRIGGER AS $$

DECLARE
    
	risultato Integer;	
	compagnia_nuovo VARCHAR(30);
	imbarcazione_nuovo VARCHAR(5);
	
BEGIN
	SELECT DISTINCT fkcomp into compagnia_nuovo
		FROM corsa join percorso on codicecorsa=new.corper
		where corper=new.corper;
		
	SELECT DISTINCT fkimb into imbarcazione_nuovo
		FROM corsa join percorso on codicecorsa=new.corper
		where corper=new.corper;

	--dopo aver prelevato la compagnia e l'imbarcazione, controllo se l'imbarcazione è utilizzata o meno nello stesso intervallo di partenza e scadenza
		
	SELECT count(*) into risultato
	FROM (Corsa join tappainiziale as ti on codicecorsa=ti.corper) join tappafinale as tf on ti.corper=tf.corper
	where (substring(codicecorsa,2,7)<>substring(new.corper,2,7)) and corsa.fkimb=imbarcazione_nuovo and corsa.fkcomp=compagnia_nuovo
	and ((new.dataattivazione<dataarrivo) and(new.datascadenza>datapartenza));
	
	
		
		if(risultato<>0) then
			raise exception 'ATTENZIONE: quella imbarcazione è già usata in quella data, usa una imbarcazione diversa da (%)', imbarcazione_nuovo;
		end if;
	

    RETURN NEW;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION imbarcazioneGiusta()
RETURNS TRIGGER AS $$

DECLARE
    
	risultato Integer;	
BEGIN
	SELECT count(*) into risultato
		FROM imbarcazione
		where codiceimbarcazione=new.fkimb and compposs=new.fkcomp;
	
	
		
		if(risultato=0) then
			raise exception 'ATTENZIONE: quella imbarcazione non è proprieta di (%)', new.fkcomp;
		end if;
	

    RETURN NEW;
END; $$ LANGUAGE plpgsql;







--Creazione dei vincoli inter-relazionali (Trigger)
CREATE TRIGGER calcoloprezzo
AFTER INSERT ON biglietto
FOR EACH ROW
EXECUTE PROCEDURE calcoloprezzo();

CREATE TRIGGER calcolomaxpersone
BEFORE INSERT ON biglietto
FOR EACH ROW
EXECUTE PROCEDURE controllomax();

CREATE TRIGGER numpercorsi
BEFORE INSERT ON percorso
FOR EACH ROW
EXECUTE PROCEDURE controllopercorsi();

CREATE TRIGGER ControlloCorsa
BEFORE INSERT ON biglietto
FOR EACH ROW
EXECUTE PROCEDURE corsaValida();

CREATE or REPLACE TRIGGER noModificaPercorso
BEFORE UPDATE ON percorso
FOR EACH ROW
EXECUTE PROCEDURE noModificaPercorso();

CREATE or REPLACE TRIGGER noModificaCorsaImb
BEFORE UPDATE OF fkimb ON Corsa
FOR EACH ROW
EXECUTE PROCEDURE noModificaCorsaImb();

CREATE TRIGGER CheckImbarcazione
BEFORE INSERT ON Corsa
FOR EACH ROW
EXECUTE PROCEDURE imbarcazioneGiusta();

CREATE TRIGGER imbarcazioniGiorniDiversi
BEFORE INSERT ON percorso
FOR EACH ROW
EXECUTE PROCEDURE imbarcazioniGiorni();




--Views
create view tappafinale as(select percorso.corper, percorso.idper, percorso.TipoPercorso, percorso.datascadenza AS dataarrivo, percorso.orarioarrivo,
    porto.nomeporto AS destinazione, porto.citta AS cittadestinazione, porto.nazione AS nazionedestinazione
from percorso JOIN porto ON percorso.idper = porto.idporto
where tipopercorso = 'destinazione');

create view tappainiziale as(select percorso.corper, percorso.idper, percorso.TipoPercorso, percorso.dataattivazione AS datapartenza, percorso.orariopartenza, 
porto.nomeporto AS partenza, porto.citta AS cittapartenza, porto.nazione AS nazionepartenza
from percorso JOIN porto ON percorso.idper = porto.idporto
where tipopercorso = 'partenza');

create view scali as(
select corper, count(*)-2 as scali
from percorso
group by corper);

CREATE VIEW Tabellone as(
SELECT CodiceCorsa,costocorsa,scali,corsa.fkcomp AS nomecompagnia,partenza,cittapartenza,nazionepartenza,destinazione,cittadestinazione,nazionedestinazione,datapartenza,dataarrivo,orariopartenza,orarioarrivo,stato,avviso
FROM ((Corsa join tappainiziale as ti on codicecorsa=ti.corper) join tappafinale as tf on ti.corper=tf.corper)join scali on codicecorsa=scali.corper);

CREATE VIEW bigliettiAcquistati AS(
select codicecorsa,cf,nome,cognome,datanascita,codicebiglietto,tipobiglietto,prezzo,dataacquisto,veicolo,numbagagli,prenotazione
from (corsa join biglietto on codicecorsa=coras) join passeggero on cfpass=cf
order by dataacquisto desc
);

CREATE VIEW CorseIncomplete AS (
select codicecorsa from corsa 
except 
SELECT codicecorsa FROM corsa left join percorso on codicecorsa=corper WHERE tipoPercorso='partenza' or tipoPercorso='destinazione'
group by codicecorsa
having count(*)=2);



--PROCEDURA PER INSERIRE IMBARCAZIONE:

CREATE OR REPLACE PROCEDURE AggiungiImbarcazione( 
    CodImbar varchar(5), 
    NomeImbar varchar(30),  
    TipoImbar tipoImbar,  
    NomeCompPoss varchar(50),  -- Nome della compagnia che la possiede
    MaxPersone int, 
    MaxVeicoli int
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Imbarcazione
    VALUES (CodImbar,NomeImbar,TipoImbar,NomeCompPoss,MaxPersone, MaxVeicoli);
END; $$;



--Procedura per aggiungere biglietto:

CREATE OR REPLACE PROCEDURE AcquistaBiglietto( 
    codicebiglietto varchar(5), 
    vtipobiglietto tipobigl,
    dataacquisto date,  
    veicolo boolean,  
    numerobagagli int, 
    cfpass varchar(16), 
    varcoras varchar(5)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Biglietto(codicebiglietto, tipobiglietto ,dataacquisto, veicolo, numbagagli, cfpass, coras)
    VALUES (codicebiglietto, vtipobiglietto, dataacquisto, veicolo, numerobagagli, cfpass, varcoras);
END; $$;



CREATE OR replace PROCEDURE cambiastato(Codice VARCHAR(10),messaggio VARCHAR(40), statop statocorsa, NomeCompagnia VARCHAR(50))
as $$
begin
	update Corsa 
	set stato=statop, Avviso=messaggio
	where CodiceCorsa=Codice AND FKComp = NomeCompagnia;
EXCEPTION
	WHEN others THEN
		RAISE EXCEPTION 'Errore: inserisci uno stato tra regolare, annullato o ritardo ';

end;
$$  LANGUAGE plpgsql;

CREATE FUNCTION incassicorsa(Codice VARCHAR(10))
RETURNS NUMERIC AS $$
DECLARE somma numeric(10,2) := 0.0;
var numeric(10,2) :=0.0;
cursor1 cursor for select Prezzo from biglietto join Corsa on Coras=CodiceCorsa WHERE CodiceCorsa=Codice;
BEGIN
        OPEN cursor1;
    LOOP
        FETCH cursor1 INTO var;
        EXIT WHEN NOT FOUND;
        somma := somma+var;
    END LOOP;
    CLOSE cursor1;
			

        RETURN somma;
END;
$$  LANGUAGE plpgsql;


-- Procedura per aggiungere un nuovo passeggero

CREATE OR REPLACE PROCEDURE AggiungiPass(CF CHAR(16),Nome VARCHAR(20),Cognome VARCHAR(30), dataNascita date,Email VARCHAR(30), Passw VARCHAR(30))
as $$
begin
	INSERT INTO Passeggero
	VALUES(CF, Nome, Cognome, dataNascita, Email, Passw);
end;
$$  LANGUAGE plpgsql;



--Restituisce il numero di posti per le persone e per i veicoli ancora disponibili per una corsa
CREATE or replace function getPostiDisponibili(CodCorsa varchar(10), OUT persone Integer, Out veicoli integer) AS $$
DECLARE
	v1 int;
	v2 int;
	p1 int;
	p2 int;
BEGIN
	


	IF(CodCorsa like 'C_______S0') THEN
	   select (SELECT nummaxveicoli
		FROM imbarcazione JOIN corsa ON codiceimbarcazione = FKImb
		WHERE codiceCorsa = CodCorsa)
		-
		(SELECT count(*) 		
		FROM biglietto					
		WHERE coras = CodCorsa AND veicolo = true)
		into veicoli;
		
		select (SELECT nummaxpersone 
		 FROM imbarcazione JOIN corsa ON codiceimbarcazione = FKImb 
		 WHERE codiceCorsa = CodCorsa)
		 -
		 (SELECT count(*)
		 FROM biglietto 
		 WHERE coras = CodCorsa) into persone;
		 
		 --calcola numero di posti dei veicoli occupati nella prima corsa
		SELECT count(*)into v1 		
		FROM biglietto					
		WHERE coras = regexp_replace(CodCorsa, '.$', '1') AND veicolo = true;
			
		--calcola numero di posti dei veicoli occupati nella seconda corsa	
		SELECT count(*)into v2 		
		FROM biglietto					
		WHERE coras = regexp_replace(CodCorsa, '.$', '2') AND veicolo = true;

		if(v1 >v2) then
			veicoli:= veicoli-v1;
		else
			veicoli:=veicoli-v2;
		end if;

		--calcola numero di posti di persone occupate nella prima corsa
		SELECT count(*)into p1
		 FROM biglietto 
		WHERE coras = regexp_replace(CodCorsa, '.$', '1');

		--calcola numero di posti di persone occupate nella seconda corsa
		SELECT count(*)into p2
		 FROM biglietto 
		 WHERE coras = regexp_replace(CodCorsa, '.$', '2');

		--sottrae ai posti delle corsa intera solo il valore più grande tra i due
		if(p1>p2)then
			persone:= persone - p1;	 
		else			
			persone:= persone - p2;
		end if;
		
				
				
		 
		 
		ELSEIF(CodCorsa like 'C_______S1') then
			
				select (SELECT nummaxveicoli
				FROM imbarcazione JOIN corsa ON codiceimbarcazione = FKImb
				WHERE codiceCorsa = CodCorsa)
				-
				(SELECT count(*) 		
				FROM biglietto					
				WHERE coras = CodCorsa AND veicolo = true)
				into veicoli;

				select (SELECT nummaxpersone 
				 FROM imbarcazione JOIN corsa ON codiceimbarcazione = FKImb 
				 WHERE codiceCorsa = CodCorsa)
				 -
				 (SELECT count(*)
				 FROM biglietto 
				 WHERE coras = CodCorsa) into persone;
				 
				--Calcolo posti occupati dalla corsa principale
				CodCorsa := regexp_replace(CodCorsa, '.$', '0');

				veicoli := veicoli -(SELECT count(*) 		
									FROM biglietto					
									WHERE coras = CodCorsa AND veicolo = true);

				persone := persone - (SELECT count(*)
									 FROM biglietto 
		 							 WHERE coras = CodCorsa);
				 
			 ELSEIF(CodCorsa like 'C_______S2') then
			 	select (SELECT nummaxveicoli
				FROM imbarcazione JOIN corsa ON codiceimbarcazione = FKImb
				WHERE codiceCorsa = CodCorsa)
				-
				(SELECT count(*) 		
				FROM biglietto					
				WHERE coras = CodCorsa AND veicolo = true)
				into veicoli;

				select (SELECT nummaxpersone 
				 FROM imbarcazione JOIN corsa ON codiceimbarcazione = FKImb 
				 WHERE codiceCorsa = CodCorsa)
				 -
				 (SELECT count(*)
				 FROM biglietto 
				 WHERE coras = CodCorsa) into persone;
				 
				--Calcolo posti occupati dalla corsa principale
				CodCOrsa := regexp_replace(CodCorsa, '.$', '0');

				veicoli := veicoli -(SELECT count(*) 		
									FROM biglietto					
									WHERE coras = CodCorsa AND veicolo = true);

				persone := persone - (SELECT count(*)
									 FROM biglietto 
		 							 WHERE coras = CodCorsa);
			 	
			 END IF;
		 END;
$$ LANGUAGE plpgsql;
