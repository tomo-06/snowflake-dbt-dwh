-- 監査テーブル用のスキーマ作成
CREATE SCHEMA IF NOT EXISTS TAXI_DWH.OPS;

-- 監査テーブル作成
CREATE TABLE IF NOT EXISTS TAXI_DWH.OPS.LOAD_AUDIT_LOG (
  audit_id      NUMBER IDENTITY START 1 INCREMENT 1,
  table_name    STRING        NOT NULL,
  row_count     NUMBER,
  status        STRING        NOT NULL,
  message       STRING,
  logged_at     TIMESTAMP_NTZ NOT NULL DEFAULT CURRENT_TIMESTAMP()
);