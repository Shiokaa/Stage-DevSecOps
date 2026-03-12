# Packer - Création de Template Proxmox

Ce dossier contient la configuration **Packer** permettant d'automatiser la création d'un template de machine virtuelle **Ubuntu 24.04** sur Proxmox.

## Description

Le template généré contient de base :
- **Ubuntu 24.04** installé automatiquement de façon silencieuse via `cloud-init` (configuration autoinstall fournie via HTTP serveur embarqué par Packer).
- Le paquet `qemu-guest-agent` installé pour interagir correctement avec Proxmox.
- Des scripts de provisionnement (`shell`) exécutés en fin d'installation :
  - `01-update.sh` : Mise à jour du système.
  - `02-cloud-init-prep.sh` : Préparation et réinitialisation de `cloud-init` pour permettre à Terraform d'injecter sa propre configuration par la suite.
  - `03-cleanup.sh` : Nettoyage du système (fichiers temporaires, cache apt, etc.) et hardening basique.

L'objectif est d'obtenir une base propre, légère et prête à être clonée et provisionnée par **Terraform**.

## Structure du dossier

- `ubuntu-2404.pkr.hcl` : Le bloc principal contenant les instructions de build pour l'ISO et les provisioners.
- `variables.pkr.hcl` : La déclaration des variables utilisées.
- `variables.pkrvars.hcl.example` : Un exemple de fichier de valeurs pour définir vos paramètres d'environnement Proxmox.
- `versions.pkr.hcl` : La définition de la version du plugin Proxmox requis.
- `http/` : Dossier contenant la configuration `cloud-init` (souvent un fichier `user-data` pour l'autoinstall).
- `scripts/` : Dossier contenant les scripts bash exécutés à la fin du processus de montage de l'image.

## Prérequis

1. Avoir **Packer** (≥ 1.2.2) installé.
2. Avoir accès à un hyperviseur **Proxmox VE** via l'API.

⚠️ **Important concernant `ds=nocloud` (Autoinstall Ubuntu)** :
La directive de boot `ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/` récupère automatiquement l'adresse IP et le port de la machine **exécutant Packer**. 
Le serveur HTTP local lancé par Packer (qui sert l'autoinstall) doit donc être accessible par la VM générée. **Il est ainsi impératif de lancer le script Packer depuis une machine capable de communiquer avec la VM sur Proxmox** (le plus simple étant de l'exécuter directement sur le nœud Proxmox ou depuis une machine sur le même réseau local), sinon l'installation d'Ubuntu va échouer.

## Utilisation

1. **Configuration des variables** :
   Copiez le fichier d'exemple et remplissez-le avec vos identifiants Proxmox.
   ```bash
   cp variables.pkrvars.hcl.example variables.pkrvars.hcl
   ```
   Renseignez le Token API, l'URL de Proxmox, le noeud cible, et les détails de l'ISO.

2. **Initialisation** :
   Télécharge les plugins nécessaires (Proxmox).
   ```bash
   packer init .
   ```

3. **Génération du template** :
   Lance la construction de la machine virtuelle sur Proxmox puis la convertit en template une fois terminée.
   ```bash
   packer build -var-file="variables.pkrvars.hcl" .
   ```
