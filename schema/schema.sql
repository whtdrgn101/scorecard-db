SET DEFAULT_TABLESPACE=scorecard_ts;

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
  user_id INT REFERENCES ols.users(id),
  bow_type_id INT REFERENCES ols.bow_type(id),
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
  user_id INT REFERENCES ols.users(id),
  bow_id INT REFERENCES ols.bow(id),
  round_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_round_updated_timestamp_trigger
BEFORE UPDATE ON ols.round
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();