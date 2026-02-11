# schemas.py
from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List, Dict, Any
from datetime import date, datetime

# --- Schemas para el Usuario ---

class UserBase(BaseModel):
    email: EmailStr

class UserCreate(UserBase):
    password: str = Field(min_length=8, max_length=72)
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    birth_date: Optional[date] = None
    country: Optional[str] = None
    gender: Optional[str] = None
    education_level: Optional[str] = None
    training_goals: Optional[str] = None

class User(UserBase):
    id: int
    is_active: bool
    is_premium: bool
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    
    class Config:
        orm_mode = True

# SCHEMAS PARA MÉTRICAS
class MetricBase(BaseModel):
    name: str
    display_name: str
    is_primary: bool
    unit: Optional[str] = None
    formula: Optional[str] = None
    description: Optional[str] = None

class MetricCreate(MetricBase):
    pass

class Metric(MetricBase):
    id: int
    
    class Config:
        orm_mode = True

# --- Schemas para el Juego ---

class GameBase(BaseModel):
    game_code: str
    name: str
    description: Optional[str] = None
    cognitive_domain: str
    # ELIMINAMOS primary_metric_name de aquí

class GameCreate(GameBase):
    # Ahora, para crear un juego, se debe pasar una lista de sus métricas
    metrics: List[MetricCreate]

class Game(GameBase):
    id: int
    # Cuando leamos un juego, vendrá con su lista de métricas
    metrics: List[Metric] = []

    class Config:
        orm_mode = True

# --- Schemas para el Ensayo (Trial) ---

class TrialBase(BaseModel):
    was_correct: bool
    reaction_time_ms: int

class TrialCreate(TrialBase):
    pass

class Trial(TrialBase):
    id: int
    game_play_id: int

    class Config:
        orm_mode = True

# --- Schemas para la Partida (GamePlay) ---

class GamePlayBase(BaseModel):
    game_id: int

class GamePlayCreate(GamePlayBase):
    pass

class GamePlay(GamePlayBase):
    id: int
    round_id: int
    score: int | None = None
    trials: List[Trial] = [] # <<< Lista de ensayos

    class Config:
        orm_mode = True

# <<< NUEVA CLASE AQUÍ >>>
class GamePlayResultCreate(BaseModel):
    score: int
    results_data: Dict[str, Any]

# --- Schemas para la Ronda (DEFINIDOS AHORA ANTES DE SESSION)---

class RoundBase(BaseModel):
    focus_domain: str | None = None

class RoundCreate(RoundBase):
    pass

class Round(RoundBase):
    id: int
    session_id: int
    round_number: int
    game_plays: List[GamePlay] = [] # <<<

    class Config:
        orm_mode = True

# --- Schemas para la Sesión ---

class SessionBase(BaseModel):
    pass

class SessionCreate(SessionBase):
    pass

class Session(SessionBase):
    id: int
    user_id: int
    start_time: datetime
    rounds: List[Round] = [] # Ahora 'Round' ya es un tipo conocido

    class Config:
        orm_mode = True


# Lector de Cosmos
class SentenceCheckRequest(BaseModel):
    user_sentence: str

class GamePlayResultUpdate(BaseModel):
    score: Optional[int] = None
    results_data: Optional[Dict[str, Any]] = None


# --- Tormenta de Palabras ---

class WordStormSubmitRequest(BaseModel):
    submitted_words: List[str]