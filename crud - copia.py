# crud.py
print("--- ¡CARGANDO LA VERSIÓN CORRECTA DE CRUD.PY! ---")

from sqlalchemy.orm import Session
from . import models, schemas
from passlib.context import CryptContext
import random
from sqlalchemy import func
from datetime import datetime

# --- Configuración de Seguridad para Contraseñas ---
# Le decimos a passlib que use el algoritmo bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# --- Funciones CRUD para el Usuario ---

def get_user_by_email(db: Session, email: str):
    """Busca y devuelve un usuario por su email."""
    return db.query(models.User).filter(models.User.email == email).first()

def create_user(db: Session, user: schemas.UserCreate):
    """Crea un nuevo usuario en la base de datos."""
    # 1. Hashear la contraseña que viene en el schema
    hashed_password = pwd_context.hash(user.password)
    
    # 2. Crear un objeto de modelo SQLAlchemy con los datos
    db_user = models.User(
        email=user.email,
        hashed_password=hashed_password,
        first_name=user.first_name,
        last_name=user.last_name,
        birth_date=user.birth_date,
        country=user.country,
        gender=user.gender,
        education_level=user.education_level,
        training_goals=user.training_goals
    )
    
    # 3. Añadir el objeto a la sesión de la base de datos
    db.add(db_user)
    
    # 4. Confirmar los cambios (guardar en la base de datos)
    db.commit()
    
    # 5. Refrescar el objeto para obtener los datos nuevos de la BD (como el id)
    db.refresh(db_user)

    return db_user
    
def verify_password(plain_password, hashed_password):
    """Verifica si una contraseña plana coincide con una hasheada."""
    return pwd_context.verify(plain_password, hashed_password)

def authenticate_user(db: Session, email: str, password: str):
    """
    Autentica a un usuario. Devuelve el usuario si las credenciales son válidas,
    de lo contrario devuelve False.
    """
    db_user = get_user_by_email(db, email=email)
    if not db_user:
        return False
    if not verify_password(password, db_user.hashed_password):
        return False
    return db_user

# --- FUNCIONES CRUD PARA JUEGOS ---
# --- CATÁLOGO DE JUEGOS ---

GAMES_CATALOG = [
    {"game_code": "MEM-01", 
     "name": "Matriz de memoria", 
     "description": "Memoriza la posición de los objetos en la matriz.", 
     "cognitive_domain": "Memoria", 
     "primary_metric_name": "indice_precision_neta"},
    {"game_code": "AT-02", "name": "Sigue la secuencia", "description": "Sigue la secuencia de luces ignorando los distractores.", "cognitive_domain": "Atención", "primary_metric_name": "percent_correct"},
    {"game_code": "MEM-01", "name": "Listas verbales", "description": "Recuerda tantas palabras como puedas de la lista.", "cognitive_domain": "Memoria", "primary_metric_name": "percent_correct"},
    {"game_code": "MEM-02", "name": "Forward memory span", "description": "Recuerda la secuencia de dígitos en orden.", "cognitive_domain": "Memoria", "primary_metric_name": "max_level"},
    {"game_code": "MEM-03", "name": "Reverse memory span", "description": "Recuerda la secuencia de dígitos en orden inverso.", "cognitive_domain": "Memoria", "primary_metric_name": "max_level"},
    {"game_code": "FX-01", "name": "Enfoque cambiante", "description": "Adapta tu respuesta cuando la regla del juego cambia.", "cognitive_domain": "Funciones Ejecutivas", "primary_metric_name": "efficiency_score"},
    {"game_code": "FX-02", "name": "Matrices progresivas", "description": "Encuentra la pieza que completa el patrón lógico.", "cognitive_domain": "Funciones Ejecutivas", "primary_metric_name": "percent_correct"},
    {"game_code": "FX-04", "name": "Dilema de Colores", "description": "Nombra el color de la tinta, no la palabra.", "cognitive_domain": "Funciones Ejecutivas", "primary_metric_name": "efficiency_score"},
    {"game_code": "VISO-06", "name": "Giro Espacial", "description": "Identifica la figura que ha sido rotada en el espacio.", "cognitive_domain": "Visoespacial", "primary_metric_name": "percent_correct"},
    {"game_code": "LANG-05", "name": "El Lector del Cosmos", "description": "Clasifica las palabras según la regla, ¡pero cuidado cuando la regla cambie!", "cognitive_domain": "Lenguaje", "primary_metric_name": "efficiency_score"}
]

def populate_games(db: Session):
    """
    Popula la tabla de juegos con el catálogo.
    No añade juegos que ya existen (basado en game_code).
    """
    games_created = []
    for game_data in GAMES_CATALOG:
        db_game = get_game_by_code(db, game_code=game_data["game_code"])
        if not db_game:
            game_schema = schemas.GameCreate(**game_data)
            created_game = create_game(db, game=game_schema)
            games_created.append(created_game.name)
    
    return {"message": "Catálogo de juegos actualizado.", "new_games_added": games_created}

def get_games(db: Session, skip: int = 0, limit: int = 100):
    """
    Devuelve una lista de todos los juegos del catálogo.
    """
    return db.query(models.Game).offset(skip).limit(limit).all()

def get_game_by_code(db: Session, game_code: str):
    """Busca un juego por su código."""
    return db.query(models.Game).filter(models.Game.game_code == game_code).first()

def create_game(db: Session, game: schemas.GameCreate):
    """Crea un nuevo juego en la base de datos."""
    db_game = models.Game(**game.dict())
    db.add(db_game)
    db.commit()
    db.refresh(db_game)
    return db_game


# --- FUNCIONES CRUD PARA LA JERARQUÍA DE JUEGO ---


def create_user_session(db: Session, user_id: int):
    """Crea una nueva sesión de entrenamiento para un usuario."""
    db_session = models.Session(user_id=user_id)
    db.add(db_session)
    db.commit()
    db.refresh(db_session)
    return db_session

# --- Funciones CRUD para la Ronda ---

def create_session_round(db: Session, round: schemas.RoundCreate, session_id: int):
    """Crea una nueva ronda dentro de una sesión existente."""
    # Calcula el número de la ronda automáticamente
    current_rounds_count = db.query(models.Round).filter(models.Round.session_id == session_id).count()
    
    db_round = models.Round(
        focus_domain=round.focus_domain,
        session_id=session_id,
        round_number=current_rounds_count + 1
    )
    db.add(db_round)
    db.commit()
    db.refresh(db_round)
    return db_round

# --- Funciones CRUD para la Partida (GamePlay) ---

'''def create_round_gameplay(db: Session, gameplay: schemas.GamePlayCreate, round_id: int):
    """Crea una nueva partida (gameplay) dentro de una ronda."""
    db_gameplay = models.GamePlay(
        **gameplay.dict(),
        round_id=round_id
    )
    db.add(db_gameplay)
    db.commit()
    db.refresh(db_gameplay)
    return db_gameplay'''


def create_round_gameplay(db: Session, gameplay: schemas.GamePlayCreate, round_id: int):
    """Crea una nueva partida (gameplay) dentro de una ronda."""
    db_gameplay = models.GamePlay(
        game_id=gameplay.game_id,
        round_id=round_id,
        current_level=1,   # <-- ¡IMPORTANTE!
        score=0,
        results_data={}
    )
    db.add(db_gameplay)
    db.commit()
    db.refresh(db_gameplay)
    return db_gameplay

# --- Funciones CRUD para el Ensayo (Trial) ---

def create_gameplay_trial(db: Session, trial: schemas.TrialCreate, gameplay_id: int):
    """Crea un nuevo ensayo para una partida específica."""
    current_trials_count = db.query(models.Trial).filter(models.Trial.game_play_id == gameplay_id).count()
    
    db_trial = models.Trial(
        **trial.dict(),
        game_play_id=gameplay_id,
        trial_number=current_trials_count + 1
    )
    db.add(db_trial)
    db.commit()
    db.refresh(db_trial)
    return db_trial


# --- DATOS PARA EL JUEGO "LECTOR DE COSMOS" ---
FORM_THE_SENTENCE_GAME_ID = 17 # Asegúrate de que este ID sea correcto para tu juego
TOTAL_LEVELS = 20
def _clamp_level(n: int) -> int:
    return max(1, min(TOTAL_LEVELS, int(n)))

# Ahora los niveles definen REGLAS, no oraciones fijas
SENTENCE_GAME_LEVELS = [
    # -------- FASE 1: BÁSICA (NIVELES 1–5) --------
    {
        "level_number": 1, "phase": "Básica",
        "phase_description": "Oraciones simples de 3–4 palabras. Pocas distractoras. Retroalimentación muy explícita (colores, sonidos).",
        "level_data": {
            "word_set": ["el", "gato", "duerme", "corre", "rojo", "la", "gatos"],
            "valid_sentences": [
                "el gato duerme",
                "el gato corre",
                "el gato rojo corre",
                "el gato rojo duerme"
            ]
        }
    },
    {
        "level_number": 2, "phase": "Básica",
        "phase_description": "Oraciones simples de 3–4 palabras. Pocas distractoras. Retroalimentación muy explícita (colores, sonidos).",
        "level_data": {
            "word_set": ["la", "niña", "es", "corre", "feliz", "alta"],
            "valid_sentences": [
                "la niña corre",
                "la niña es feliz",
                "la niña es alta"
            ]
        }
    },
    {
        "level_number": 3, "phase": "Básica",
        "phase_description": "Oraciones simples de 3–4 palabras. Pocas distractoras. Retroalimentación muy explícita (colores, sonidos).",
        "level_data": {
            "word_set": ["los", "perros", "grandes", "comen", "pan", "lento"],
            "valid_sentences": [
                "los perros comen pan",
                "los perros grandes comen",
                "los perros comen lento",
                "los perros grandes comen pan",
                "los perros grandes comen lento pan"
            ]
        }
    },
    {
        "level_number": 4, "phase": "Básica",
        "phase_description": "Oraciones simples de 3–4 palabras. Pocas distractoras. Retroalimentación muy explícita (colores, sonidos).",
        "level_data": {
            "word_set": ["mi", "mamá", "cocina", "sopa", "rica", "casa", "en"],
            "valid_sentences": [
                "mi mamá cocina sopa",
                "mi mamá cocina en casa",
                "mi mamá cocina sopa rica"
            ]
        }
    },
    {
        "level_number": 5, "phase": "Básica",
        "phase_description": "Oraciones simples de 3–4 palabras. Pocas distractoras. Retroalimentación muy explícita (colores, sonidos).",
        "level_data": {
            "word_set": ["el", "el", "sol", "brilla", "fuerte", "cielo", "en", "luna"],
            "valid_sentences": [
                "el sol brilla",
                "el sol brilla fuerte",
                "el sol brilla en el cielo"
            ]
        }
    },

    # -------- FASE 2: INTERMEDIA (NIVELES 6–10) --------
    {
        "level_number": 6, "phase": "Intermedia",
        "phase_description": "Oraciones de 5–7 palabras. Aumento de distractores (palabras irrelevantes). Introducción de categorías específicas (verbos, adjetivos). Tiempo límite ajustado.",
        "level_data": {
            "word_set": ["la", "maestra", "lee", "un", "libro", "interesante", "rápido", "banco"],
            "valid_sentences": [
                "la maestra lee un libro",
                "la maestra lee un libro interesante",
                "la maestra lee rápido"
            ]
        }
    },
    {
        "level_number": 7, "phase": "Intermedia",
        "phase_description": "Oraciones de 5–7 palabras. Aumento de distractores (palabras irrelevantes). Introducción de categorías específicas (verbos, adjetivos). Tiempo límite ajustado.",
        "level_data": {
            "word_set": ["el", "niño", "corre", "en", "el", "parque", "grande", "feliz", "nube"],
            "valid_sentences": [
                "el niño corre en el parque",
                "el niño corre feliz",
                "el niño corre en el parque grande"
            ]
        }
    },
    {
        "level_number": 8, "phase": "Intermedia",
        "phase_description": "Oraciones de 5–7 palabras. Aumento de distractores (palabras irrelevantes). Introducción de categorías específicas (verbos, adjetivos). Tiempo límite ajustado.",
        "level_data": {
            "word_set": ["los", "árboles", "altos", "se", "mueven", "con", "el", "viento", "piedra"],
            "valid_sentences": [
                "los árboles altos se mueven",
                "los árboles se mueven con el viento",
                "los árboles altos se mueven con el viento"
            ]
        }
    },
    {
        "level_number": 9, "phase": "Intermedia",
        "phase_description": "Oraciones de 5–7 palabras. Aumento de distractores (palabras irrelevantes). Introducción de categorías específicas (verbos, adjetivos). Tiempo límite ajustado.",
        "level_data": {
            "word_set": ["ella", "canta", "una", "canción", "alegre", "bonito", "tarde"],
            "valid_sentences": [
                "ella canta bonito",
                "ella canta una canción",
                "ella canta una canción alegre"
            ]
        }
    },
    {
        "level_number": 10, "phase": "Intermedia",
        "phase_description": "Oraciones de 5–7 palabras. Aumento de distractores (palabras irrelevantes). Introducción de categorías específicas (verbos, adjetivos). Tiempo límite ajustado.",
        "level_data": {
            "word_set": ["mi", "amigo", "estudia", "matemáticas", "en", "la", "universidad", "temprano"],
            "valid_sentences": [
                "mi amigo estudia matemáticas",
                "mi amigo estudia en la universidad"
            ]
        }
    },

    # -------- FASE 3: AVANZADA (NIVELES 11–15) --------
    {
        "level_number": 11, "phase": "Avanzada",
        "phase_description": "Oraciones complejas con conectores (“y”, “pero”, “aunque”). Palabras flotando en desorden espacial (más exploración VR). Necesidad de usar adjetivos/adverbios específicos. Penalización si se usan distractores.",
        "level_data": {
            "word_set": ["el", "científico", "descubre", "una", "estrella", "brillante", "y", "nueva", "roca"],
            "valid_sentences": [
                "el científico descubre una estrella",
                "el científico descubre una estrella brillante",
                "el científico descubre una estrella nueva"
            ]
        }
    },
    {
        "level_number": 12, "phase": "Avanzada",
        "phase_description": "Oraciones complejas con conectores (“y”, “pero”, “aunque”). Palabras flotando en desorden espacial (más exploración VR). Necesidad de usar adjetivos/adverbios específicos. Penalización si se usan distractores.",
        "level_data": {
            "word_set": ["los", "niños", "juegan", "mientras", "llueve", "en", "el", "parque", "ruido"],
            "valid_sentences": [
                "los niños juegan en el parque",
                "los niños juegan mientras llueve"
            ]
        }
    },
    {
        "level_number": 13, "phase": "Avanzada",
        "phase_description": "Oraciones complejas con conectores (“y”, “pero”, “aunque”). Palabras flotando en desorden espacial (más exploración VR). Necesidad de usar adjetivos/adverbios específicos. Penalización si se usan distractores.",
        "level_data": {
            "word_set": ["la", "mujer", "cocina", "un", "pastel", "delicioso", "de", "chocolate", "y"],
            "valid_sentences": [
                "la mujer cocina un pastel",
                "la mujer cocina un pastel delicioso",
                "la mujer cocina un pastel de chocolate"
            ]
        }
    },
    {
        "level_number": 14, "phase": "Avanzada",
        "phase_description": "Oraciones complejas con conectores (“y”, “pero”, “aunque”). Palabras flotando en desorden espacial (más exploración VR). Necesidad de usar adjetivos/adverbios específicos. Penalización si se usan distractores.",
        "level_data": {
            "word_set": ["ellos", "viajan", "a", "la", "ciudad", "grande", "en", "tren", "pero"],
            "valid_sentences": [
                "ellos viajan en tren",
                "ellos viajan a la ciudad grande",
                "ellos viajan a la ciudad"
            ]
        }
    },
    {
        "level_number": 15, "phase": "Avanzada",
        "phase_description": "Oraciones complejas con conectores (“y”, “pero”, “aunque”). Palabras flotando en desorden espacial (más exploración VR). Necesidad de usar adjetivos/adverbios específicos. Penalización si se usan distractores.",
        "level_data": {
            "word_set": ["la", "profesora", "explica", "un", "tema", "difícil", "matemático", "pero", "claro"],
            "valid_sentences": [
                "la profesora explica un tema",
                "la profesora explica un tema difícil",
                "la profesora explica un tema matemático"
            ]
        }
    },

    # -------- FASE 4: EXPERTA (NIVELES 16–20) --------
    {
        "level_number": 16, "phase": "Experta",
        "phase_description": "Oraciones subordinadas (ej. “Aunque estaba cansado, el niño corrió”). Mayor número de distractores. Tiempo muy reducido. Retroalimentación mínima (para fomentar autorregulación).",
        "level_data": {
            "word_set": ["el", "niño", "no", "quiere", "comer", "sus", "verduras", "aunque", "ahora"],
            "valid_sentences": [
                "el niño no quiere comer verduras",
                "el niño no quiere sus verduras",
                "aunque el niño no quiere verduras"
            ]
        }
    },
    {
        "level_number": 17, "phase": "Experta",
        "phase_description": "Oraciones subordinadas (ej. “Aunque estaba cansado, el niño corrió”). Mayor número de distractores. Tiempo muy reducido. Retroalimentación mínima (para fomentar autorregulación).",
        "level_data": {
            "word_set": ["ellos", "corren", "rápido", "y", "saltan", "alto", "porque", "noche"],
            "valid_sentences": [
                "ellos corren rápido",
                "ellos corren y saltan alto"
            ]
        }
    },
    {
        "level_number": 18, "phase": "Experta",
        "phase_description": "Oraciones subordinadas (ej. “Aunque estaba cansado, el niño corrió”). Mayor número de distractores. Tiempo muy reducido. Retroalimentación mínima (para fomentar autorregulación).",
        "level_data": {
            "word_set": ["ella", "escribe", "una", "carta", "larga", "bonita", "cuando", "puede"],
            "valid_sentences": [
                "ella escribe una carta",
                "ella escribe una carta larga",
                "ella escribe una carta bonita"
            ]
        }
    },
    {
        "level_number": 19, "phase": "Experta",
        "phase_description": "Oraciones subordinadas (ej. “Aunque estaba cansado, el niño corrió”). Mayor número de distractores. Tiempo muy reducido. Retroalimentación mínima (para fomentar autorregulación).",
        "level_data": {
            "word_set": ["el", "perro", "ladra", "pero", "el", "gato", "duerme", "si"],
            "valid_sentences": [
                "el perro ladra",
                "el perro ladra pero el gato duerme"
            ]
        }
    },
    {
        "level_number": 20, "phase": "Experta",
        "phase_description": "Oraciones subordinadas (ej. “Aunque estaba cansado, el niño corrió”). Mayor número de distractores. Tiempo muy reducido. Retroalimentación mínima (para fomentar autorregulación).",
        "level_data": {
            "word_set": ["aunque", "llueve", "ellos", "juegan", "felices", "en", "el", "campo", "siempre"],
            "valid_sentences": [
                "ellos juegan en el campo",
                "aunque llueve ellos juegan felices en el campo"
            ]
        }
    }
]


# Modificamos populate_game_levels para usar la nueva estructura
def populate_game_levels(db: Session):
    levels_created_count = 0
    for level_info in SENTENCE_GAME_LEVELS:
        db_level = db.query(models.GameLevel).filter_by(
            game_id=FORM_THE_SENTENCE_GAME_ID, level_number=level_info["level_number"]
        ).first()
        if not db_level:
            new_level = models.GameLevel(
                game_id=FORM_THE_SENTENCE_GAME_ID,
                level_number=level_info["level_number"],
                phase=level_info["phase"],
                level_data=level_info["level_data"] # Usa la nueva clave "data"
            )
            db.add(new_level)
            levels_created_count += 1
    db.commit()
    return {"message": "Niveles del juego (predefinidos) añadidos.", "new_levels_added": levels_created_count}

# get_level_data se mantiene igual
def get_level_data(db: Session, game_id: int, level_number: int):
    return db.query(models.GameLevel).filter_by(game_id=game_id, level_number=level_number).first()



def check_user_sentence(db: Session, gameplay_id: int, user_sentence: str):
    db_gameplay = db.query(models.GamePlay).filter(models.GamePlay.id == gameplay_id).first()
    if not db_gameplay:
        return None

    level_config = get_level_data(db, game_id=db_gameplay.game_id, level_number=db_gameplay.current_level)
    if not level_config:
        return None

    valid_sentences = level_config.level_data.get("valid_sentences", [])
    is_correct = user_sentence in valid_sentences

    return {"is_correct": is_correct}



# --- FUNCIONES CRUD PARA LOS NIVELES (se mantienen similares) ---



def start_new_gameplay(db: Session, user_id: int, game_id: int):
    """
    Prepara una nueva partida para un usuario.
    1. Busca una sesión activa de hoy o crea una nueva.
    2. Crea una nueva ronda en esa sesión.
    3. Crea la nueva partida (GamePlay) en esa ronda.
    """
    # Paso 1: Buscar o crear sesión
    today = datetime.utcnow().date()
    db_session = db.query(models.Session).filter(
        models.Session.user_id == user_id,
        func.date(models.Session.start_time) == today
    ).first()

    if not db_session:
        db_session = create_user_session(db, user_id=user_id)

    # Paso 2: Crear una nueva ronda
    round_schema = schemas.RoundCreate(focus_domain="General")
    db_round = create_session_round(db, round=round_schema, session_id=db_session.id)

    # Paso 3: Crear la nueva partida (GamePlay)
    gameplay_schema = schemas.GamePlayCreate(game_id=game_id)
    db_gameplay = create_round_gameplay(db, gameplay=gameplay_schema, round_id=db_round.id)

    return db_gameplay

def update_gameplay_results(db: Session, gameplay_id: int, results: schemas.GamePlayResultCreate):
    db_gameplay = db.query(models.GamePlay).filter(models.GamePlay.id == gameplay_id).first()
    if db_gameplay:
        db_gameplay.score = results.score
        db_gameplay.results_data = results.results_data
        db_gameplay.end_time = datetime.utcnow()
        db.commit()
        db.refresh(db_gameplay)
    return db_gameplay

# Avanzar en nivel en el juego Lector del Cosmos
def advance_to_next_level(db: Session, gameplay_id: int):
    db_gameplay = db.query(models.GamePlay).filter(models.GamePlay.id == gameplay_id).first()
    if db_gameplay:
        next_level = _clamp_level((db_gameplay.current_level or 1) + 1)
        db_gameplay.current_level = next_level
        db.commit(); db.refresh(db_gameplay)
    return db_gameplay

def regress_to_previous_level(db: Session, gameplay_id: int):
    db_gameplay = db.query(models.GamePlay).filter(models.GamePlay.id == gameplay_id).first()
    if db_gameplay:
        prev_level = _clamp_level((db_gameplay.current_level or 1) - 1)
        db_gameplay.current_level = prev_level
        db.commit(); db.refresh(db_gameplay)
    return db_gameplay
