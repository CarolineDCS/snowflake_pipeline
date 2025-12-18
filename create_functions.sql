-- DANS LA BASE DE DONNEE LE MESSAGE EST FORME DE DEUX PARTIES LE TRIGGER ET LE MESSAGE

-- FONCTION POUR RECUPERER LE TRIGGER
CREATE OR REPLACE FUNCTION common.extract_log_trigger(message STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.12'
  HANDLER = 'extract_log_trigger'
AS $$
def extract_log_trigger(message):
    if not message:
        return ""
    parts = message.strip().split(" ")[0].split(":")
    if parts:
        trigger = parts[0].split("=")[-1].strip()
        return trigger
    return ""
$$;



-- FONCTION POUR RECUPERER LE MESSAGE
CREATE OR REPLACE FUNCTION common.extract_log_message(message STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.12'
  HANDLER = 'extract_log_message'
AS $$
def extract_log_message(message):
    if not message or len(message.strip()) == 0:
        return ""
    
    # Extraire le trigger (première partie avant espace, puis avant :)
    first_part = message.strip().split(" ")[0]
    trigger_end = first_part.rfind(":")
    if trigger_end != -1:
        trigger = first_part[:trigger_end].strip()
        rest = message[len(first_part):].lstrip(" :=\t")
    else:
        trigger = ""
        rest = message.strip()
    
    return rest.strip()
$$;



-- FONCTION POUR VERIFIER QUE LE MESSAGE VIENT BIEN D'UN DE NOS TRIGGERS
CREATE OR REPLACE FUNCTION common.check_process_name(name STRING)
  RETURNS BOOLEAN
  LANGUAGE SQL
  AS $$
common.extract_log_trigger(name) in ('HiH_ListenerManager', 'HiH_HiBroadcastUtil', 'Step_StandStepCounter', 'Step_SPUtils', 'Step_NotificationUtil', 'Step_LSC', 'HiH_HiHealthDataInsertStore', 'HiH_DataStatManager','HiH_HiSyncUtil', 'Step_StandReportReceiver', 'Step_ScreenUtil', 'Step_StandStepDataManager', 'Step_ExtSDM', 'HiH_HiHealthBinder', 'Step_DataCache', 'Step_HGNH', 'Step_FlushableStepDataCache', 'HiH_HiAppUtil', 'HiH_HiSyncControl' )	
$$;


-- FONCTION QUI VERIFIE QUE LE MESSAGE NE VIENT PAS DU FUTUR
CREATE OR REPLACE FUNCTION common.check_date(date TIMESTAMP_tz)
  RETURNS BOOLEAN
  LANGUAGE SQL
 
AS $$
   date <= CURRENT_TIMESTAMP()::TIMESTAMP_TZ
   $$;



-- FONCTION QUI VERIFIE QUE LE MESSAGE A BIEN MOINS DE 5 JOURs
CREATE OR REPLACE FUNCTION common.check_late_data(date TIMESTAMP_tz)
  RETURNS BOOLEAN
  LANGUAGE SQL
 
AS $$
    date::DATE >= DATEADD(day, -5, CURRENT_DATE())
   $$;

