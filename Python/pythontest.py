import configparser

config = configparser.ConfigParser()
config.read('key.ini')

host = config['jualo_slave_db']['hostname']
user = config['jualo_slave_db']['user']
password = config['jualo_slave_db']['password']
db = config['jualo_slave_db']['db']

print(f'Host: {host}')
print(f'User: {user}')
print(f'Password: {password}')
print(f'Database: {db}')