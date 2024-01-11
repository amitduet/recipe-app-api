FROM python:3.10-alpine3.16
LABEL maintainer = "google.com"

ENV PYTHONUNBUFFERED 1 

RUN pip install Django
RUN pip install flake8

COPY ./requirements.txt /tmp/requiremnets.txt
COPY ./requirements.dev.txt /tmp/requiremnets.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requiremnets.txt && \
    if [$DEV = "true"]; \
        then /py/bin/pip install -r /tmp/requiremnets.dev.txt ; \
        fi && \ 
    rm -rf /tmp && \
    adduser \
            --disabled-password \
            --no-create-home \
            django-user

    ENV PATH ="/py/bin:$PATH"

    USER django-user 