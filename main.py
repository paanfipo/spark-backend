# main.py - Versión Integrada con Entrenador IA
from fastapi import FastAPI, Depends, HTTPException, status, Body
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import func
import json
from fastapi.security import OAuth2PasswordRequestForm
from pydantic import BaseModel # Necesario para el Entrenador

import crud, models, schemas, auth
from database import engine, get_db

# Crear tablas en la base de datos
models.Base.metadata.create_all(bind=engine) 

app = FastAPI()

# --- MODELO DE DATOS PARA EL ENTRENADOR ---
class MetricasEntrenador(BaseModel):
    nombre_juego: str
    aciertos: float
    comisiones: int
    omisiones: int
    tr_medio: float
    amplitud: int = None

# --- CONFIGURACIÓN DE CORS ---
origins = [
    "http://localhost:5173",
    "http://localhost:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------------------------------------------------------
# ENDPOINT: ENTRENADOR VIRTUAL (NUEVO)
# ----------------------------------------------------------------
@app.post("/entrenador/analizar", status_code=200)
async def analizar_entrenamiento_ia(
    datos: MetricasEntrenador, 
    db: Session = Depends(get_db), 
    current_user: models.User = Depends(auth.get_current_user)
):
    """
    Analiza métricas y decide el siguiente paso del entrenamiento.
    """
    # Lógica inteligente basada en tus tablas de errores
    siguiente = "Hojas navegantes"
    if datos.comisiones > 8:
        siguiente = "Enfoca la flecha" # Prioriza control de impulsos
    elif datos.aciertos < 70:
        siguiente = "Matriz de memoria" # Refuerza bases si falla mucho
    
    return {
        "diagnostico": f"Perfil detectado para {current_user.email}: Procesamiento rápido con necesidad de ajuste en precisión.",
        "siguiente_juego": siguiente,
        "mensaje": f"¡Buen intento en {datos.nombre_juego}! El entrenador sugiere trabajar ahora en '{siguiente}' para equilibrar tu rendimiento."
    }

# ----------------------------------------------------------------
# ENDPOINTS ORIGINALES DE USUARIOS Y SESIONES
# ----------------------------------------------------------------

@app.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user)

@app.post("/token")
def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = crud.authenticate_user(db, email=form_data.username, password=form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = auth.create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/users/me/", response_model=schemas.User)
def read_users_me(current_user: models.User = Depends(auth.get_current_user)):
    return current_user

# --- ENDPOINTS DE JUEGOS ---

@app.post("/games/populate", status_code=201)
def populate_games_endpoint(db: Session = Depends(get_db)):
    return crud.populate_games(db)

@app.get("/games/", response_model=list[schemas.Game])
def read_games(skip: int = 0, limit: int = 100, db: Session = Depends(get_db), current_user: models.User = Depends(auth.get_current_user)):
    return crud.get_games(db, skip=skip, limit=limit)

@app.post("/games/{game_id}/start-play", response_model=schemas.GamePlay)
def start_game_play_endpoint(
    game_id: int, db: Session = Depends(get_db), current_user: models.User = Depends(auth.get_current_user)
):
    return crud.start_new_gameplay(db=db, user_id=current_user.id, game_id=game_id)

@app.patch("/gameplays/{gameplay_id}/results")
def patch_gameplay_results(gameplay_id: int, body: dict = Body(...), db: Session = Depends(get_db)):
    gp = db.query(models.GamePlay).filter(models.GamePlay.id == gameplay_id).first()
    if not gp:
        raise HTTPException(status_code=404, detail="Gameplay no encontrado")
    
    score = body.get("score")
    if score is not None:
        gp.score = max(int(gp.score or 0), int(score))

    incoming_results = body.get("results_data")
    if incoming_results is not None:
        gp.results_data = incoming_results

    db.add(gp)
    db.commit()
    db.refresh(gp)
    return {"ok": True}