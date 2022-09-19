FROM python:3.7.0-alpine

ENV APP_PATH=/usr/src/app
WORKDIR ${APP_PATH}

COPY . ${APP_PATH}

RUN pip install --no-cache-dir -r requirements.txt

ENV PYTHON_APP=app
ENV FLASK_APP=app
ENV PORT=5000
ENV TIMEOUT=100

EXPOSE $PORT

CMD gunicorn ${PYTHON_APP}:${FLASK_APP} -b :$PORT --timeout ${TIMEOUT}
