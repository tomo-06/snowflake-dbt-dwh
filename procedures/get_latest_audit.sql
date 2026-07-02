-- 監査ログのうち、テーブルごとの最新状況を返すプロシージャ
CREATE OR REPLACE PROCEDURE TAXI_DWH.OPS.GET_LATEST_AUDIT()
RETURNS TABLE(table_name STRING, row_count NUMBER, status STRING, logged_at TIMESTAMP_NTZ)
LANGUAGE SQL
AS
$$
DECLARE
  rs RESULTSET;
BEGIN
  rs := (
    SELECT table_name, row_count, status, logged_at
    FROM TAXI_DWH.OPS.LOAD_AUDIT_LOG
    QUALIFY ROW_NUMBER() OVER (PARTITION BY table_name ORDER BY logged_at DESC) = 1
  );
  RETURN TABLE(rs);
END;
$$;