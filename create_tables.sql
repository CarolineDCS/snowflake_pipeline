
-- CREATION DES TABLES DU SCHEMA RAW
CREATE OR ALTER TABLE raw.raw_events ( 
       event_timestamp TIMESTAMP_TZ,
       process_id NUMBER,
       message STRING,
       event_id INT AUTOINCREMENT NOORDER
     ) CHANGE_TRACKING = TRUE;




-- CREATION DES TABLES DU SCHEMA COMMON
CREATE OR ALTER TABLE common.com_data_to_process ( 
       event_timestamp TIMESTAMP_TZ,
       process_id NUMBER,
       message STRING,
       event_id INT 
     ) ;

CREATE OR ALTER TABLE common.com_late_data( 
       event_id INT,
       graph_run_group_id STRING
     ) ;

CREATE OR ALTER TABLE common.com_logging(
        create_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP(),
        graph_run_group_id STRING,
        table_name STRING,
        n_rows NUMBER,
        error_message STRING DEFAULT NULL
       );
       
CREATE OR ALTER TABLE common.com_pipeline(
        create_at TIMESTAMP_TZ,
        finished_at TIMESTAMP_TZ,
        graph_run_group_id STRING,
        STATUS STRING 
        );

CREATE OR ALTER TABLE common.com_abnormal_event(
    EVENT_ID NUMBER,
    TIMESTAMP_not_ok BOOLEAN,
    PROCESS_NAME_not_ok BOOLEAN,
     graph_run_group_id STRING
);

--- CREATION DES TABLE DU SCHEMA STAGING

CREATE OR ALTER TABLE staging.hih_listener_manager (
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.hih_hi_broadcast_util (
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.step_stand_step_counter (
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.step_sp_utils (
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.step_lsc (
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER  TABLE staging.hih_hi_health_data_insert_store (
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.hih_data_stat_manager (
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER  TABLE staging.hih_hi_sync_util (
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER  TABLE staging.step_stand_report_receiver (
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.step_screen_util (
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);


CREATE OR ALTER TABLE staging.step_ext_sdm(
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.step_flushable_step_data_cache(
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.hih_hi_app_util(
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.hih_hi_health_binder(
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.hih_hi_sync_control(
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.step_stand_step_data_manager(
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.step_data_cache(
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.step_hgnh(
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);

CREATE OR ALTER TABLE staging.step_notification_util(
    event_timestamp TIMESTAMP_TZ,
    log_trigger STRING,
    process_id NUMBER,
    message STRING
);
