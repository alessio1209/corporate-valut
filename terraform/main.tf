# -----------------------------------------------------------
# 1. BLOCCO DI CONFIGURAZIONE (Il Cervello)
# -----------------------------------------------------------
terraform {
  required_providers {
    #usiamo "null": è un provider "finto" o "vuoto".
    #serve solo quando vuoi usare Terraform per lanciare script e comandi manuali.
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}
 
#inizializziamo il provider vuoto (non servono password o configurazioni)
provider "null" {}
 
# -----------------------------------------------------------
# 2. LA RISORSA "MACGYVER" (L'Esecutore)
# -----------------------------------------------------------
#resource "null_resource" dice Terraform di creare un oggetto nel tuo database, ma non creare nulla di fisico nel cloud, lui terrà solo traccia di questo blocco.
resource "null_resource" "db_aziendale" {
 
  # --- FASE DI CREAZIONE (terraform apply) ---
 
  # "provisioner local-exec" significa esegui questo comando SUL MIO COMPUTER (localhost), come se lo scrivessi io nel terminale.
  provisioner "local-exec" {
 
    #questo è il comando che avremmo usato
    #terraform non controlla la versione API qui, si limita a passare il testo a Linux.
    #-d= Background
    # --restart unless-stopped= questo comando permette di accendere il container ogni volta che riavviamo il pc
    #--name= Nome fondamentale per trovarlo dopo
    #-p 3307:3306= Mappiamo la porta (importante per lo script python)
    # -v /home/ale/corporate-valut/init-scripts:/docker-entrypoint-initdb.d= tutto quello che c'è nella mia cartella init-scripts, mettilo nella cartella speciale di Mariadb che segue gli script all'avvio
    command = "docker run -d --restart unless-stopped --name corporate-vault-terraform -p 3307:3306 -v /home/ale/corporate-valut/init-scripts:/docker-entrypoint-initdb.d -e MYSQL_ROOT_PASSWORD=RootSecret123! -e MYSQL_DATABASE=techcorp_db -e MYSQL_USER=admin_hr -e MYSQL_PASSWORD=secure_hr_pass_2024 mariadb:10.11"
  }
 
  # --- FASE DI DISTRUZIONE (terraform destroy) ---

  #normalmente Terraform sa cancellare quello che crea. Ma siccome qui abbiamo usato un comando manuale, Terraform non sa come spegnerlo.
 
 
  provisioner "local-exec" {
    # "when = destroy" dice di eseguire questo solo quando l'utente scrive terraform destroy
    when    = destroy
 
    #il comando per pulire: docker rm -f che forza la rimozione anche se il container è acceso. Useremo il nome che abbiamo dato sopra.
    command = "docker rm -f corporate-vault-terraform"
  }
}
 
