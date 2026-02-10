# tormenta_de_palabras.py

"""
Este archivo contiene la lógica y los datos específicos para el juego
"Tormenta de Palabras" (Game ID: 16, Game Code: LEN-04).
"""

# --- Constantes de Configuración del Juego ---
GAME_ID = 16
GAME_CODE = "LEN-04"
TOTAL_LEVELS = 10 # Para este ejemplo, definiremos 10 niveles

# --- Definición de Niveles para Tormenta de Palabras ---
# Cada nivel se define por una letra, un tiempo límite y una lista de palabras válidas.
# En una aplicación real, esta lista de palabras podría ser mucho más extensa.
WORD_STORM_LEVELS = [
    # --- Fase 1: Letras Comunes ---
    {
        "level_number": 1, "phase": "Letras Comunes - Fácil",
        "level_data": {
            "letter": "P",
            "time_limit_seconds": 60,
            "valid_words": [
                "pera", "pato", "pelo", "piso", "pan", "papa", "paso", "pino",
                "polo", "pala", "pila", "pomo", "pozo", "puerta", "pueblo"
            ]
        }
    },
    {
        "level_number": 2, "phase": "Letras Comunes - Fácil",
        "level_data": {
            "letter": "M",
            "time_limit_seconds": 60,
            "valid_words": [
                "mano", "mesa", "mapa", "meta", "mimo", "mora", "muro", "musa",
                "mono", "mota", "miel", "mito", "mina", "malla", "mundo"
            ]
        }
    },
    # --- Fase 2: Aumento de Dificultad ---
    {
        "level_number": 3, "phase": "Letras Comunes - Intermedio",
        "level_data": {
            "letter": "C",
            "time_limit_seconds": 50, # Menor tiempo
            "valid_words": [
                "casa", "carro", "cama", "copa", "cono", "cielo", "cine", "cuna",
                "codo", "cola", "caja", "calle", "campo", "carta", "coro"
            ]
        }
    },
    {
        "level_number": 4, "phase": "Letras Comunes - Intermedio",
        "level_data": {
            "letter": "A",
            "time_limit_seconds": 50,
            "valid_words": [
                "amor", "alma", "arte", "agua", "aire", "anillo", "arco", "alto",
                "azul", "ala", "ave", "arbol", "arena", "avena", "autor"
            ]
        }
    },
    # --- Fase 3: Letras Menos Frecuentes ---
    {
        "level_number": 5, "phase": "Letras Infrecuentes - Difícil",
        "level_data": {
            "letter": "F",
            "time_limit_seconds": 45,
            "valid_words": [
                "foco", "fama", "fila", "fino", "frio", "fuego", "flor", "fruta",
                "faro", "foca", "falda", "fiesta", "fauna", "feliz", "fondo"
            ]
        }
    },
    # (Se pueden añadir más niveles hasta llegar a TOTAL_LEVELS)
]

def process_word_storm_results(submitted_words: list[str], level_data: dict):
    """
    Procesa y califica las palabras enviadas por el usuario para un nivel.

    Args:
        submitted_words: La lista de palabras que el usuario introdujo.
        level_data: La configuración del nivel actual (incluye la lista de palabras válidas).

    Returns:
        Un diccionario con las métricas de rendimiento.
    """
    valid_words_set = set(level_data.get("valid_words", []))
    time_limit = level_data.get("time_limit_seconds", 60)
    
    # 1. Normalizar las palabras del usuario (minúsculas y sin espacios)
    normalized_user_words = [word.lower().strip() for word in submitted_words]
    
    # 2. Calcular errores de perseveración (palabras repetidas por el usuario)
    # Cuenta cuántas veces aparece cada palabra y resta 1 para obtener las repeticiones.
    perseveration_errors = len(normalized_user_words) - len(set(normalized_user_words))
    
    # 3. Identificar palabras únicas enviadas por el usuario
    unique_user_words = set(normalized_user_words)
    
    # 4. Encontrar las palabras correctas
    correct_words = unique_user_words.intersection(valid_words_set)
    
    # 5. Calcular errores de intrusión (palabras que no son válidas)
    intrusion_errors = len(unique_user_words - valid_words_set)
    
    # 6. Calcular el puntaje principal
    total_score = len(correct_words)
    
    # 7. Calcular la tasa de producción léxica (palabras por minuto)
    time_in_minutes = time_limit / 60.0
    lexical_production_rate = total_score / time_in_minutes if time_in_minutes > 0 else 0
    
    return {
        "total_score": total_score,
        "total_words_submitted": len(normalized_user_words),
        "unique_words_submitted": len(unique_user_words),
        "correct_words": list(correct_words),
        "perseveration_errors": perseveration_errors,
        "intrusion_errors": intrusion_errors,
        "lexical_production_rate": round(lexical_production_rate, 2), # Palabras por minuto
        "level_letter": level_data.get("letter")
    }