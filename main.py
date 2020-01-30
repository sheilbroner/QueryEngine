import sqlalchemy as sa
import json
import psycopg2

with open('secrets/dtu_redshift_credentials_dev.json') as f:
    creds = json.load(f)

username = creds['redshift_user']
pword = creds['redshift_password']
port = creds['redshift_port']
host = creds['redshift_host']
db = creds['redshift_dbname']

url = f'redshift+psycopg2://{username}:{pword}@{host}:{port}/{db}'

eng = sa.create_engine(url)


