# Projet SNOWFLAKE : création d'une pipeline d'intégration de données
## Description du projet
Dans ce projet, j'ai créé une pipeline d'intégration de données d'un fichier de log d'une application de santé fictive (néanmoins les noms de processus viennent de ce GitHub :).
L'application envoie des messages stockés dans le fichier data_source.csv. La pipeline vérifie la qualité des données, transforme les données puis les dispatche dans les tables finales.
## Stack technique
* **Snowflake :**  Plateforme principale pour l'orchestration des pipelines de données, la modélisation via SQL avancé, l'automatisation des traitements avec les tâches (TASKS), et la gestion scalable des flux ELT en continu.
* **Tâches Snowflake (TASKS) :**  Outil principal pour l'orchestration et l'automatisation des pipelines ELT, la planification cron des traitements SQL, la création de DAGs de dépendances entre tâches, et l'exécution serverless continue des transformations de données.
**Internal Stage Snowflake :**  Zone de stockage temporaire principale au sein de Snowflake pour l'upload de fichiers CSV via PUT, le staging intermédiaire des données brutes avant COPY INTO, la configuration de file formats personnalisés (TIMESTAMP_FORMAT, délimiteurs), et l'intégration fluide des pipelines ELT avec les tâches automatisées.
* **CSV :**  Format principal pour l'échange et le stockage intermédiaire de données brutes, la préparation des fichiers sources pour les pipelines ELT, l'export rapide depuis LibreOffice/Excel, et le chargement initial scalable vers Snowflake via COPY INTO.
* **RBAC Snowflake :**  Système principal de contrôle d'accès basé sur les rôles, la gestion granulaire des privilèges sur bases/schémas/tables, l'attribution hiérarchique de rôles aux utilisateurs, et la sécurisation des pipelines de données selon le principe du moindre privilège.
## Axes étudiés
### Vision de l'administrateur
* Création de la base de données et création des schémas de la base de données. Le schéma RAW récupère les données de l'application. Le schéma COMMON gère la pipeline. Le schéma STAGING contient les tables avec les données issues de la pipeline.
* Création du rôle du responsable de la sécurité.
* Fichiers : init_database.sql, role_by_admin.sql
### Vision du responsable de la sécurité
* Création des rôles de devops, d'ingénieur et de gestion de l'application.
* Fichier : role_by_dev_sec_ops_role.sql
### Vision du devops
* Il met en place la structure de la base de données en créant les tables dont la pipeline a besoin, le répertoire interne pour stocker le fichier fourni par l'application.
* Fichiers : create_table.sql, create_stream.sql
### Vision devops
* C'est lui qui crée les outils pour créer la pipeline.
* La pipeline récupère les données et les stocke dans une table temporaire. Elle vérifie que les données soient valides (nom de processus existants, et date qui ne soit pas dans le futur) et isole les données non valides. Ensuite elle vérifie que les données soient suffisamment récentes (pas plus vieilles que 5 jours) et isole les données trop vieilles. Enfin elle met les données au bon format (nom du processus séparé de son message de log) dans les tables finales (une table par processus).
* Fichiers : create_functions.sql, create_procedure.sql
### Vision data ingénieur
* Il a à disposition une table de données non valides (com_abnormal_event), une table de données trop vieilles (com_late_data), une table de log de la pipeline (com_logging) et une table qui lui indique si la pipeline s'est bien déroulée (com_pipeline).
### Vision gestionnaire de l'application
* C'est lui qui met en place la pipeline à l'aide des outils préparés par le devops et les tasks de Snowflake.
## Valeur ajoutée
Pipeline ELT automatisé et industrialisé qui transforme des logs CSV "bruts" en données analytiques propres et prêtes pour Power BI/Looker.
## Fichiers à télécharger
Il faut exécuter dans cet ordre les fichiers suivants dans Snowflake :
init_database.sql
create_table.sql (dans le schéma RAW)
create_stream.sql (dans le schéma RAW)
create_functions.sql (dans le schéma COMMON)
create_procedure.sql (dans le schéma COMMON)
create_tasks.sql (dans le schéma COMMON)
Le fichier de données data_source.csv est à mettre dans internal_stage.
Si vous souhaitez mettre en place les rôles, il faut exécuter dans cet ordre les fichiers suivants dans Snowflake :
role_by_admin.sql
role_by_dev_sec_ops_role.sql





