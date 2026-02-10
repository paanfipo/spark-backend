# database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# URL de conexión a tu base de datos (ajústala con tus credenciales)
SQLALCHEMY_DATABASE_URL = "postgresql://postgres:admin@localhost:5432/spark_db"

engine = create_engine(SQLALCHEMY_DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base será la clase fundamental de la que heredarán todos nuestros modelos
Base = declarative_base()

# Dependencia para la sesión de la base de datos
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()