FROM python:3.11.6-slim as compiler
#ENV PYTHONUNBUFFERED 1
WORKDIR /app

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY ./requirements.txt /app/requirements.txt
RUN \
	pip install --upgrade pip && \
	apt-get update && apt install -y libjpeg-dev zlib1g-dev && \
	apt install -y gcc libpq-dev && \
	pip install -r requirements.txt --use-pep517

FROM python:3.11.6
WORKDIR /app

COPY --from=compiler /opt/venv /opt/venv
COPY tango_with_django_project/ /app

ENV PATH="/opt/venv/bin:$PATH"

ENTRYPOINT ["python"]
CMD ["manage.py", "migrate"]
#CMD ["manage.py", "test", "--verbosity=0"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]

