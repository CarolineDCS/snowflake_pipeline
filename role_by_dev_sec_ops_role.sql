-- DROITS DONNES PAR LE DEV_SEC_OPS_ROLE


------dev_ops_role
CREATE ROLE IF NOT EXISTS dev_ops_role;
-- Accès de base
GRANT USAGE ON DATABASE HEALTH_APP TO ROLE dev_ops_role;

-- Création de tables
GRANT CREATE TABLE ON SCHEMA HEALTH_APP.raw TO ROLE dev_ops_role;
GRANT CREATE TABLE ON SCHEMA HEALTH_APP.staging TO ROLE dev_ops_role;
GRANT CREATE TABLE ON SCHEMA HEALTH_APP.common TO ROLE dev_ops_role;

-- Création de fonctions (UDF)
GRANT CREATE FUNCTION ON SCHEMA HEALTH_APP.common TO ROLE dev_ops_role;

-- Création de procédures stockées
GRANT CREATE PROCEDURE ON SCHEMA HEALTH_APP.common TO ROLE dev_ops_role;

-- Création de stages
GRANT CREATE STAGE ON SCHEMA HEALTH_APP.raw TO ROLE dev_ops_role;

-- Création de file formats
GRANT CREATE FILE FORMAT ON SCHEMA HEALTH_APP.raw TO ROLE dev_ops_role;




GRANT ALL ON SCHEMA HEALTH_APP.raw TO ROLE dev_ops_role ;
GRANT ALL ON SCHEMA HEALTH_APP.staging TO ROLE dev_ops_role ;
GRANT ALL ON SCHEMA HEALTH_APP.common TO ROLE dev_ops_role ;


------engineer role
CREATE ROLE IF NOT EXISTS engineer_role;
-- Accès de base
GRANT USAGE ON DATABASE HEALTH_APP TO ROLE  engineer_role ;
GRANT USAGE ON SCHEMA HEALTH_APP.raw TO ROLE  engineer_role;
GRANT USAGE ON SCHEMA HEALTH_APP.common TO ROLE engineer_role;
GRANT USAGE ON SCHEMA HEALTH_APP.staging TO ROLE  engineer_role;

GRANT SELECT ON FUTURE TABLES IN SCHEMA HEALTH_APP.raw TO ROLE engineer_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA HEALTH_APP.staging TO ROLE engineer_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA HEALTH_APP.common TO ROLE engineer_role;


------app role
CREATE ROLE IF NOT EXISTS app_role;
-- Accès de base
GRANT USAGE ON DATABASE HEALTH_APP TO ROLE  app_role ;
GRANT USAGE ON SCHEMA HEALTH_APP.raw TO ROLE  app_role;
GRANT USAGE ON SCHEMA HEALTH_APP.staging TO ROLE  app_role;

---Droit en lecture et en insert
GRANT SELECT, INSERT ON FUTURE TABLES IN SCHEMA HEALTH_APP.raw TO ROLE app_role;
GRANT SELECT, INSERT ON FUTURE TABLES IN SCHEMA HEALTH_APP.staging TO ROLE app_role;

-- Creation et excecution des taches
GRANT CREATE TASK ON SCHEMA HEALTH_APP.common TO ROLE app_role;
GRANT EXECUTE TASK ON ACCOUNT TO ROLE app_role;
GRANT TRUNCATE ON TABLE HEALTH_APP.common.com_data_to_process TO ROLE app_role;