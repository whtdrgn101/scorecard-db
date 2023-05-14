# Dockerfile

# pull the official docker image
FROM python:3.11.1-slim

# set work directory
WORKDIR /app

# set env variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV SCORECARD_USER scorecard
ENV SCORECARD_PASS App123@les
ENV SCORECARD_HOST 192.168.2.144
ENV SCORECARD_DB scorecard_db

# install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# copy project
COPY . .
CMD ["python", "build_db.py"]