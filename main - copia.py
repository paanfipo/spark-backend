# main.py
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from sqlalchemy import func
import json

# Importamos get_db desde su nuevo hogar en database.py
from . import crud, models, schemas, auth
from .database import engine, get_db

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# <<< PARA CONECTAR EL FRONTEND CON EL BACKEND >>>
origins = [
    "http://localhost:5173", # El origen de tu app de React en desarrollo
    "http://localhost:3000", # Otra URL común para desarrollo de React
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- ENDPOINTS ---

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

# --- ENDPOINT PARA JUEGOS ---

@app.post("/games/populate", status_code=201)
def populate_games_endpoint(db: Session = Depends(get_db)):
    """
    Endpoint de única ejecución para poblar la base de datos con el
    catálogo de juegos definido en crud.py.
    """
    return crud.populate_games(db)

# --- ENDPOINT PARA OBTENER LISTA DE JUEGOS ---

@app.get("/games/", response_model=list[schemas.Game])
def read_games(skip: int = 0, limit: int = 100, db: Session = Depends(get_db), current_user: models.User = Depends(auth.get_current_user)):
    """
    Obtiene una lista de todos los juegos disponibles.
    Este es un endpoint protegido, requiere autenticación.
    """
    games = crud.get_games(db, skip=skip, limit=limit)
    return games

# --- ENDPOINT PARA SESIONES DE ENTRENAMIENTO ---

@app.post("/sessions/", response_model=schemas.Session, status_code=status.HTTP_201_CREATED)
def create_session_for_user(db: Session = Depends(get_db), current_user: models.User = Depends(auth.get_current_user)):
    """
    Inicia una nueva sesión de entrenamiento para el usuario autenticado.
    """
    return crud.create_user_session(db=db, user_id=current_user.id)

# --- ENDPOINT PARA RONDAS DE ENTRENAMIENTO ---

@app.post("/sessions/{session_id}/rounds/", response_model=schemas.Round, status_code=status.HTTP_201_CREATED)
def create_round_for_session(
    session_id: int, round_data: schemas.RoundCreate, db: Session = Depends(get_db), current_user: models.User = Depends(auth.get_current_user)
):
    """
    Crea una nueva ronda para una sesión específica del usuario autenticado.
    """
    # Aquí se oyede añadir una verificación para asegurar que la sesión pertenece al current_user
    return crud.create_session_round(db=db, round=round_data, session_id=session_id)


# --- ENDPOINT PARA PARTIDAS (GAMEPLAYS) ---

@app.post("/rounds/{round_id}/gameplays/", response_model=schemas.GamePlay, status_code=status.HTTP_201_CREATED)
def create_gameplay_for_round(
    round_id: int, gameplay_data: schemas.GamePlayCreate, db: Session = Depends(get_db), current_user: models.User = Depends(auth.get_current_user)
):
    """
    Inicia una nueva partida para una ronda específica.
    """
    # Aquí se debe verificar que la ronda pertenece a una sesión del usuario actual
    return crud.create_round_gameplay(db=db, gameplay=gameplay_data, round_id=round_id)

# --- ENDPOINT PARA ENSAYOS (TRIALS) ---

@app.post("/gameplays/{gameplay_id}/trials/", response_model=schemas.Trial, status_code=status.HTTP_201_CREATED)
def create_trial_for_gameplay(
    gameplay_id: int, trial_data: schemas.TrialCreate, db: Session = Depends(get_db), current_user: models.User = Depends(auth.get_current_user)
):
    """
    Registra un nuevo ensayo (intento) para una partida específica.
    """
    # Aquí podrías se debe añadir una verificación compleja para asegurar que el gameplay
    # pertenece al usuario actual a través de la ronda y la sesión.
    return crud.create_gameplay_trial(db=db, trial=trial_data, gameplay_id=gameplay_id)

# --- ENDPOINTS PARA LA LÓGICA DEL JUEGO ---

@app.post("/games/populate-words", status_code=201)
def populate_words_endpoint(db: Session = Depends(get_db)):
    """Endpoint para poblar la tabla de palabras iniciales."""
    return crud.populate_initial_words(db)

@app.post("/games/populate-levels", status_code=201)
def populate_levels_endpoint(db: Session = Depends(get_db)):
    """Endpoint de única ejecución para poblar los niveles del juego de oraciones."""
    return crud.populate_game_levels(db)

@app.get("/games/{game_id}/level/{level_number}", status_code=200)
def get_game_level_endpoint(game_id: int, level_number: int, db: Session = Depends(get_db), current_user: models.User = Depends(auth.get_current_user)):
    """Obtiene los datos para un nivel de juego específico, generando la oración dinámicamente."""
    level_config = crud.get_level_data(db, game_id=game_id, level_number=level_number)
    if not level_config:
        raise HTTPException(status_code=404, detail="Nivel no encontrado")
    
    # Genera la oración y los distractores basados en la configuración del nivel
    generated_data = crud.generate_sentence_for_level(db, level_config.level_data)
    
    return {
        "game_id": level_config.game_id,
        "level_number": level_config.level_number,
        "phase": level_config.phase,
        "level_data": generated_data # Los datos generados dinámicamente
    }



@app.post("/games/{game_id}/start-play", response_model=schemas.GamePlay)
def start_game_play_endpoint(
    game_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_user)
):
    """
    Prepara e inicia una nueva instancia de partida (GamePlay) para un juego.
    """
    return crud.start_new_gameplay(db=db, user_id=current_user.id, game_id=game_id)

@app.get("/gameplays/{gameplay_id}/data", status_code=200)
def get_gameplay_data_endpoint(
    gameplay_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_user)
):
    """
    Obtiene todos los datos necesarios para renderizar una partida.
    """
    db_gameplay = db.query(models.GamePlay).filter(models.GamePlay.id == gameplay_id).first()
    
    if not db_gameplay:
        raise HTTPException(status_code=404, detail="Partida no encontrada")

    # Lógica para determinar el nivel actual de la partida (por ahora, Nivel 1)
    current_level_number = 1 
    db_level = crud.get_level_data(db, game_id=db_gameplay.game_id, level_number=current_level_number)

    if not db_level:
        raise HTTPException(status_code=404, detail="Datos del nivel no encontrados")

    # <<< ESTA ES LA CORRECCIÓN IMPORTANTE >>>
    # Asegura que 'level_data' sea un objeto JSON, no un string
    parsed_level_data = db_level.level_data
    if isinstance(parsed_level_data, str):
        parsed_level_data = json.loads(parsed_level_data)

    # Genera la oración dinámicamente
    generated_data = crud.generate_sentence_for_level(db, parsed_level_data)

    return {
        "gameplay_id": db_gameplay.id,
        "game_id": db_gameplay.game_id,
        "level_number": db_level.level_number,
        "phase": db_level.phase,
        "level_data": generated_data # Devuelve los datos generados
    }
@app.put("/gameplays/{gameplay_id}/results-test")
def test_results_endpoint(gameplay_id: int):
    return {"message": "El endpoint de prueba SÍ funciona", "gameplay_id": gameplay_id}


@app.put("/gameplays/{gameplay_id}/results", response_model=schemas.GamePlay)
def save_gameplay_results(
    gameplay_id: int, # <-- Y aquí. Deben ser idénticos.
    results_data: schemas.GamePlayResultCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_user)
):
    """
    Guarda los resultados finales de una partida (score y métricas).
    """
    return crud.update_gameplay_results(db=db, gameplay_id=gameplay_id, results=results_data)

