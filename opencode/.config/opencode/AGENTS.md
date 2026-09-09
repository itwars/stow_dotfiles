---
name: agents bootstrap
description: "Instructions obligatoires OpenCode : répertoire /root/output/AAAAMMJJ, owner/group 1000:1000, horodatage, conservation des versions, sauvegarde de conversation."
---

# Agents Instructions

## Priorité des règles

Ces règles s’appliquent dès le démarrage d’OpenCode et pendant toute la session.

En cas de doute, appliquer la règle la plus prudente :

- ne pas supprimer ;
- ne pas écraser ;
- ne pas écrire hors de `/root/output/` ;
- tracer ce qui est fait ;
- signaler explicitement toute impossibilité.

Si une règle ne peut pas être respectée, le dire clairement avant de continuer.

## Variables de session

Avant toute écriture de fichier, définir les variables suivantes :

- `DATE_JOUR` : date du jour au format `AAAAMMJJ`, obtenue avec `date +%Y%m%d`.
  Exemple : `20260817`.
- `DATE_COURTE` : date du jour au format `AAMMJJ`, obtenue avec `date +%y%m%d`.
  Exemple : `260817`.
- `HEURE` : heure au format `HHMMSS`, obtenue avec `date +%H%M%S`.
- `OUTPUT_DIR` : répertoire de sortie du jour : `/root/output/${DATE_JOUR}`.
- `MODEL_SLUG` : nom du modèle en minuscules, sans espaces, avec uniquement des lettres, chiffres et tirets. Si inconnu, utiliser `unknown`.
- `REASONING_LEVEL` : niveau de raisonnement, si connu. Sinon utiliser `unknown`.

Exemple :

```sh
DATE_JOUR="$(date +%Y%m%d)"
DATE_COURTE="$(date +%y%m%d)"
HEURE="$(date +%H%M%S)"
OUTPUT_DIR="/root/output/${DATE_JOUR}"
MODEL_SLUG="${MODEL_SLUG:-unknown}"
REASONING_LEVEL="${REASONING_LEVEL:-unknown}"
```

## Répertoire de sortie obligatoire

- Tous les fichiers générés doivent être sauvegardés dans `/root/output/${DATE_JOUR}/`.
- Ne pas écrire directement dans `/root/output/` sauf demande explicite.
- Toujours utiliser des chemins absolus.
- Ne jamais utiliser `~`, `.` ou des chemins relatifs.
- Créer le répertoire avant d’écrire le moindre fichier.
- Si le répertoire existe déjà, ne pas le supprimer ni le vider.
- Si la création échoue, ne pas écrire ailleurs et signaler l’erreur.

## Initialisation obligatoire avant toute écriture

Avant de produire ou sauvegarder un fichier, exécuter ou proposer les commandes suivantes :

```sh
DATE_JOUR="$(date +%Y%m%d)"
OUTPUT_DIR="/root/output/${DATE_JOUR}"

mkdir -p /root/output
mkdir -p "$OUTPUT_DIR"

chown 1000:1000 /root/output "$OUTPUT_DIR"
chmod 755 /root/output "$OUTPUT_DIR"

test -d /root/output
test -d "$OUTPUT_DIR"
```

Les commandes `test` doivent réussir. Si elles échouent, arrêter l’écriture et expliquer le problème.

## Convention de date pour les répertoires

- Format obligatoire : `AAAAMMJJ`.
- Année sur 4 chiffres.
- Mois sur 2 chiffres.
- Jour sur 2 chiffres.
- Commande de référence : `date +%Y%m%d`.

Exemples :

- 3 avril 2026 : `20260403`
- 17 août 2026 : `20260817`

Ne pas utiliser de formats ambigus comme `AAAAMMMJJ`, `AAAA-MM-JJ` ou `AA-MM-JJ` pour le répertoire de sortie.

## Convention de nommage des fichiers

Chaque fichier généré doit avoir un nom stable, lisible et horodaté.

Format recommandé :

```text
<slug>-<DATE_JOUR>-<HEURE>.<extension>
```

Exemple :

```text
rapport-20260817-153012.md
```

Règles de nommage :

- Utiliser uniquement des caractères sûrs : `a-z`, `0-9`, `-`, `_`, `.`.
- Pas d’espaces.
- Pas d’accents.
- Pas de caractères spéciaux.
- Toujours inclure un horodatage.
- Toujours utiliser une extension claire : `.md`, `.txt`, `.sh`, `.json`, etc.

## Gestion des versions

Quand une nouvelle version d’un fichier est créée :

- conserver la version précédente ;
- créer un nouveau fichier ;
- ne jamais écraser l’ancien fichier ;
- ne jamais supprimer l’ancien fichier ;
- horodater la nouvelle version.

Formats possibles pour une nouvelle version :

```text
<slug>-<DATE_JOUR>-<HEURE>-v2.<extension>
<slug>-<DATE_JOUR>-<HEURE>-v3.<extension>
```

Ou simplement un nouvel horodatage :

```text
rapport-20260817-153012.md
rapport-20260817-160245.md
```

Si un fichier avec le même nom existe déjà, ajouter un suffixe :

```text
fichier-20260817-153012-1.md
fichier-20260817-153012-2.md
```

## Propriétaire et groupe

Tous les répertoires et fichiers générés dans `/root/output/${DATE_JOUR}/` doivent appartenir à :

```text
owner: 1000
group: 1000
```

Après création d’un fichier :

```sh
chown 1000:1000 "/root/output/${DATE_JOUR}/mon-fichier.md"
chmod 644 "/root/output/${DATE_JOUR}/mon-fichier.md"
```

Après création de plusieurs fichiers dans le répertoire du jour :

```sh
chown -R 1000:1000 "$OUTPUT_DIR"
```

Ne pas changer récursivement les anciens jours sauf demande explicite.

## Sauvegarde de la conversation

À la fin de la tâche, sauvegarder l’ensemble de la conversation au format Markdown dans le répertoire du jour.

Nom de base demandé :

```sh
CONVERSATION_FILE="${OUTPUT_DIR}/conversation-${DATE_COURTE}-${MODEL_SLUG}-${REASONING_LEVEL}.md"
```

Exemple :

```text
/root/output/20260817/conversation-260817-qwen3-8-high.md
```

Pour éviter l’écrasement et respecter l’horodatage des fichiers, utiliser de préférence une version horodatée :

```sh
CONVERSATION_FILE="${OUTPUT_DIR}/conversation-${DATE_COURTE}-${HEURE}-${MODEL_SLUG}-${REASONING_LEVEL}.md"
```

Exemple :

```text
/root/output/20260817/conversation-260817-153012-qwen3-8-high.md
```

Si le nom strict sans heure doit être conservé et qu’un fichier existe déjà, ajouter un suffixe :

```text
conversation-260817-qwen3-8-high-1.md
conversation-260817-qwen3-8-high-2.md
```

Le fichier de conversation doit contenir :

- un en-tête YAML avec la date, l’heure, le modèle, le niveau de raisonnement et le répertoire ;
- la conversation ou un compte-rendu complet ;
- les commandes proposées ou exécutées ;
- la liste des fichiers créés ;
- les erreurs éventuelles.

Exemple d’en-tête YAML :

```yaml
---
date: "2026-08-17"
time: "15:30:12"
model: "unknown"
reasoning_level: "unknown"
output_dir: "/root/output/20260817"
---
```

Si la conversation est trop volumineuse, la découper en plusieurs fichiers :

```text
conversation-260817-153012-partie-01.md
conversation-260817-153012-partie-02.md
```

## Environnement Alpine Linux

L’environnement est une distribution Alpine Linux.

Contraintes :

- environnement potentiellement vierge ;
- pas de paquets préinstallés garantis ;
- ne pas supposer la présence de `bash`, `curl`, `git`, `python`, `node`, `jq`, etc. ;
- privilégier les commandes POSIX/BusyBox disponibles ;
- utiliser des commandes simples et portables.

Commandes de base à privilégier :

```sh
mkdir
date
chown
chmod
cp
mv
ls
cat
printf
test
```

Si un outil manque et qu’il est réellement nécessaire, installer uniquement le paquet requis :

```sh
apk add --no-cache <paquet>
```

Ne pas installer de paquets si une commande POSIX/BusyBox suffit.

## Scripts générés

Tout script généré doit être compatible Alpine/BusyBox.

Format recommandé :

```sh
#!/bin/sh
set -eu

DATE_JOUR="$(date +%Y%m%d)"
OUTPUT_DIR="/root/output/${DATE_JOUR}"

mkdir -p "$OUTPUT_DIR"
chown 1000:1000 "$OUTPUT_DIR"
```

Règles pour les scripts :

- utiliser `/bin/sh` plutôt que `/bin/bash` ;
- éviter les dépendances inutiles ;
- utiliser des chemins absolus ;
- utiliser `set -eu` quand c’est pertinent ;
- ne jamais supprimer des données avec `rm -rf` sans demande explicite ;
- toujours vérifier les répertoires avant écriture.

## Interdictions

- Ne pas écrire hors de `/root/output/` sans demande explicite.
- Ne pas utiliser de chemins relatifs.
- Ne pas utiliser `~`.
- Ne pas écraser une version précédente.
- Ne pas supprimer une version précédente.
- Ne pas vider `/root/output/`.
- Ne pas utiliser `rm -rf` sans nécessité absolue et demande explicite.
- Ne pas deviner la date : utiliser `date +%Y%m%d` ou `date +%y%m%d` selon le format demandé.
- Ne pas deviner l’heure : utiliser `date +%H%M%S`.
- Ne pas mentir sur la création d’un fichier.
- Si un fichier n’a pas pu être créé, le dire explicitement.

## Preuve de conformité

À la fin de la réponse, fournir un récapitulatif court avec :

1. le répertoire de sortie utilisé ;
2. la liste des fichiers créés avec leur chemin absolu ;
3. les commandes de vérification ;
4. les erreurs éventuelles.

Exemple de vérification :

```sh
ls -ld "$OUTPUT_DIR"
ls -l "$OUTPUT_DIR"
```

Le récapitulatif doit ressembler à :

```text
Répertoire : /root/output/20260817
Fichiers créés :
- /root/output/20260817/rapport-20260817-153012.md
- /root/output/20260817/conversation-260817-153012-qwen3-8-high.md
Propriétaire : 1000:1000
Erreurs : aucune
```

## Checklist obligatoire avant de répondre

Avant de terminer, vérifier tous les points suivants :

- [ ] `DATE_JOUR` provient bien de `date +%Y%m%d`.
- [ ] `DATE_COURTE` provient bien de `date +%y%m%d` pour le nom de conversation si le format `AAMMJJ` est utilisé.
- [ ] Le répertoire `/root/output/${DATE_JOUR}` existe.
- [ ] Aucun chemin relatif n’a été utilisé.
- [ ] Aucun fichier précédent n’a été écrasé.
- [ ] Aucun fichier précédent n’a été supprimé.
- [ ] Chaque fichier généré est horodaté.
- [ ] Le propriétaire et le groupe `1000:1000` ont été appliqués.
- [ ] La conversation Markdown a été sauvegardée.
- [ ] Le récapitulatif final liste les fichiers créés.
- [ ] Les erreurs éventuelles sont signalées.
