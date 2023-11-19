FROM python:3.11.6-slim as compiler
WORKDIR /app

# Create a virtual environment and install
# the necessary dependencies
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY ./requirements.txt /app/requirements.txt
RUN \
	pip install --upgrade pip && \
	apt-get update && apt install -y libjpeg-dev zlib1g-dev && \
	apt install -y gcc libpq-dev && \
	pip install -r requirements.txt --use-pep517

# Build target
FROM python:3.11.6 as build
WORKDIR /app

COPY --from=compiler /opt/venv /opt/venv
COPY tango_with_django_project/ /app

ENV PATH="/opt/venv/bin:$PATH"
# Run migrations
RUN python3 manage.py migrate

# Test target
FROM build as test
ENTRYPOINT ["python"]
CMD ["manage.py", "test", "--verbosity=0"]

# Production target
FROM build as production
ENTRYPOINT ["python"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]

