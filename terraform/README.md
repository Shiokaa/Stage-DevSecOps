# Terraform - Provisioning d'Infrastructure Proxmox

Ce dossier contient la configuration **Terraform** permettant de déployer et de gérer automatiquement les machines virtuelles sur **Proxmox** à partir du template créé par Packer.

## Description

Le code Terraform s'appuie sur le provider communautaire `telmate/proxmox`. 
Il utilise une approche modulaire pour instancier des VMs de manière claire et réutilisable.
Dans le déploiement actuel, les VMs clonées à partir du template (exemple: `ubuntu-2404-template`) héritent de la configuration, et subissent une initialisation réseau et système via `cloud-init` intégré à Terraform.

## Structure du dossier

- `main.tf` : Configuration du bloc provider `proxmox` et définition des versions requises.
- `variables.tf` : Déclaration de toutes les variables (clés API, configuration SSH, etc.).
- `outputs.tf` : (Optionnel) Définition des informations de sortie à afficher une fois le déploiement terminé (par exemple, les adresses IP).
- `terraform.tfvars.example` : Exemple de fichier pour personnaliser vos variables sans les push sur Git.
- `vms.tf` : Fichier principal de déclaration des ressources d'infrastructures. Ici, on appelle le module pour instancier des VMs (ex: `test_vm`).
- `modules/vm/` : Dossier (module interne) contenant la logique de création d'une VM type.

## Prérequis

1. Avoir **Terraform** (≥ 1.5.0) installé.
2. Avoir généré le template Ubuntu 24.04 avec Packer au préalable.
3. Disposer d'une clé SSH publique pour s'y connecter : `var.ssh_public_key`.

## Utilisation

1. **Configuration des variables** :
   Copiez l'exemple pour définir vos propres informations d'authentification Proxmox et d'infrastructure.
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   Puis éditez `terraform.tfvars`.

2. **Initialisation de Terraform** :
   Télécharge le provider (telmate/proxmox) et prépare l'environnement de travail.
   ```bash
   terraform init
   ```

3. **Vérification du plan de déploiement** :
   Affiche toutes les actions (création, modification, destruction) qui seront exécutées sans rien appliquer.
   ```bash
   terraform plan
   ```

4. **Déploiement** :
   Applique le plan et provisionne les VMs sur l'hyperviseur Proxmox.
   ```bash
   terraform apply
   ```
   Entrez `yes` pour valider.

5. **Destruction** *(si besoin)* :
   Pour supprimer l'ensemble des ressources gérées par Terraform.
   ```bash
   terraform destroy
   ```
