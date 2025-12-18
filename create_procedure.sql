-- POUR METTRE LES NOUVELLES DONNEES DANS LA TABLE DE TRAITEMENT
CREATE OR REPLACE PROCEDURE common.identify_new_data()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
    INSERT INTO common.com_data_to_process(event_timestamp,process_id, message, event_id)
    (SELECT event_timestamp, process_id, message, event_id FROM raw.raw_events_stream);
$$;


--- VALIDER LES NOUVELLES DONNEES ET METTRE LES MAUVAISE dans com_abnormal_vent
CREATE OR REPLACE PROCEDURE common.data_quality(graph_run_group_id STRING)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
Let nb_row_false INT := 0;
INSERT INTO common.com_abnormal_event (event_id, timestamp_not_ok, process_name_not_ok, graph_run_group_id )
WITH source 
AS ( SELECT 
    event_id, 
    common.check_date(event_timestamp) as timestamp_not_ok,
    common.check_process_name(message) as process_name_not_ok,
    :graph_run_group_id
    FROM common.com_data_to_process)
SELECT *
FROM source
WHERE  timestamp_not_ok = FALSE OR process_name_not_ok = FALSE ;
nb_row_false := SQLROWCOUNT;
RETURN nb_row_false;
END;
$$;


--- VERIFIER PARMIS LES DONNEES VALIDER CELLE QUI ARRIVE TROP TARD

CREATE OR REPLACE PROCEDURE common.late_data(graph_run_group_id STRING)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
Let nb_row_late INT := 0;
INSERT INTO common.com_late_data ( event_id, graph_run_group_id)
WITH source 
AS ( SELECT 
    event_id, 
    :graph_run_group_id
    FROM common.com_data_to_process
    WHERE NOT common.check_late_data(event_timestamp) )
SELECT *
FROM source;
nb_row_late := SQLROWCOUNT;
RETURN nb_row_late;
END;
$$;



--- FAIRE UN LOGG POUR LES DONNEES QUE L ON ARRIVE ou PAS A METTRE DANS UNE TABLE FINALE
CREATE OR REPLACE PROCEDURE common.com_log_result(graph_run_group_id STRING, table_name STRING , n_rows NUMBER, error_message STRING)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
INSERT INTO common.com_logging(graph_run_group_id, table_name, n_rows,error_message)
VALUES (:graph_run_group_id, :table_name, :n_rows, :error_message);
$$;

-- DISPATCHER LES DONNEES DANS LES BONNES TABLES 
CREATE OR REPLACE PROCEDURE common.enrich_data(table_name STRING, process_name STRING, graph_run_group_id STRING)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    full_table_name STRING := CONCAT('staging.', :table_name);
    insert_exception EXCEPTION (-20001, 'Error insert');
     sql_row_count_var INT DEFAULT 0;
BEGIN
    INSERT INTO IDENTIFIER(:full_table_name) (event_timestamp, process_id, log_trigger, message)
   WITH union_bad_data AS (
    SELECT ab.event_id 
    FROM common.com_abnormal_event ab
    UNION 
    SELECT ld.event_id 
    FROM common.com_late_data ld
),
source AS (
    SELECT
        ra.event_timestamp,
        ra.process_id,
        common.extract_log_trigger(ra.message) AS process_name, 
        common.extract_log_message(ra.message) AS message
    FROM raw.raw_events ra
    JOIN common.com_data_to_process dtp ON ra.event_id = dtp.event_id
    WHERE ra.event_id NOT IN (SELECT event_id FROM union_bad_data)
      AND common.extract_log_trigger(ra.message) = :process_name  -- ← Calculé explicitement
)
SELECT
    event_timestamp,
    process_id,
    process_name,
    message
FROM source;                                                   ;
    sql_row_count_var := SQLROWCOUNT;
    CALL common.com_log_result(:graph_run_group_id, :table_name ,:sql_row_count_var, NULL);
    RETURN sql_row_count_var;
   EXCEPTION
   WHEN OTHER THEN 
   CALL common.com_log_result(:graph_run_group_id, :table_name ,NULL, :SQLERRM);
   RETURN sql_row_count_var;
END;
$$;



 
CREATE OR REPLACE PROCEDURE common.final(v_graph_id STRING, started_at TIMESTAMP_TZ)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    LET nb_error INT := 0; 
    SELECT count(*) INTO nb_error
    FROM common.com_logging
    WHERE  error_message IS NOT NULL AND  graph_run_group_id = :v_graph_id;   
    
    TRUNCATE common.com_data_to_process;
    
    INSERT INTO common.com_pipeline(finished_at, create_at, graph_run_group_id, STATUS )
    VALUES (CURRENT_TIMESTAMP(),:started_at,:v_graph_id, IFF(:nb_error = 0, 'SUCCED', 'FAILED'));

    RETURN nb_error;
END;
$$;



