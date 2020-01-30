import pandas as pd
import sqlalchemy
from sqlalchemy.engine.url import URL
import user_key

carro_wholesale_db_url = URL(**(user_key.carro_wholesale_db))
jay_test_db_url = URL(**(user_key.jay_test_db))

engine_in = sqlalchemy.create_engine(carro_wholesale_db_url)
engine_out = sqlalchemy.create_engine(jay_test_db_url)

query = '''
    SELECT
        id,
        DATE(DATE_ADD(created_at, interval 8 hour)) as created_at,
        title,
        reserve_price
    FROM auctions
    WHERE
        deleted_at is null AND 
        country_id = 1
    '''

df = pd.read_sql_query(query, engine_in)

df.to_sql(
    name = 'test_table',
    con = engine_out,
    index = False,
    if_exists = 'replace'
)
