import pandas as pd
import sqlalchemy as sa
from sqlalchemy import create_engine, text
import logging
import os
import hashlib
from load_data import run as run_data_load

def setup_logging():
    logging.basicConfig(filename='data_load.log', encoding='utf-8', level=logging.DEBUG,format='%(asctime)s:%(levelname)s:%(message)s')

def generate_md5_hash(string):
    md5_hash = hashlib.md5()
    md5_hash.update(string.encode('utf-8'))
    return md5_hash.hexdigest()

def run():

    db_url = sa.engine.URL.create(
        drivername="postgresql",
        username=os.environ.get('SCORECARD_USER'),
        password=os.environ.get('SCORECARD_PASS'),
        host=os.environ.get('SCORECARD_HOST'),
        database=os.environ.get('SCORECARD_DB'),
    )
    engine = create_engine(db_url)

    # Open and read the file as a single buffer
    with open('schema/schema.sql', 'r') as fd:
        sqlFile = fd.read()

    # all SQL commands (split on ';')
    sqlCommands = sqlFile.split(';')

    with open('schema/functions.sql') as fd:
        functions = fd.read()

    with open('schema/triggers.sql') as fd:
        triggers = fd.read()

    if len(sqlCommands) > 0 :
        
        with engine.connect() as conn:
            
            logging.info("BUILD DB START")

            logging.info('CREATE SCHEMA')
            for command in sqlCommands:                
                
                if len(command.strip()) > 0:
                    logging.debug(command)
                    conn.execute(text(command.strip()))
            
                conn.commit()

            logging.info('CREATE UDFs')
            conn.execute(text(functions))
            conn.commit()

            logging.info('CREATE TRIGGERS')
            conn.execute(text(triggers));
            conn.commit()

            logging.info("BUILD DB FINISHED")
            run_data_load()

if __name__ == "__main__":
    setup_logging()
    run()