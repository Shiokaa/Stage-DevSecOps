# Stage – DevSecOps – Infrastructure & Monitoring
Ce projet met en place une chaîne **d'Infrastructure as Code (IaC)** pour automatiser la création et le déploiement de machines virtuelles sur un hyperviseur **Proxmox**, en utilisant **Packer** (création de templates), **Terraform** (provisionnement de VMs) et **Ansible** (configuration des VMs).

## Infrastructure as Code
- Terraform (déploiement VM)
- Packer (image custom si possible)
- Ansible (configuration & hardening)

## Hardening
- Configuration SSH sécurisée
- Firewall
- Fail2ban
- Désactivation services inutiles
- Application des bonnes pratiques CIS

## Monitoring & Logs
- Prometheus
- Grafana
- Loki ou VictoriaMetrics
- Création d'un exporter custom
- Dashboard personnalisé

## Livrables attendus
- Repository Git propre
- Déploiement automatisé
- Diagramme d'architecture
- Documentation complète
- Dashboard exporté
- Démonstration live

## Déployer en une commande :
- 1 VM
- 1 service web
- Hardening
- Monitoring complet
- Logs centralisés
- Dashboard Grafana

# Architecture du projet 

```bash
Stage-DevSecOps\
|–– .gitgnore			# Contient les dossiers et fichiers à ignorer à la racine
|–– terraform			# Contient les dossiers et fichiers liés à la configuration terraform
|–– packer              # Contient les dossiers et fichiers liés à la configuration packer
|-- ansible 			# Contient les dossiers et fichiers liés à la configuration ansible
|-- doc					# Contient la documentation du projet
```

Pour plus d'information sur les configurations : 
- [Packer](./packer/)
- [Terraform](./terraform/)
- [Ansible](./ansible/)

# Diagramme d'architecture :

# Lancement du projet

## Prérequis : 

- **Système d’exploitation** : Linux (recommandé Ubuntu 24.04)
- **Hyperviseur** : Proxmox VE (accès API requis)
- **Outils installés** :
	- [Packer](https://developer.hashicorp.com/packer) (≥ 1.2.2, plugin Proxmox)
	- [Terraform](https://developer.hashicorp.com/terraform) (≥ 1.5.0, provider telmate/proxmox 3.0.2-rc07)
	- [Ansible](https://docs.ansible.com/) (pour la configuration et le hardening)
- **Accès réseau** : vers Proxmox, et pour télécharger les ISO Ubuntu
- **Dépendances système** :
	- sudo, curl, git, cloud-init, qemu-guest-agent
- **Variables à définir** :
	- Voir [variables.pkrvars.hcl.example](packer/variables.pkrvars.hcl.example)
	- Voir [terraform.tfvars.example](terraform/terraform.tfvars.example)
- **Permissions** : accès administrateur pour exécuter les scripts et provisionner les VMs

## Clonage du projet :
```bash
git clone https://github.com/Shiokaa/Stage-DevSecOps.git
cd ./Stage-DevSecOps
```

## Le build.sh :
Génère le template Packer, provisionne avec Terraform puis configure avec Ansible

Allez à la racine du projet et : 
```bash
chmod +x build.sh
./build.sh
```

# Sites officiels : 
- [Packer](https://developer.hashicorp.com/packer)
- [Terraform](https://developer.hashicorp.com/terraform)
- [Ansible](https://docs.ansible.com/)

# Contact
Réalisé par :
- [Amaru Tom](https://github.com/Shiokaa) 
- [Le Berre Etienne](https://github.com/etiennelb95)
