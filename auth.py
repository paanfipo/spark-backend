# auth.py
# <<< CÓDIGO DE SEGURIDAD AISLADO >>>

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
import models
from database import get_db
from passlib.context import CryptContext


# --- CONFIGURACIÓN DE SEGURIDAD ---
# ¡IMPORTANTE! Usa la clave secreta segura que generaste
SECRET_KEY = "tu_super_secreto_de_32_caracteres_aqui"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Esta línea es la que le dice a FastAPI cómo encontrar el token
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# --- FUNCIONES DE TOKEN ---
def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

# --- FUNCIÓN DE SEGURIDAD (DEPENDENCIA) ---
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    import crud
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    user = crud.get_user_by_email(db, email=email)
    if user is None:
        raise credentials_exception
    return user

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)
