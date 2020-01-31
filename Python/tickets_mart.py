import configparser
import logging
import pandas as pd
import sqlalchemy
from sqlalchemy.engine.url import URL
import database_key # log-in credentials for databases
import sql_queries # sql query to extract out from database

logging.basicConfig(
    filename='ticket_mart_log.log',
    filemode= 'a',
    format = '%(asctime)s :: %(levelname)s :: %(funcName)s :: %(message)s',
    level = logging.INFO
)

logging.info("----------------------------------------------")
logging.info("Extracting data from Carro Wholesale database.")


carro_wholesale_db_url = URL(**(database_key.carro_wholesale_db))
jay_test_db_url = URL(**(database_key.jay_test_db))

engine_out = sqlalchemy.create_engine(carro_wholesale_db_url) # extract data from database
engine_in = sqlalchemy.create_engine(jay_test_db_url) # dump data into database

query = sql_queries.tickets_mart_sql

df = pd.read_sql_query(query, engine_out)

df.to_sql(
    name = 'test_ticket_mart',
    con = engine_in,
    index = False,
    if_exists = 'replace'
)
logging.info("There are {} tickets".format(len(df)))
logging.info("Data has been extracted to Jay Localhost database.")

