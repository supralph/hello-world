tickets_mart_sql = '''
    SELECT
        *
    FROM tickets
    WHERE
        YEAR(created_at) >= 2019;
    '''

abc_auctions = '''
    SELECT
        id,
        DATE(DATE_ADD(created_at, interval 8 hour)) as created_at,
        title,
        reserve_price
    FROM auctions
    WHERE
        deleted_at is null AND 
        country_id = 1;
    '''
