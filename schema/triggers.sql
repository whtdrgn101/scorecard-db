CREATE TRIGGER set_account_updated_timestamp_trigger
BEFORE UPDATE ON ols.users
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TRIGGER set_bow_type_updated_timestamp_trigger
BEFORE UPDATE ON ols.bow_type
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TRIGGER set_bow_type_updated_timestamp_trigger
BEFORE UPDATE ON ols.round_type
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TRIGGER set_bow_updated_timestamp_trigger
BEFORE UPDATE ON ols.bow
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TRIGGER set_round_updated_timestamp_trigger
BEFORE UPDATE ON ols.round
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TRIGGER set_end_updated_timestamp_trigger
BEFORE UPDATE ON ols.end
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_set_updated_timestamp();

CREATE TRIGGER set_round_total_trigger
AFTER INSERT OR UPDATE ON ols.end
FOR EACH ROW
EXECUTE PROCEDURE ols.trigger_update_round_score();