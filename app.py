#comando pip install mysql-connector-python= traduttore. Permette a python di parlare la lingua del database
#comando pip install python-dotenv= serve a leggere i file nascosti (in questo caso .env) per recuperare password senza doverle scrivere nel codice

import os #serve a parlare con il sistema operativo. Ci serve per leggere le variabili d'ambiente
import mysql.connector #carica il traduttore che abbiamo installato prima
from dotenv import load_dotenv #prende la funzione specifica per caricare i file nascosti (.env)

load_dotenv() #cerca il file chiamato .env nella cartella corrente. Legge le password scritte all'interno .env e le rende disponibili al programma, ma solo nella memoria temporanea. In questo modo non dobbiamo scrivere la password nel codice

print ("tentativo di connessione al Database Aziendale")

try: #try e except è una rete di sicurezza. Connettersi a un database è un'operazione che potrebbe fallire. 
	#configurazione della connessione
	db_connection= mysql.connector.connect ( #in questo modo stiamo avviando una comunicazione tra python e il db
		host= "127.0.0.1", #mio pc
		port= 3307, #porta esterna mappata nel docker-compose
		user= os.getenv("MYSQL_USER"), #legge l'utente dal .env. In questo caso verrà automaticamente scritto MYSQL_USER
		password= os.getenv("MYSQL_PASSWORD"),
		database= os.getenv("MYSQL_DATABASE")
	)
	if db_connection.is_connected():
		print ("connessione riuscita")
	#creiamo il cursore per eseguire query
		cursor= db_connection.cursor() #scorre le righe del database. Esegue i comandi
	#eseguiamo la query
		query= "SELECT nome, cognome, ruolo, stipendio FROM dipendenti;"
		cursor.execute(query) #il cursore invia il comando SQL al database e aspetta la risposta
	#stampiamo i risultati in una tabella
		print (f"{'DIPENDENTE': <25} | {'RUOLO': <20} | {'STIPENDIO': <10}") #f permette di formatare il testo in modo dinamico. < significa allinea a sinistra. 25 significa che prenota uno spazio fisso di 25 caratteri. Anche se la parola è più corta, python riempie il resto con spazi vuoti, in questo modo si creeranno colonne diritte
		print ("-" * 65)

		for (nome, cognome, ruolo, stipendio) in cursor: #cicla ogni riga del database, prende i dati e li stampa 
			full_name= f"{nome} {cognome}" 
			print (f"{full_name: <25} | {ruolo: <20} | € {stipendio}")
except Exception as e: #except se qualcosa va storto del campo TRY non far crashare tutto il programma e stampami gli errori. EXCEPTION è la categoria generale che include quasi tutti gli errori (rete, autenticazione, ecc)
	print (f"\n ERRORE: {e}")
	print ("Suggerimento: Controlla di aver scritto giusti i nomi delle variabili nel codice!")

finally: #chiude la connessione al database. Lasciare connessioni aperte potrebbe bloccare il server alla lunga
	if 'db_connection' in locals() and db_connection.is_connected():
		db_connection.close()
		print ("\n Connessione chiusa!")
