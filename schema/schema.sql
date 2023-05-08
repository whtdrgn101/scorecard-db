SET DEFAULT_TABLESPACE=scorecard_ts;

ALTER DATABASE scorecard_db SET SEARCH_PATH = "$user", ols, public;
ALTER ROLE scorecard SET SEARCH_PATH = "$user", ols, publc;

DROP SCHEMA IF EXISTS ols CASCADE;

CREATE SCHEMA IF NOT EXISTS ols;

CREATE OR REPLACE FUNCTION ols.trigger_set_updated_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_date = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS ols.users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    last_login_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_account_updated_timestamp_trigger
BEFORE UPDATE ON ols.users
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TABLE IF NOT EXISTS ols.bow_type (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_bow_type_updated_timestamp_trigger
BEFORE UPDATE ON ols.bow_type
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TABLE IF NOT EXISTS ols.round_type (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_bow_type_updated_timestamp_trigger
BEFORE UPDATE ON ols.round_type
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TABLE IF NOT EXISTS ols.bow (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES ols.users(id) ON DELETE CASCADE,
  bow_type_id INT REFERENCES ols.bow_type(id) ON DELETE SET NULL,
  name VARCHAR(100) NOT NULL,
  draw_weight FLOAT NOT NULL DEFAULT 0.0,
  created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_bow_updated_timestamp_trigger
BEFORE UPDATE ON ols.bow
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TABLE IF NOT EXISTS ols.round (
  id SERIAL PRIMARY KEY,
  round_type_id INT REFERENCES ols.round_type(id) ON DELETE SET NULL,
  user_id INT REFERENCES ols.users(id) ON DELETE CASCADE,
  bow_id INT REFERENCES ols.bow(id) ON DELETE CASCADE,
  round_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  score_total INT NOT NULL default 0,
  created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_round_updated_timestamp_trigger
BEFORE UPDATE ON ols.round
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TABLE IF NOT EXISTS ols.end (
  id SERIAL PRIMARY KEY,
  round_id INT REFERENCES ols.round(id) ON DELETE CASCADE,
  score INT NOT NULL default 0,
  created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_end_updated_timestamp_trigger
BEFORE UPDATE ON ols.end
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

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

CREATE TRIGGER set_round_total_trigger
AFTER INSERT OR UPDATE ON ols.end
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_update_round_score();
