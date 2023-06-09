ALTER DATABASE scorecard_db SET SEARCH_PATH = "$user", ols, public;
ALTER ROLE scorecard SET SEARCH_PATH = "$user", ols, publc;
DROP SCHEMA IF EXISTS ols CASCADE;
CREATE SCHEMA IF NOT EXISTS ols;

CREATE TABLE IF NOT EXISTS ols.users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    last_login_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ols.bow_type (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ols.round_type (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ols.bow (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES ols.users(id) ON DELETE CASCADE,
  bow_type_id INT REFERENCES ols.bow_type(id) ON DELETE SET NULL,
  name VARCHAR(100) NOT NULL,
  draw_weight FLOAT NOT NULL DEFAULT 0.0,
  created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

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

CREATE TABLE IF NOT EXISTS ols.end (
  id SERIAL PRIMARY KEY,
  round_id INT REFERENCES ols.round(id) ON DELETE CASCADE,
  score INT NOT NULL default 0,
  created_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);