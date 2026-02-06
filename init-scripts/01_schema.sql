--- Creazione Tabelle

CREATE TABLE IF NOT EXISTS dipartimenti (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	nome VARCHAR(50) NOT NULL,
	budget DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS dipendenti (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	cognome VARCHAR(50) NOT NULL,
	ruolo VARCHAR(50),
	stipendio DECIMAL(10,2),
	assunto_il DATE DEFAULT CURRENT_DATE,
	dipartimento_id INT,
	FOREIGN KEY (dipartimento_id) REFERENCES dipartimenti(id)
);
--- Popolamento dati

INSERT INTO dipartimenti (nome, budget)
VALUES
('DevOps Team', 85000.00),
('Vendite', 120000.00);


INSERT INTO dipendenti (nome, cognome, ruolo, stipendio, dipartimento_id) 
VALUES 
('Mario', 'Rossi', 'Senior Devops', 4500.00, 1),
('Luigi', 'Verdi', 'Junior SysAdmin', 2200.00, 1),
('Sara', 'Bianchi', 'Sales Manager', 3800.00, 2);
