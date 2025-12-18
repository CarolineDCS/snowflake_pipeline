--ALTER TASK common.com_insert_backup_task SUSPEND;
--ALTER TASK common.data_quality_task SUSPEND;
--ALTER TASK common.late_data_task  SUSPEND;




CREATE OR ALTER TASK common.com_insert_backup_task
WAREHOUSE = COMPUTE_WH
WHEN SYSTEM$STREAM_HAS_DATA('RAW.RAW_EVENTS_STREAM')
AS 
BEGIN
CALL common.identify_new_data();
END;

CREATE OR ALTER TASK common.data_quality_task
WAREHOUSE = COMPUTE_WH
AFTER  common.com_insert_backup_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.data_quality(:v_graph_id);
END;

CREATE OR ALTER TASK common.late_data_task
WAREHOUSE = COMPUTE_WH
AFTER common.data_quality_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.late_data(:v_graph_id);
END;


CREATE OR ALTER TASK common.hih_listener_manager
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('hih_listener_manager', 'HiH_ListenerManager',:v_graph_id);
END;


CREATE OR ALTER TASK common.hih_hi_Broadcast_util
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('hih_hi_Broadcast_util', 'HiH_HiBroadcastUtil',:v_graph_id);
END;

CREATE OR ALTER TASK common.step_stand_step_counter
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_stand_step_counter', 'Step_StandStepCounter',:v_graph_id);
END;

CREATE OR ALTER TASK common.step_sp_utils
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_sp_utils', 'Step_SPUtils',:v_graph_id);
END;

CREATE OR ALTER TASK common.step_notification_util
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_notification_util', 'Step_NotificationUtil',:v_graph_id);
END;

CREATE OR ALTER TASK common.step_lsc
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_lsc', 'Step_LSC',:v_graph_id);
END;


CREATE OR ALTER TASK common.hih_hi_health_data_insert_store
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('hih_hi_health_data_insert_store', 'HiH_HiHealthDataInsertStore',:v_graph_id);
END;


CREATE OR ALTER TASK common.hih_data_stat_manager
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('hih_data_stat_manager', 'HiH_DataStatManager',:v_graph_id);
END;





CREATE OR ALTER TASK common.hih_hi_sync_util
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('hih_hi_sync_util', 'HiH_HiSyncUtil',:v_graph_id);
END;


CREATE OR ALTER TASK common.step_stand_report_receiver
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_stand_report_receiver', 'Step_StandReportReceiver',:v_graph_id);
END;

CREATE OR ALTER TASK common.step_stand_step_data_manager
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_stand_step_data_manager', 'Step_StandStepDataManager',:v_graph_id);
END;


CREATE OR ALTER TASK common.step_screen_util
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_screen_util', 'Step_ScreenUtil',:v_graph_id);
END;

CREATE OR ALTER TASK common.hih_hi_health_binder
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('hih_hi_health_binder', 'HiH_HiHealthBinder',:v_graph_id);
END;


CREATE OR ALTER TASK common.step_ext_sdm
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_ext_sdm', 'Step_ExtSDM',:v_graph_id);
END;


CREATE OR ALTER TASK common.step_data_cache
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_data_cache', 'Step_DataCache',:v_graph_id);
END;


CREATE OR ALTER TASK common.step_hgnh
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_hgnh', 'Step_HGNH',:v_graph_id);
END;


CREATE OR ALTER TASK common.step_flushable_step_data_cache
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('step_flushable_step_data_cache', 'Step_FlushableStepDataCache',:v_graph_id);
END;


CREATE OR ALTER TASK common.hih_hi_app_util
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('hih_hi_app_util', 'HiH_HiAppUtil',:v_graph_id);
END;


CREATE OR ALTER TASK common.hih_hi_sync_control
WAREHOUSE = COMPUTE_WH
AFTER common.late_data_task
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
BEGIN
    CALL common.enrich_data('hih_hi_sync_control', 'HiH_HiSyncControl',:v_graph_id);
END;




CREATE OR ALTER TASK common.final_task
WAREHOUSE = COMPUTE_WH
FINALIZE = 'common.com_insert_backup_task'
AS
DECLARE 
v_graph_id STRING := SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');
started_at TIMESTAMP_TZ := TO_TIMESTAMP_TZ(SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_ORIGINAL_SCHEDULED_TIMESTAMP'));
BEGIN
    CALL common.final(:v_graph_id,:started_at);
END;

ALTER TASK common.hih_listener_manager RESUME;
ALTER TASK common.hih_hi_Broadcast_util RESUME;
ALTER TASK common.step_stand_step_counter RESUME;
ALTER TASK common.step_sp_utils RESUME;
ALTER TASK common.step_notification_util RESUME;
ALTER TASK common.step_lsc RESUME;
ALTER TASK common.hih_hi_health_data_insert_store RESUME;
ALTER TASK common.hih_data_stat_manager RESUME;
ALTER TASK common.hih_hi_sync_util RESUME;
ALTER TASK common.step_stand_report_receiver RESUME;
ALTER TASK common.step_stand_step_data_manager RESUME;
ALTER TASK common.step_screen_util RESUME;
ALTER TASK common.hih_hi_health_binder RESUME;
ALTER TASK common.step_ext_sdm RESUME;
ALTER TASK common.step_data_cache RESUME;
ALTER TASK common.step_hgnh RESUME;
ALTER TASK common.step_flushable_step_data_cache RESUME;
ALTER TASK common.hih_hi_app_util RESUME;
ALTER TASK common.hih_hi_sync_control RESUME;
ALTER TASK common.late_data_task RESUME;
ALTER TASK common.data_quality_task RESUME;
ALTER TASK common.final_task RESUME ;
ALTER TASK common.com_insert_backup_task RESUME ;


--ALTER TASK common.hih_listener_manager SUSPEND;
--ALTER TASK common.hih_hi_Broadcast_util SUSPEND;
--ALTER TASK common.step_stand_step_counter SUSPEND;
--ALTER TASK common.step_sp_utils SUSPEND;
--ALTER TASK common.step_notification_util SUSPEND;
--ALTER TASK common.step_lsc SUSPEND;
--ALTER TASK common.hih_hi_health_data_insert_store SUSPEND;
--ALTER TASK common.hih_data_stat_manager SUSPEND;
--ALTER TASK common.hih_hi_sync_util  SUSPEND;
--ALTER TASK common.step_stand_report_receiver SUSPEND;
--ALTER TASK common.step_stand_step_data_manager SUSPEND;
--ALTER TASK common.step_screen_util SUSPEND;
--ALTER TASK common.hih_hi_health_binder SUSPEND;
--ALTER TASK common.step_ext_sdm SUSPEND;
--ALTER TASK common.step_data_cache SUSPEND;
--ALTER TASK common.step_hgnh SUSPEND;
--ALTER TASK common.step_flushable_step_data_cache SUSPEND;
--ALTER TASK common.hih_hi_app_util SUSPEND;
--ALTER TASK common.hih_hi_sync_control SUSPEND;



