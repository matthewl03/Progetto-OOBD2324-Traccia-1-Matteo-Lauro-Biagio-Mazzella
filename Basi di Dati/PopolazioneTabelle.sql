INSERT INTO Compagnia (NomeCompagnia, PasswCompagnia, Telefono, EmailCompagnia, SitoWeb)
VALUES ('MSC', 'msc_passw','3341111111', 'msc@email.it', 'www.msc.it'),
	('Costa', 'costa_passw', '6249909909', 'costa@email.it', 'www.costa.it'),
	('Royal Caribbean', ' RC_passw', '7924975238', ' RoyalCaribbean@email.it', 'www. RoyalCaribbean.it'),
	('Celebrity Cruises', 'CC_passw', '3682985185', 'CelebrityCruises@email.it', 'www.CelebrityCruises.it'),
	('Holland America Line', 'HAL_passw', '2499099096', 'HollandAmericaLine@email.it', 'www.HollandAmericaLine.it');

-- Inserimento dati nella tabella Social
INSERT INTO Social (URL, NomeSocial, CompIsc)
VALUES ('www.twitter.com/msc', 'Twitter', 'MSC'),
	('www.facebook.com/msc','Facebook','MSC');

-- Inserimento dati nella tabella Imbarcazione
INSERT INTO Imbarcazione (CodiceImbarcazione, NomeImbarcazione, TipoImbarcazione, CompPoss, NumMaxPersone, NumMaxVeicoli)
VALUES ('IT001', 'Poseidone', 'traghetto', 'MSC', 200, 50),
	('CFHX', 'Fenice', 'motonave', 'Costa', 24, 0),
	('CMT', 'Minotauro', 'aliscafo', 'Royal Caribbean', 300,0),
	('POIU', 'Pegaso', 'aliscafo', 'Celebrity Cruises', 100, 0),
	('BVCX', 'Tritone', 'traghetto', 'Royal Caribbean', 180, 40),
	('IT02', 'Zeus', 'motonave', 'Holland America Line', 128, 0);

-- Inserimento dati nella tabella Porto
INSERT INTO Porto
VALUES (1,'Porto di Pozzuoli', 'Pozzuoli', 'Italia'),
	(2, 'Porto di Genova', 'Genova', 'Italia'),
	(3, 'Porto di Napoli', 'Napoli', 'Italia'),
	(4, 'Porto di Trieste', 'Trieste', 'Italia'),
	(5, 'Porto di Palermo', 'Palermo', 'Italia'),
	(6,'Porto di Malaga', 'Malaga', 'Spagna'),
	(7,'Porto La Rochelle', 'La Rochelle', 'Francia'),
	(8,'Porto di Lagos', 'Lagos', 'Portogallo'),
	(9, 'Porto di Lisbona', 'Lisbona', 'Portogallo'),
	(10, 'Porto di Alcântara', 'Lisbona', 'Portogallo'),
	(11, 'Porto di Helsinki', 'Helsinki', 'Finlandia'),
	(12, 'Porto di Turku', 'Turku', 'Finlandia'),
	(13, 'Porto di Hanko', 'Hanko', 'Finlandia'),
	(14, 'Porto di Gdansk', 'Gdansk', 'Polonia'),
	(15, 'Porto di Vancouver', 'Vancouver', 'Canada'),
	(16, 'Porto di Sydney', 'Sydney', 'Australia'),
	(17, 'Porto di Haifa', 'Haifa', 'Israele'),
	(18, 'Porto di Jeddah', 'Jeddah', 'Arabia Saudita'),
	(19, 'Porto di Beirut', 'Beirut', 'Libano');

-- Inserimento dati nella tabella Passeggero
INSERT INTO Passeggero (CF, Nome, Cognome, DataNascita, Email, Passw)
VALUES ('6BZ6AHENEWXB47DV', 'Mario', 'Rossi', '2010-07-02', 'mario@email.it', 'mario'),
	   ('TFE5764PZ2PDLWV5', 'Paolo', 'Moccia', '1990-01-01', 'paolo@email.it', 'paolo'),
	   ('VNSU7JQSGL6Y6PKK', 'Martina', 'Gialla', '1995-04-04', 'martina@email.it', 'martina'),
	   ('UPS5K7YBWY93WUX4', 'Federico', 'Chiesa', '2012-11-04', 'federico@email.it', 'federico'),
	   ('LB8BGHWEKG5G24UE', 'Zhou', 'Fei Wa', '2001-01-02', 'zhou@email.it', 'zhou');



-- Inserimento dati nella tabella Corsa
INSERT INTO Corsa (CodiceCorsa, CostoCorsa, Avviso, Stato, FKImb, FKComp)
VALUES  ('C0000006S0', 220.00, '', 'regolare', 'IT001', 'MSC'),
	('C0000006S1', 110.00, '', 'regolare', 'IT001', 'MSC'),
	('C0000006S2', 110.00, '', 'regolare', 'IT001', 'MSC'),
 	('C0000007S0', 220.00, '', 'regolare', 'IT001', 'MSC'),
	('C0000007S1', 110.00, '', 'regolare', 'IT001', 'MSC'),
	('C0000007S2', 110.00, '', 'regolare', 'IT001', 'MSC'),
	('C0000010S0', 60.00, 'maltempo, posticipato di un giorno', 'ritardo', 'IT02', 'Holland America Line'),
	('C0000020S0', 180.00, '', 'regolare', 'CFHX', 'Costa'),
	('C0000021S0', 180.00, '', 'regolare', 'CFHX', 'Costa'),
	('C0000022S0', 180.00, '', 'regolare', 'CFHX', 'Costa'),
	('C0000023S0', 180.00, '', 'regolare', 'CFHX', 'Costa'),
	('C0000024S0', 180.00, '', 'regolare', 'CFHX', 'Costa'),
	('C0000025S0', 180.00, '', 'regolare', 'CFHX', 'Costa'),
 	('C0000026S0', 180.00, '', 'regolare', 'CFHX', 'Costa'),
	('C0000027S0', 180.00, '', 'regolare', 'CFHX', 'Costa'),
	('C0000018S0', 90.75, 'sciopero', 'annullato', 'CMT', 'Royal Caribbean'),
	('C0000018S1', 45.38, 'sciopero', 'annullato', 'CMT', 'Royal Caribbean'),
	('C0000018S2', 45.38, 'sciopero', 'annullato', 'CMT', 'Royal Caribbean'),
	('C0000001S0', 200.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000001S1', 100.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000001S2', 100.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000002S0', 200.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000002S1', 100.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000002S2', 100.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000003S0', 200.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000003S1', 100.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000003S2', 100.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000004S0', 200.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000004S1', 100.00, '', 'regolare', 'IT02', 'Holland America Line'),
	('C0000004S2', 100.00, '', 'regolare', 'IT02', 'Holland America Line');

	   
	   -- Inserimento dati nella tabella Percorso
INSERT INTO Percorso (CorPer, IdPer,TipoPercorso, OrarioPartenza, OrarioArrivo, DataAttivazione, DataScadenza)
VALUES ('C0000001S0', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-05', '2024-02-05'),
('C0000001S0', 10, 'scalo', '18:00:00', '05:07:00', '2024-02-06', '2024-02-08'),
('C0000001S0', 15, 'destinazione', '05:07:00', '05:07:00', '2024-02-08', '2024-02-08'),
('C0000001S1', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-05', '2024-02-05'),
('C0000001S1', 10, 'destinazione', '18:00:00', '18:00:00', '2024-02-06', '2024-02-06'),
('C0000001S2', 10, 'partenza', '18:00:00', '05:07:00', '2024-02-06', '2024-02-08'),
('C0000001S2', 15, 'destinazione', '05:07:00', '05:07:00', '2024-02-08', '2024-02-08'),
('C0000002S0', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-12', '2024-02-12'),
('C0000002S0', 10, 'scalo', '18:00:00', '05:07:00', '2024-02-13', '2024-02-15'),
('C0000002S0', 15, 'destinazione', '05:07:00', '05:07:00', '2024-02-15', '2024-02-15'),
('C0000002S1', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-12', '2024-02-12'),
('C0000002S1', 10, 'destinazione', '18:00:00', '18:00:00', '2024-02-13', '2024-02-13'),
('C0000002S2', 10, 'partenza', '18:00:00', '05:07:00', '2024-02-13', '2024-02-15'),
('C0000002S2', 15, 'destinazione', '05:07:00', '05:07:00', '2024-02-15', '2024-02-15'),
('C0000003S0', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-02', '2024-02-02'),
('C0000003S0', 10, 'scalo', '18:00:00', '05:07:00', '2024-02-03', '2024-02-05'),
('C0000003S0', 15, 'destinazione', '05:07:00', '05:07:00', '2024-02-05', '2024-02-05'),
('C0000003S1', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-02', '2024-02-02'),
('C0000003S1', 10, 'destinazione', '18:00:00', '18:00:00', '2024-02-03', '2024-02-03'),
('C0000003S2', 10, 'partenza', '18:00:00', '05:07:00', '2024-02-03', '2024-02-05'),
('C0000003S2', 15, 'destinazione', '05:07:00', '05:07:00', '2024-02-05', '2024-02-05'),
('C0000004S0', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-09', '2024-02-09'),
('C0000004S0', 10, 'scalo', '18:00:00', '05:07:00', '2024-02-10', '2024-02-12'),
('C0000004S0', 15, 'destinazione', '05:07:00', '05:07:00', '2024-02-12', '2024-02-12'),
('C0000004S1', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-09', '2024-02-09'),
('C0000004S1', 10, 'destinazione', '18:00:00', '18:00:00', '2024-02-10', '2024-02-10'),
('C0000004S2', 10, 'partenza', '18:00:00', '05:07:00', '2024-02-10', '2024-02-12'),
('C0000004S2', 15, 'destinazione', '05:07:00', '05:07:00', '2024-02-12', '2024-02-12'),
('C0000006S0', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-16', '2024-02-16'),
('C0000006S0', 10, 'scalo', '18:00:00', '06:13:00', '2024-02-17', '2024-02-19'),
('C0000006S0', 15, 'destinazione', '06:13:00', '06:13:00', '2024-02-19', '2024-02-19'),
('C0000006S1', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-16', '2024-02-16'),
('C0000006S1', 10, 'destinazione', '18:00:00', '18:00:00', '2024-02-17', '2024-02-17'),
('C0000006S2', 10, 'partenza', '18:00:00', '06:13:00', '2024-02-17', '2024-02-19'),
('C0000006S2', 15, 'destinazione', '06:13:00', '06:13:00', '2024-02-19', '2024-02-19'),
('C0000007S0', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-23', '2024-02-23'),
('C0000007S0', 10, 'scalo', '18:00:00', '06:13:00', '2024-02-24', '2024-02-26'),
('C0000007S0', 15, 'destinazione', '06:13:00', '06:13:00', '2024-02-26', '2024-02-26'),
('C0000007S1', 1, 'partenza', '08:10:00', '21:25:00', '2024-02-23', '2024-02-23'),
('C0000007S1', 10, 'destinazione', '18:00:00', '18:00:00', '2024-02-24', '2024-02-24'),
('C0000007S2', 10, 'partenza', '18:00:00', '06:13:00', '2024-02-24', '2024-02-26'),
('C0000007S2', 15, 'destinazione', '06:13:00', '06:13:00', '2024-02-26', '2024-02-26'),
('C0000010S0', 3, 'partenza', '09:00:00', '15:00:00', '2024-02-29', '2024-02-29'),
('C0000010S0', 5, 'destinazione', '15:00:00', '15:00:00', '2024-02-29', '2024-02-29'),
('C0000020S0', 18, 'partenza', '07:43:00', '23:46:00', '2024-02-03', '2024-02-03'),
('C0000020S0', 7, 'destinazione', '23:46:00', '23:46:00', '2024-02-03', '2024-02-03'),
('C0000021S0', 18, 'partenza', '07:43:00', '23:46:00', '2024-02-10', '2024-02-10'),
('C0000021S0', 7, 'destinazione', '23:46:00', '23:46:00', '2024-02-10', '2024-02-10'),
('C0000022S0', 18, 'partenza', '07:43:00', '23:46:00', '2024-02-17', '2024-02-17'),
('C0000022S0', 7, 'destinazione', '23:46:00', '23:46:00', '2024-02-17', '2024-02-17'),
('C0000023S0', 18, 'partenza', '07:43:00', '23:46:00', '2024-02-24', '2024-02-24'),
('C0000023S0', 7, 'destinazione', '23:46:00', '23:46:00', '2024-02-24', '2024-02-24'),
('C0000024S0', 18, 'partenza', '07:43:00', '23:46:00', '2024-02-04', '2024-02-04'),
('C0000024S0', 7, 'destinazione', '23:46:00', '23:46:00', '2024-02-04', '2024-02-04'),
('C0000025S0', 18, 'partenza', '07:43:00', '23:46:00', '2024-02-11', '2024-02-11'),
('C0000025S0', 7, 'destinazione', '23:46:00', '23:46:00', '2024-02-11', '2024-02-11'),
('C0000026S0', 18, 'partenza', '07:43:00', '23:46:00', '2024-02-18', '2024-02-18'),
('C0000026S0', 7, 'destinazione', '23:46:00', '23:46:00', '2024-02-18', '2024-02-18'),
('C0000027S0', 18, 'partenza', '07:43:00', '23:46:00', '2024-02-25', '2024-02-25'),
('C0000027S0', 7, 'destinazione', '23:46:00', '23:46:00', '2024-02-25', '2024-02-25'),
('C0000018S0', 6, 'partenza', '15:00:00', '23:19:00', '2024-02-28', '2024-02-28'),
('C0000018S0', 11, 'scalo', '13:00:00', '20:25:00', '2024-02-29', '2024-02-29'),
('C0000018S0', 14, 'destinazione', '20:25:00', '20:25:00', '2024-02-29', '2024-02-29'),
('C0000018S1', 6, 'partenza', '15:00:00', '23:19:00', '2024-02-28', '2024-02-28'),
('C0000018S1', 11, 'destinazione', '13:00:00', '13:00:00', '2024-02-29', '2024-02-29'),
('C0000018S2', 11, 'partenza', '13:00:00', '20:25:00', '2024-02-29', '2024-02-29'),
('C0000018S2', 14, 'destinazione', '20:25:00', '20:25:00', '2024-02-29', '2024-02-29');
	   


-- Inserimento dati nella tabella Biglietto
INSERT INTO biglietto VALUES 
('A3O42', 'intero',null , '2024-02-04', false, 2, true, 'VNSU7JQSGL6Y6PKK', 'C0000001S0'),
('QC4M3', 'intero',null , '2024-02-04', false, 0, true, 'VNSU7JQSGL6Y6PKK', 'C0000001S0'),
('I8CEK', 'intero',null, '2024-02-04', false, 0, true, 'VNSU7JQSGL6Y6PKK', 'C0000001S0'),
('SOGSB', 'ridotto', null, '2024-02-04', false, 0, true, 'VNSU7JQSGL6Y6PKK', 'C0000001S0'),
('LGSK3', 'ridotto', null, '2024-02-04', false, 0, true, 'VNSU7JQSGL6Y6PKK', 'C0000001S0'),
('BU81Y', 'intero',null , '2024-02-04', true, 2, false, 'LB8BGHWEKG5G24UE', 'C0000006S2'),
('Y9Z2Y', 'ridotto', null, '2024-02-04', true, 0, false, 'LB8BGHWEKG5G24UE', 'C0000006S2');


