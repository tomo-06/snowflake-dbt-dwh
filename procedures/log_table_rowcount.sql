-- 監査プロシージャ v2（例外処理あり）
CREATE OR REPLACE PROCEDURE TAXI_DWH.OPS.LOG_TABLE_ROWCOUNT(target_table STRING)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
  row_cnt INTEGER;
BEGIN
  -- 対象テーブルの行数を数える（動的SQL）
  SELECT COUNT(*) INTO row_cnt
  FROM IDENTIFIER(:target_table);

  -- 成功を記録
  INSERT INTO TAXI_DWH.OPS.LOAD_AUDIT_LOG (table_name, row_count, status)
  VALUES (:target_table, :row_cnt, 'SUCCESS');

  RETURN 'Logged: ' || :target_table || ' = ' || :row_cnt || ' rows';

EXCEPTION
  WHEN OTHER THEN
    -- 失敗を記録してから、エラー内容を返す
    INSERT INTO TAXI_DWH.OPS.LOAD_AUDIT_LOG (table_name, row_count, status, message)
    VALUES (:target_table, NULL, 'ERROR', :sqlerrm);

    RETURN 'ERROR logging ' || :target_table || ': ' || :sqlerrm;
END;
$$;