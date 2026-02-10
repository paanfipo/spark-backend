# database.py
#from sqlalchemy import create_engine
#from sqlalchemy.ext.declarative import declarative_base
#from sqlalchemy.orm import sessionmaker

# URL de conexión a tu base de datos (ajústala con tus credenciales)
#SQLALCHEMY_DATABASE_URL = "postgresql://postgres:admin@localhost:5432/spark_db"

#engine = create_engine(SQLALCHEMY_DATABASE_URL)

#SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base será la clase fundamental de la que heredarán todos nuestros modelos
#Base = declarative_base()

# Dependencia para la sesión de la base de datos
#def get_db():
#    db = SessionLocal()
#    try:
#        yield db
#    finally:
#        db.close()

# database.py
import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# 1. URL por defecto para cuando local
LOCAL_DATABASE_URL = "postgresql://postgres:admin@localhost:5432/spark_db"

# 2. os.getenv buscará una variable llamada "DATABASE_URL" en Railway.
# Si no la encuentra esta local usará la LOCAL_DATABASE_URL.
DATABASE_URL = os.getenv("DATABASE_URL", LOCAL_DATABASE_URL)

# 3. Corrección necesaria para SQLAlchemy y Railway (cambia postgres:// por postgresql://)
if DATABASE_URL and DATABASE_URL.startswith("postgres://"):
    DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Dependencia para la sesión de la base de datos
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()