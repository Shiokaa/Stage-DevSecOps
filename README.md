# Stage DevSecOps — Rapport d'avancement

> **Date du rapport :** 6 mars 2026  
> **Infra cible :** Proxmox VE (`192.168.10.250` — `node1`)

---

## Vue d'ensemble

Ce projet met en place une chaîne d'**Infrastructure as Code (IaC)** pour automatiser la création et le déploiement de machines virtuelles sur un hyperviseur **Proxmox**, en utilisant **Packer** (création de templates) et **Terraform** (provisionnement de VMs).

---

## Ce qui est fait

### 1. Packer — Création du template Ubuntu 22.04

| Élément                                                                             | Statut  |
| ----------------------------------------------------------------------------------- | ------- |
| Configuration du builder `proxmox-iso`                                              | ✅ Fait |
| Autoinstall (preseed) Ubuntu via ISO `ubuntu-24.04.3-live-server-amd64.iso`         | ✅ Fait |
| Partitionnement LVM (EFI, boot, root 10G, home 5G)                                  | ✅ Fait |
| Configuration locale FR (clavier, timezone `Europe/Paris`)                          | ✅ Fait |
| Installation des paquets de base (qemu-guest-agent, vim, net-tools…)                | ✅ Fait |
| Script de post-installation (nettoyage logs, machine-id, cloud-init)                | ✅ Fait |
| Gestion des secrets (token Proxmox, mot de passe SSH) via `secret.auto.pkrvars.hcl` | ✅ Fait |
| Activation du UEFI (OVMF) + Secure Boot (pre-enrolled keys)                         | ✅ Fait |
| Plugin Proxmox `>= v1.1.8`                                                          | ✅ Fait |

**Résumé :** Le template `tpl-ubuntu-2204` (VM ID `122`) est créé et fonctionnel sur Proxmox. Il crée une image Ubuntu avec Cloud-Init pré-activé, prête à être clonée par Terraform. L'utilisateur `tom` est créé avec des droits sudo sans mot de passe.

> **⚠️ Packer ne fonctionne pas à 100 %** — voir la section [Problèmes connus](#problèmes-connus) ci-dessous.

### 2. Terraform — Déploiement des VMs

| Élément                                                                                           | Statut  |
| ------------------------------------------------------------------------------------------------- | ------- |
| Provider `bpg/proxmox` configuré (API token, SSH agent)                                           | ✅ Fait |
| Récupération dynamique du template via `data.proxmox_virtual_environment_vms` (filtrage par tags) | ✅ Fait |
| Fichiers Cloud-Init (`user-data.yml` et `meta-data.yml`) injectés via snippets                    | ✅ Fait |
| Création de la VM par clone du template Packer                                                    | ✅ Fait |
| Configuration réseau (DHCP sur `vmbr0`, virtio)                                                   | ✅ Fait |
| Configuration matérielle (1 vCPU `x86-64-v2-AES`, 2 Go RAM, 32 Go disque)                         | ✅ Fait |
| Lifecycle `ignore_changes` sur l'adresse MAC                                                      | ✅ Fait |
| Variables paramétrables (hostname, domaine, tags, clé SSH, disques supplémentaires)               | ✅ Fait |
| Fichier `terraform.auto.tfvars` avec le token API                                                 | ✅ Fait |
| Fichier `.gitignore` pour exclure les secrets et fichiers d'état                                  | ✅ Fait |

**Résumé :** La configuration Terraform est complète. La VM `tom-test.tom-local` (ID `128`) est actuellement **déployée et active** sur `192.168.10.42`. Le tfstate est au serial **143**.

### 3. Cloud-Init — Personnalisation des instances

- **user-data.yml** : Définit le hostname, crée un utilisateur `sysadmin` avec clé SSH, désactive l'authentification par mot de passe, active `growpart` pour l'extension automatique des disques.
- **meta-data.yml** : Injecte un `instance-id` unique (SHA1 du hostname) et le `local-hostname`.

---

## Problèmes connus

### 🔴 Cloud-Init Terraform ne s'applique pas correctement

**Symptôme :** Après le `terraform apply`, la VM est créée et démarre, mais le cloud-init de Terraform (fichier `user-data.yml` injecté via snippets) **ne s'exécute pas correctement**. En conséquence :

- L'utilisateur **`sysadmin` n'est pas créé** sur la VM
- La clé SSH associée n'est pas injectée
- Seul l'utilisateur `tom` (créé par l'autoinstall Packer) est disponible

**Cause probable :** Le cloud-init du template Packer a peut-être déjà été exécuté une première fois (lors du build autoinstall) et ne se relance pas proprement lors du clone, même après le nettoyage (`cloud-init clean`). Le fichier `/etc/machine-id` ou l'`instance-id` cloud-init pourrait ne pas être correctement réinitialisé, empêchant cloud-init de détecter une nouvelle instance.

**Pistes à investiguer :**

- Vérifier sur la VM que `cloud-init status` retourne bien `done` et pas `disabled`
- Regarder les logs : `cat /var/log/cloud-init-output.log` et `cat /var/log/cloud-init.log`
- Vérifier que `/etc/machine-id` est vide (`uninitialized`) dans le template
- S'assurer que l'`instance-id` dans `meta-data.yml` est bien différent de celui du template
- Vérifier que le disque cloud-init (`ide2`) est bien monté et lisible au boot avec `lsblk`

---

## Architecture du projet

```
Stage-DevSecOps/
├── .gitignore                         # Exclusion des secrets et fichiers d'état
├── packer/                            # Création du template VM
│   ├── ubuntu-2204.pkr.hcl           # Builder proxmox-iso + provisioner shell
│   ├── variables.pkr.hcl             # Variables (token, endpoint, SSH)
│   ├── versions.pkr.hcl              # Contraintes de version Packer/plugin
│   ├── secret.auto.pkrvars.hcl       # Secrets (tokens, mot de passe)
│   ├── autoinstall/ubuntu2204/       # Preseed autoinstall
│   │   ├── user-data                 # Configuration autoinstall complète
│   │   └── meta-data                 # Métadonnées (vide)
│   └── provisionners/
│       └── postinstall-ubuntu.sh     # Nettoyage post-installation
│
└── terraform/                         # Déploiement des VMs
    ├── main.tf                        # Provider requirements (bpg/proxmox)
    ├── provider.tf                    # Configuration du provider Proxmox
    ├── variable.tf                    # Déclaration des variables
    ├── vm.tf                          # Ressources VM + Cloud-Init snippets
    ├── terraform.auto.tfvars          # Valeurs des secrets
    └── cloud-init/
        ├── user-data.yml              # Template Cloud-Init utilisateur
        └── meta-data.yml              # Template Cloud-Init métadonnées
```

---

## Prochaines étapes envisageables

- [ ] **Résoudre le problème cloud-init** (priorité haute)
- [ ] Mettre en place un pipeline **CI/CD** (GitHub Actions, GitLab CI…)
- [ ] Ajouter **Ansible** pour le provisionnement post-déploiement
- [ ] Gérer les secrets avec **HashiCorp Vault** ou des variables d'environnement
- [ ] Implémenter les disques supplémentaires dynamiques dans Terraform
- [ ] Documenter la procédure de build Packer et de déploiement Terraform


# Lancement : 

## Packer : 

```bash
packer init .
packer build -var-file=variables.pkrvars.hcl .
```