CREATE OR REPLACE FUNCTION ols.trigger_set_updated_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_date = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ols.trigger_update_round_score()
  RETURNS TRIGGER
  language plpgsql
  AS
$$
DECLARE 
  round_total integer;
BEGIN
  
  SELECT SUM(score)
  INTO round_total
  FROM ols.end
  WHERE round_id = NEW.round_id;
  
  UPDATE ols.round SET score_total = round_total WHERE id=NEW.round_id;

  RETURN NEW;

END;
$$;

