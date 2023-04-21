import pandas as pd
import sqlalchemy as sa
from sqlalchemy import create_engine, text
import logging

def setup_logging():
    logging.basicConfig(filename='data_load.log', encoding='utf-8', level=logging.DEBUG,format='%(asctime)s:%(levelname)s:%(message)s')

def run():

    db_url = sa.engine.URL.create(
        drivername="postgresql",
        username="scorecard",
        password="App123@les",
        host="localhost",
        database="scorecard_db",
    )
    engine = create_engine(db_url)

    with engine.connect() as conn:
        
        logging.info("LOAD START")

        ##################
        # REFERENCE DATA #
        ##################
        logging.info("Loading reference data")
        logging.info("Bow Types")
        bow_types = pd.read_csv("data/bow_type.csv")
        logging.debug(f"Bow Type Count: {len(bow_types)}")

        logging.info("Wiping bow_type table")
        conn.execute(text("TRUNCATE ols.bow_type RESTART IDENTITY CASCADE;"))

        for index,bow_type in bow_types.iterrows():
            query = f"INSERT INTO ols.bow_type (name) values('{bow_type['name']}');"
            logging.debug(query)
            conn.execute(text(query))
        
        logging.info("Round Types")
        round_types = pd.read_csv("data/round_type.csv")
        logging.debug(f"round Type Count: {len(round_types)}")

        logging.info("Wiping round_type table")
        conn.execute(text("TRUNCATE ols.round_type RESTART IDENTITY CASCADE;"))

        for index,round_type in round_types.iterrows():
            query = f"INSERT INTO ols.round_type (name) values('{round_type['name']}');"
            logging.debug(query)
            conn.execute(text(query))

        logging.info("Committing reference data DB changes")
        conn.commit()

        #########
        # USERS #
        #########
        logging.info("Loading user data CSV")
        users = pd.read_csv('data/users.csv')
        logging.debug(f"User Count: {len(users)}")

        logging.info("Wiping users table")
        conn.execute(text("TRUNCATE ols.users RESTART IDENTITY CASCADE;"))

        for index, user in users.iterrows():
            query = f"INSERT INTO ols.users (email, name) VALUES('{user['email']}','{user['name']}');"
            logging.debug(query)
            conn.execute(text(query))

        logging.info("Commiting users DB changes")
        conn.commit()

        ########
        # BOWS #
        ########
        logging.info("Loading bow data CSV")
        bows = pd.read_csv('data/bow.csv')
        logging.debug(f"Bow Count: {len(bows)}")

        logging.info("Wiping bow table")
        conn.execute(text("TRUNCATE ols.bow RESTART IDENTITY CASCADE;"))

        for index, bow in bows.iterrows():
            query = f"INSERT INTO ols.bow (user_id, bow_type_id, name, draw_weight) VALUES({bow['user_id']},{bow['bow_type_id']},'{bow['name']}',{bow['draw_weight']});"
            logging.debug(query)
            conn.execute(text(query))

        logging.info("Commiting bow DB changes")
        conn.commit()

        logging.info("LOAD DONE")

if __name__ == "__main__":
    setup_logging()
    run()