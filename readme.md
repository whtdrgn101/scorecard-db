# Scorecard Database

## Project for Building and loading Sample Data
This project contains the scripts to create the scorecard database as well as load in sample data for the purpose of developing.

### Requirements
- Python 3.8 or Greater
- Postgres 14 or Greater

### Running
- Build Database with the following Commands:
  - `psql scorecard_db < schema/schema.sql`
- Load Data With the Following Commands:
  - `python3 -m venv venv`
  - `source venv/bin/activate`
  - `pip install -r requirements.txt`
  - `python load_data.py`
  