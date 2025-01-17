# Base image
FROM python:3.9-slim

# Installer curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copier les fichiers
COPY . /app

# Installer les dépendances
RUN pip install -r requirements.txt

# Exposer le port
EXPOSE 5000

# Lancer l'application
CMD ["python", "app.py"]
