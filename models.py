# models.py
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Date, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database import Base
from sqlalchemy.dialects.postgresql import JSONB

class User(Base):
    __tablename__ = "users"
    # ... (todos los campos de User que ya definimos)
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    first_name = Column(String, nullable=True)
    last_name = Column(String, nullable=True)
    birth_date = Column(Date, nullable=True)
    country = Column(String, nullable=True)
    gender = Column(String, nullable=True)
    education_level = Column(String, nullable=True)
    is_active = Column(Boolean, default=True)
    is_premium = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    last_login = Column(DateTime(timezone=True), onupdate=func.now())
    training_goals = Column(String, nullable=True)
    preferred_training_days = Column(String, nullable=True)
    sessions = relationship("Session", back_populates="user")

#class Game(Base):
 #   __tablename__ = "games"
  #  id = Column(Integer, primary_key=True)
   # game_code = Column(String, unique=True, nullable=False) # Ej: "AT-01", "MEM-04"
    #name = Column(String, unique=True, nullable=False)
   # description = Column(String)
    #cognitive_domain = Column(String)
    # NUEVO: Campo para saber qué métrica es la principal para este juego
    #primary_metric_name = Column(String, nullable=False) # Ej: "percent_correct", "avg_latency_ms", "max_level"
    #game_plays = relationship("GamePlay", back_populates="game")

class Game(Base):
    __tablename__ = "games"
    id = Column(Integer, primary_key=True)
    game_code = Column(String, unique=True, nullable=False)
    name = Column(String, unique=True, nullable=False)
    description = Column(Text) # Usar Text para descripciones largas
    cognitive_domain = Column(String)
    
    # 1. ELIMINAMOS primary_metric_name DE AQUÍ
    
    # 2. AÑADIMOS LA RELACIÓN: Un juego tiene muchas métricas.
    #    cascade="all, delete-orphan" significa que si borras un juego, sus métricas se borran automáticamente.
    metrics = relationship("Metric", back_populates="game", cascade="all, delete-orphan")
    
    # Las otras relaciones se quedan igual
    game_plays = relationship("GamePlay", back_populates="game")

# 3. CREAMOS EL NUEVO MODELO PARA LAS MÉTRICAS
class Metric(Base):
    __tablename__ = "metrics"
    
    id = Column(Integer, primary_key=True)
    name = Column(String, index=True, nullable=False) # ej: "indice_precision_neta"
    display_name = Column(String, nullable=False) # ej: "Índice de Precisión Neta"
    is_primary = Column(Boolean, default=False, nullable=False)
    unit = Column(String, nullable=True) # ej: "%", "ms", "recuento"
    formula = Column(Text, nullable=True)
    description = Column(Text, nullable=True)
    
    # La clave foránea que conecta esta tabla con la de juegos
    game_id = Column(Integer, ForeignKey("games.id"))
    
    # La relación inversa para poder acceder al juego desde una métrica
    game = relationship("Game", back_populates="metrics")


class Session(Base):
    __tablename__ = "sessions"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    start_time = Column(DateTime(timezone=True), server_default=func.now())
    end_time = Column(DateTime(timezone=True), nullable=True)
    user = relationship("User", back_populates="sessions")
    rounds = relationship("Round", back_populates="session")

class Round(Base):
    __tablename__ = "rounds"
    id = Column(Integer, primary_key=True)
    session_id = Column(Integer, ForeignKey("sessions.id"))
    round_number = Column(Integer)
    focus_domain = Column(String, nullable=True)
    session = relationship("Session", back_populates="rounds")
    game_plays = relationship("GamePlay", back_populates="round")

#class GamePlay(Base):
 #   __tablename__ = "game_plays"
  #  id = Column(Integer, primary_key=True)
   # round_id = Column(Integer, ForeignKey("rounds.id"))
    #game_id = Column(Integer, ForeignKey("games.id"))
    #start_time = Column(DateTime(timezone=True), server_default=func.now())
    #end_time = Column(DateTime(timezone=True), nullable=True)
    
    # --- CAMPOS NUEVOS PARA GUARDAR LAS MÉTRICAS CALCULADAS ---
    #score = Column(Integer, nullable=True) # Una puntuación general si aplica
    #percent_correct = Column(Float, nullable=True) # Para métricas de % de aciertos
    #avg_latency_ms = Column(Float, nullable=True) # Para métricas de latencia media
    #max_level = Column(Integer, nullable=True) # Para juegos tipo "span" o de niveles
    #efficiency_score = Column(Float, nullable=True) # Para métricas como "Costo de Cambio" o "Torres del Saber"
    
    #round = relationship("Round", back_populates="game_plays")
    #trials = relationship("Trial", back_populates="game_play")

# models.py

class GamePlay(Base):
    __tablename__ = "game_plays"

    id = Column(Integer, primary_key=True)
    round_id = Column(Integer, ForeignKey("rounds.id"), nullable=False)
    game_id = Column(Integer, ForeignKey("games.id"), nullable=False)
    current_level = Column(Integer, default=1, nullable=False)
    score = Column(Integer, nullable=True)
    results_data = Column(JSONB, nullable=True)
    start_time = Column(DateTime(timezone=True), server_default=func.now())
    end_time = Column(DateTime(timezone=True), nullable=True)

    round = relationship("Round", back_populates="game_plays")
    trials = relationship("Trial", back_populates="game_play")
    game = relationship("Game", back_populates="game_plays")

class Trial(Base):
    __tablename__ = "trials"
    id = Column(Integer, primary_key=True)
    game_play_id = Column(Integer, ForeignKey("game_plays.id"))
    trial_number = Column(Integer)
    was_correct = Column(Boolean)
    reaction_time_ms = Column(Integer)
    game_play = relationship("GamePlay", back_populates="trials")

# Las base de datos de las palabras
class Word(Base):
    __tablename__ = "words"

    id = Column(Integer, primary_key=True)
    text = Column(String, unique=True, nullable=False)
    category = Column(String, nullable=False) # 'sustantivo', 'verbo', etc.

    # <<< AÑADE ESTAS DOS LÍNEAS >>>
    gender = Column(String, nullable=True) # 'masculino', 'femenino'
    number = Column(String, default='singular', nullable=False) # 'singular', 'plural'

    lang = Column(String, default="es")
    
class GameLevel(Base):
    __tablename__ = "game_levels"

    id = Column(Integer, primary_key=True)
    game_id = Column(Integer, ForeignKey("games.id"))
    level_number = Column(Integer, nullable=False)
    phase = Column(String, nullable=False) # Básica, Intermedia, Avanzada, Experta
    
    # Aquí definimos las reglas para generar la oración, no la oración en sí
    level_data = Column(JSONB) # Ej: {"sentence_structure": ["pronombre", "verbo", "sustantivo"], "distractor_count": 2, "category_rules": ["adjetivo"]}