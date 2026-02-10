# crud.py
print("--- ¡CARGANDO LA VERSIÓN CORRECTA DE CRUD.PY! ---")

from sqlalchemy.orm import Session
from . import models, schemas
from passlib.context import CryptContext
import random
from sqlalchemy import func
from datetime import datetime

from . import tormenta_de_palabras 

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

GAMES_CATALOG_NEW = [
    {
        "game_code": "MEM-01",
        "name": "Matriz de memoria",
        "description": "Memoriza la posición de los objetos en la matriz.",
        "cognitive_domain": "Memoria",
        "metrics": [
            {
                "name": "span_visoespacial_max",
                "display_name": "Amplitud Visoespacial Máxima",
                "is_primary": True,
                "unit": "recuento",
                "description": "Mayor número de celdas reproducidas correctamente en un tablero sin error."
            },
            {
                "name": "tasa_aciertos",
                "display_name": "Tasa de Aciertos",
                "is_primary": True,
                "unit": "%",
                "description": "Proporción de aciertos respecto al total de objetivos presentados."
            },
            {
                "name": "tiempo_respuesta_promedio_ms",
                "display_name": "Tiempo de Respuesta",
                "is_primary": False,
                "unit": "ms",
                "description": "Tiempo promedio por tablero."
            },
            {
                "name": "errores_comision",
                "display_name": "Errores de Comisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Selecciones incorrectas."
            },
            {
                "name": "errores_omision",
                "display_name": "Errores de Omisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Objetivos no seleccionados."
            },
            {
                "name": "estabilidad_desempeno",
                "display_name": "Estabilidad del Desempeño",
                "is_primary": False,
                "unit": "índice",
                "description": "Variabilidad del desempeño entre tableros."
            }
        ]
    },
    {
    "game_code": "MEM-02",
    "name": "Sigue la secuencia",
    "description": "Sigue la secuencia de luces ignorando los distractores.",
    "cognitive_domain": "Memoria",
    "metrics": [
            {
                "name": "max_digit_span",
                "display_name": "Amplitud máxima de dígitos",
                "is_primary": True,
                "unit": "recuento",
                "description": "Longitud máxima de la secuencia reproducida correctamente."
            },
            {
                "name": "percentage_correct_sequences",
                "display_name": "Porcentaje de secuencias correctas",
                "is_primary": True,
                "unit": "porcentaje",
                "description": "Porcentaje de secuencias reproducidas correctamente respecto al total."
            },
            {
                "name": "response_time",
                "display_name": "Tiempo de respuesta",
                "is_primary": False,
                "unit": "ms",
                "description": "Tiempo promedio de respuesta durante la reproducción de la secuencia."
            },
            {
                "name": "order_errors",
                "display_name": "Errores de orden",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de errores por reproducción en orden incorrecto."
            },
            {
                "name": "omission_errors",
                "display_name": "Errores de omisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de elementos omitidos durante la reproducción de la secuencia."
            }
        ]
    },
    {
        "game_code": "MEM-03",
        "name": "Recuerda los objetos",
        "description": "Identifica objetos y reproduce su secuencia, ignorando los distractores.",
        "cognitive_domain": "Memoria y Memoria de Trabajo",
        "metrics": [
            {
                "name": "max_object_span",
                "display_name": "Amplitud Máxima de Objetos (Span)",
                "is_primary": True,
                "unit": "recuento",
                "description": "Número máximo de objetos recordados correctamente en una secuencia."
            },
            {
                "name": "secuencias_correctas_pct",
                "display_name": "Porcentaje de Secuencias Correctas",
                "is_primary": True,
                "unit": "%",
                "description": "Proporción de secuencias completadas correctamente."
            },
            {
                "name": "errores_comision",
                "display_name": "Errores de Comisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Selección de objetos distractores."
            },
            {
                "name": "errores_orden",
                "display_name": "Errores de Orden",
                "is_primary": False,
                "unit": "recuento",
                "description": "Objetos correctos seleccionados en orden incorrecto."
            },
            {
                "name": "errores_omision",
                "display_name": "Errores de Omisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Secuencias no completadas."
            },
            {
                "name": "tiempo_respuesta_promedio_ms",
                "display_name": "Tiempo de Respuesta",
                "is_primary": False,
                "unit": "ms",
                "description": "Tiempo medio por selección."
            }
        ]
    },
    {
        "game_code": "MEM-04",
        "name": "Caja de recuerdos",
        "description": "Memoriza una lista de 12 palabras, repetida 3 veces, y selecciona las que recuerdes.",
        "cognitive_domain": "Memoria",
        "metrics": [
            {
                "name": "total_palabras_recordadas_ronda_final",
                "display_name": "Total de Palabras Recordadas (Ronda 3)",
                "is_primary": True,
                "unit": "recuento",
                "description": "Número de palabras objetivo correctamente recordadas en la tercera ronda, indicador principal del aprendizaje verbal consolidado."
            },
            {
                "name": "porcentaje_recuerdo_ronda_final",
                "display_name": "Porcentaje de Recuerdo Correcto (Ronda 3)",
                "is_primary": True,
                "unit": "%",
                "description": "Proporción de palabras correctamente recordadas en la tercera ronda respecto al total de palabras presentadas."
            },
            {
                "name": "errores_omision",
                "display_name": "Errores de Omisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de palabras objetivo no recuperadas en la tercera ronda; refleja fallos de consolidación o evocación."
            },
            {
                "name": "errores_comision",
                "display_name": "Errores de Comisión (Intrusiones)",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de palabras distractoras seleccionadas que no pertenecían a la lista objetivo."
            },
            {
                "name": "tasa_aprendizaje_e3_e1",
                "display_name": "Tasa de Aprendizaje entre Rondas (E3 − E1)",
                "is_primary": False,
                "unit": "recuento",
                "description": "Incremento en el número de palabras correctamente recordadas entre la primera y la tercera ronda."
            }
        ]
    },
    {
        "game_code": "MEM-05",
        "name": "Deja vú",
        "description": "Responde 'sí' o 'no' para discriminar entre figuras vistas y nuevos distractores.",
        "cognitive_domain": "Memoria",
        "metrics": [
            {
                "name": "precision_reconocimiento_pct",
                "display_name": "Precisión de Reconocimiento",
                "is_primary": True,
                "unit": "%",
                "description": "Porcentaje total de juicios correctos durante la tarea de reconocimiento visual."
            },
            {
                "name": "tiempo_reaccion_promedio_ms",
                "display_name": "Tiempo Medio de Respuesta",
                "is_primary": True,
                "unit": "ms",
                "description": "Tiempo promedio empleado para emitir una respuesta durante la fase de reconocimiento."
            },
            {
                "name": "errores_comision_falsas_alarmas",
                "display_name": "Errores de Comisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de veces que se respondió 'sí' ante un estímulo distractor no presentado previamente."
            },
            {
                "name": "errores_omision_misses",
                "display_name": "Errores de Omisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de veces que se respondió 'no' ante un estímulo que sí pertenecía a la secuencia original."
            }
        ]
    },
    {
        "game_code": "MEM-06",
        "name": "Ruta de luces",
        "description": "Haz clic en los círculos en el mismo orden en que fueron iluminados.",
        "cognitive_domain": "Memoria y Memoria de Trabajo",
        "metrics": [
            {
                "name": "amplitud_visoespacial_span",
                "display_name": "Amplitud Visoespacial (Span)",
                "is_primary": True,
                "unit": "recuento",
                "description": "La longitud de la secuencia más larga replicada correctamente."
            },
            {
                "name": "nivel_maximo_alcanzado",
                "display_name": "Nivel Máximo Alcanzado",
                "is_primary": False,
                "unit": "recuento",
                "description": "El nivel de dificultad más alto al que llegó el jugador."
            },
            {
                "name": "total_ensayos_correctos",
                "display_name": "Total de Ensayos Correctos",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de secuencias completadas con éxito."
            },
            {
                "name": "errores_orden",
                "display_name": "Errores de Orden",
                "is_primary": False,
                "unit": "recuento",
                "description": "Seleccionar los círculos correctos pero en la secuencia equivocada."
            },
            {
                "name": "errores_ubicacion",
                "display_name": "Errores de Ubicación",
                "is_primary": False,
                "unit": "recuento",
                "description": "Seleccionar un círculo que no formaba parte de la secuencia."
            },
            {
                "name": "tiempo_respuesta_promedio_ms",
                "display_name": "Tiempo de Respuesta Promedio",
                "is_primary": False,
                "unit": "ms",
                "description": "Tiempo promedio de respuesta por secuencia."
            }
        ]
    },
    {
        "game_code": "MEM-07",
        "name": "Ruta de colores al revés",
        "description": "Reproduce la secuencia de círculos en el orden inverso al mostrado.",
        "cognitive_domain": "Memoria y Funciones Ejecutivas",
        "metrics": [
            {
            "name": "amplitud_inversa_maxima",
            "display_name": "Amplitud Inversa Máxima",
            "is_primary": True,
            "unit": "count",
            "description": "Longitud máxima de la secuencia reproducida correctamente en orden inverso."
            },
            {
            "name": "porcentaje_secuencias_inversas_correctas",
            "display_name": "Porcentaje de Secuencias Inversas Correctas",
            "is_primary": True,
            "unit": "percentage",
            "description": "Proporción de secuencias inversas reproducidas correctamente respecto al total de intentos."
            },
            {
            "name": "errores_orden",
            "display_name": "Errores de Orden",
            "is_primary": False,
            "unit": "count",
            "description": "Errores en los que los estímulos correctos fueron seleccionados pero en un orden inverso incorrecto."
            },
            {
            "name": "errores_omision",
            "display_name": "Errores de Omisión",
            "is_primary": False,
            "unit": "count",
            "description": "Fallo al seleccionar uno o más estímulos que sí pertenecían a la secuencia."
            },
            {
            "name": "tiempo_total_respuesta_ms",
            "display_name": "Tiempo Total de Respuesta",
            "is_primary": False,
            "unit": "ms",
            "description": "Tiempo total empleado para completar todas las secuencias del juego."
            }
        ]
    },
    {
         "game_code": "AT-01",
         "name": "Concéntrate en el objetivo",
         "description": "Identifica y responde correctamente al estímulo objetivo entre distractores, bajo restricciones temporales.",
         "cognitive_domain": "Atención",
         "metrics": [
            {
            "name": "porcentaje_respuestas_correctas",
            "display_name": "Porcentaje de respuestas correctas al estímulo objetivo",
            "is_primary": True,
            "unit": "%",
            "description": "Porcentaje de respuestas correctas sobre el total de estímulos objetivo."
            },
            {
            "name": "tiempo_medio_respuesta_correcta_ms",
            "display_name": "Tiempo medio de respuesta correcta",
            "is_primary": True,
            "unit": "ms",
            "description": "Tiempo promedio de respuesta considerando únicamente los ensayos correctos."
            },
            {
            "name": "errores_comision",
            "display_name": "Errores de comisión",
            "is_primary": False,
            "unit": "recuento",
            "description": "Respuestas realizadas sobre estímulos distractores."
            },
            {
            "name": "errores_omision",
            "display_name": "Errores de omisión",
            "is_primary": False,
            "unit": "recuento",
            "description": "Estímulos objetivo a los que no se respondió."
            },
            {
            "name": "variabilidad_tiempo_respuesta_ms",
            "display_name": "Variabilidad del tiempo de respuesta",
            "is_primary": False,
            "unit": "ms",
            "description": "Desviación estándar del tiempo de respuesta."
            }
        ]
    },
    {
        "game_code": "AT-03",
        "name": "Enfoca la Flecha",
        "description": "Usa el teclado para seleccionar la dirección a la que apuntan los objetos, ignorando distractores.",
        "cognitive_domain": "Atención",
        "metrics": [
            {
                "name": "indice_eficiencia_busqueda_ms",
                "display_name": "Índice de Eficiencia de Búsqueda",
                "is_primary": True,
                "unit": "ms",
                "description": "Mide la eficiencia combinando velocidad y precisión (TR promedio / Proporción de Aciertos)."
            },
            {
                "name": "total_aciertos",
                "display_name": "Total de Aciertos",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número total de respuestas correctas."
            },
            {
                "name": "porcentaje_precision_pct",
                "display_name": "Porcentaje de Precisión",
                "is_primary": False,
                "unit": "%",
                "description": "Porcentaje de aciertos del total de estímulos."
            },
            {
                "name": "total_errores",
                "display_name": "Total de Errores",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número total de respuestas incorrectas."
            },
            {
                "name": "tiempo_respuesta_promedio_ms",
                "display_name": "Tiempo de Respuesta Promedio",
                "is_primary": False,
                "unit": "ms",
                "description": "Tiempo promedio para las respuestas correctas."
            },
            {
                "name": "tiempo_recuperacion_error_ms",
                "display_name": "Tiempo de Recuperación del Error",
                "is_primary": False,
                "unit": "ms",
                "description": "Tiempo extra (TRpost-error - TRpost-acierto) después de un fallo."
            }
        ]
    },
    {
        "game_code": "AT-02",
        "name": "Cazador de burbujas",
        "description": "Identifica y selecciona objetivos en movimiento que se mezclan con distractores visualmente similares.",
        "cognitive_domain": "Atención",
        "metrics": [
            {
                "name": "indice_precision_rastreo_pct",
                "display_name": "Precisión de Rastreo",
                "is_primary": True,
                "unit": "%",
                "description": "Porcentaje de objetivos correctamente identificados respecto al total de objetivos presentados."
            },
            {
                "name": "tr_promedio_correctos_ms",
                "display_name": "Tiempo de Respuesta Correcta",
                "is_primary": True,
                "unit": "ms",
                "description": "Tiempo promedio de respuesta en selecciones correctas de los objetivos."
            },
            {
                "name": "errores_comision",
                "display_name": "Errores de Comisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de veces que el participante selecciona un distractor en lugar de un objetivo."
            },
            {
                "name": "errores_omision",
                "display_name": "Errores de Omisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de objetivos que no fueron seleccionados al finalizar el movimiento."
            },
            {
                "name": "variabilidad_tr_ms",
                "display_name": "Variabilidad del Tiempo de Respuesta",
                "is_primary": False,
                "unit": "ms",
                "description": "Desviación estándar del tiempo de respuesta en las selecciones correctas."
            }
        ]
    },
    {
    "game_code": "AT-03",
    "name": "Enfoca la Flecha",
    "description": "Identifica la dirección correcta de estímulos visuales que apuntan en distintas direcciones, discriminando entre estímulos relevantes y distractores bajo presión temporal.",
    "cognitive_domain": "Atención",
    "metrics": [
        {
        "name": "porcentaje_respuestas_correctas_direccion",
        "display_name": "Porcentaje de Respuestas Correctas Direccionales",
        "is_primary": True,
        "unit": "%",
        "description": "Porcentaje de estímulos cuya dirección fue identificada correctamente respecto al total de estímulos presentados."
        },
        {
        "name": "tiempo_medio_respuesta_correcta_ms",
        "display_name": "Tiempo Medio de Respuesta Correcta",
        "is_primary": True,
        "unit": "ms",
        "description": "Tiempo promedio empleado para responder correctamente a la dirección del estímulo."
        },
        {
        "name": "errores_comision",
        "display_name": "Errores de Comisión",
        "is_primary": False,
        "unit": "recuento",
        "description": "Número de veces que el participante responde a una dirección incorrecta ante un estímulo presentado."
        },
        {
        "name": "errores_omision",
        "display_name": "Errores de Omisión",
        "is_primary": False,
        "unit": "recuento",
        "description": "Número de estímulos ante los cuales el participante no emite respuesta dentro del tiempo disponible."
        },
        {
        "name": "variabilidad_tiempo_respuesta_ms",
        "display_name": "Variabilidad del Tiempo de Respuesta",
        "is_primary": False,
        "unit": "ms",
        "description": "Desviación estándar del tiempo de respuesta en las respuestas correctas."
        }
    ]
    },
    {
        "game_code": "AT-04",
        "name": "No te despistes",
        "description": "Indica la ubicación de un estímulo reaccionando a señales válidas e inválidas, evaluando la eficiencia de la reorientación atencional.",
        "cognitive_domain": "Atención",
        "metrics": [
            {
            "name": "tr_promedio_validos_ms",
            "display_name": "Tiempo de Reacción en Ensayos Válidos",
            "is_primary": True,
            "unit": "ms",
            "description": "Tiempo medio de reacción cuando el estímulo aparece en la ubicación señalada."
            },
            {
            "name": "costo_reorientacion_ms",
            "display_name": "Costo de Reorientación Atencional",
            "is_primary": True,
            "unit": "ms",
            "description": "Diferencia entre el tiempo de reacción en ensayos inválidos y válidos."
            },
            {
            "name": "errores_comision",
            "display_name": "Errores de Comisión",
            "is_primary": False,
            "unit": "recuento",
            "description": "Respuestas emitidas ante una localización incorrecta del estímulo."
            },
            {
            "name": "errores_omision",
            "display_name": "Errores de Omisión",
            "is_primary": False,
            "unit": "recuento",
            "description": "Falta de respuesta ante la aparición del estímulo objetivo."
            },
            {
            "name": "variabilidad_tr_ms",
            "display_name": "Variabilidad del Tiempo de Reacción",
            "is_primary": False,
            "unit": "ms",
            "description": "Desviación estándar del tiempo de reacción, indicador de estabilidad atencional."
            }
        ]
    },
    {
    "game_code": "AT-05",
    "name": "Safari Fotográfico",
    "description": "Haz clic para fotografiar a los patos (Go) e inhibe la respuesta ante otros animales (No-Go).",
    "cognitive_domain": "Atención y Funciones Ejecutivas",
    "metrics": [
        {
        "name": "porcentaje_aciertos_go_pct",
        "display_name": "Porcentaje de Aciertos (Go)",
        "is_primary": True,
        "unit": "%",
        "description": "Porcentaje de estímulos Go correctamente respondidos; refleja atención sostenida y detección eficiente de objetivos."
        },
        {
        "name": "errores_comision_nogo",
        "display_name": "Errores de Comisión",
        "is_primary": True,
        "unit": "recuento",
        "description": "Número de respuestas emitidas incorrectamente ante estímulos No-Go; indicador directo de fallos en el control inhibitorio."
        },
        {
        "name": "errores_omision_go",
        "display_name": "Errores de Omisión",
        "is_primary": False,
        "unit": "recuento",
        "description": "Número de estímulos Go ante los cuales no se emitió respuesta; refleja lapsos atencionales."
        },
        {
        "name": "tiempo_reaccion_medio_ms",
        "display_name": "Tiempo Medio de Reacción",
        "is_primary": False,
        "unit": "ms",
        "description": "Tiempo promedio de respuesta en ensayos Go correctos; refleja velocidad de procesamiento bajo demanda atencional."
        },
        {
        "name": "variabilidad_tiempo_reaccion_ms",
        "display_name": "Variabilidad del Tiempo de Reacción",
        "is_primary": False,
        "unit": "ms",
        "description": "Desviación estándar del tiempo de reacción en ensayos Go; indica estabilidad y consistencia del procesamiento cognitivo."
        }
    ]
    },
    {
        "game_code": "LEN-01",
        "name": "Sopa de letras",
        "description": "Localiza palabras objetivo ocultas en una cuadrícula de letras bajo demandas de exploración visual y atención selectiva.",
        "cognitive_domain": "Lenguaje, Habilidades Visoespaciales y Atención",
        "metrics": [
            {
                "name": "indice_precision_lexica_pct",
                "display_name": "Índice de Precisión Léxica",
                "is_primary": True,
                "unit": "%",
                "description": "Proporción de palabras objetivo correctamente identificadas respecto al total presentado."
            },
            {
                "name": "tiempo_medio_localizacion_s",
                "display_name": "Tiempo Medio de Localización",
                "is_primary": False,
                "unit": "s",
                "description": "Tiempo promedio requerido para localizar correctamente cada palabra objetivo."
            },
            {
                "name": "errores_comision",
                "display_name": "Errores de Comisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de selecciones incorrectas sobre letras o secuencias no objetivo."
            },
            {
                "name": "errores_omision",
                "display_name": "Errores de Omisión",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de palabras objetivo no localizadas al finalizar la tarea."
            },
            {
                "name": "uso_pistas",
                "display_name": "Uso de Pistas",
                "is_primary": False,
                "unit": "recuento",
                "description": "Cantidad de ayudas solicitadas durante la ejecución del juego."
            }
        ]
    },

   {
        "game_code": "LEN-02",
        "name": "A fin",
        "description": "Selecciona la palabra que sea sinónima de la palabra objetivo en el menor tiempo posible.",
        "cognitive_domain": "Lenguaje",
        "metrics": [
            {
            "name": "precision_semantica_pct",
            "display_name": "Precisión Semántica",
            "is_primary": True,
            "unit": "%",
            "description": "Porcentaje de respuestas correctas en la selección de sinónimos semánticamente equivalentes."
            },
            {
            "name": "tiempo_medio_respuesta_correcta_ms",
            "display_name": "Tiempo Medio de Respuesta Correcta",
            "is_primary": True,
            "unit": "ms",
            "description": "Tiempo promedio empleado para responder correctamente en los ensayos válidos."
            },
            {
            "name": "errores_confusion_semantica",
            "display_name": "Errores de Confusión Semántica",
            "is_primary": False,
            "unit": "recuento",
            "description": "Número de errores producidos por selección de distractores semánticamente cercanos al estímulo objetivo."
            },
            {
            "name": "latencia_maxima_respuesta_ms",
            "display_name": "Latencia Máxima de Respuesta",
            "is_primary": False,
            "unit": "ms",
            "description": "Mayor tiempo de respuesta registrado durante la tarea, indicador de sobrecarga semántica o duda léxica."
            }
        ]
    },
    {
        "game_code": "LEN-03",
        "name": "¿Qué sentido tiene?",
        "description": "Clasifica palabras según su valencia semántica (positiva o negativa) utilizando decisiones rápidas con las flechas del teclado.",
        "cognitive_domain": "Lenguaje",
        "metrics": [
            {
            "name": "precision_semantica_pct",
            "display_name": "Precisión Semántica",
            "is_primary": True,
            "unit": "%",
            "description": "Porcentaje de palabras clasificadas correctamente según su significado semántico."
            },
            {
            "name": "tiempo_decision_semantica_ms",
            "display_name": "Tiempo Medio de Decisión Semántica",
            "is_primary": True,
            "unit": "ms",
            "description": "Tiempo promedio empleado para clasificar correctamente el significado semántico de las palabras."
            },
            {
            "name": "errores_clasificacion_semantica",
            "display_name": "Errores de Clasificación Semántica",
            "is_primary": False,
            "unit": "recuento",
            "description": "Número total de clasificaciones incorrectas de la valencia semántica."
            },
            {
            "name": "variabilidad_tr_ms",
            "display_name": "Variabilidad del Tiempo de Respuesta",
            "is_primary": False,
            "unit": "ms",
            "description": "Desviación estándar del tiempo de respuesta en clasificaciones correctas, como indicador de estabilidad del procesamiento semántico."
            }
        ]
    },
    {
        "game_code": "LEN-04",
        "name": "Tormenta de Palabras",
        "description": "Se presenta al participante una letra del abecedario o una categoría semántica y un límite de tiempo para generar la mayor cantidad posible de palabras válidas, cumpliendo reglas explícitas.",
        "cognitive_domain": "Lenguaje y Funciones Ejecutivas",
        "metrics": [
            {
            "name": "tasa_produccion_lexica_wpm",
            "display_name": "Tasa de Producción Léxica",
            "is_primary": True,
            "unit": "palabras/minuto",
            "formula": "total_palabras_validas / tiempo_total_min",
            "description": "Mide la velocidad de acceso y recuperación léxica bajo restricción temporal."
            },
            {
            "name": "total_palabras_validas",
            "display_name": "Total de Palabras Válidas",
            "is_primary": True,
            "unit": "recuento",
            "description": "Número total de palabras correctas, únicas y conformes a la regla producidas durante el intervalo."
            },
            {
            "name": "errores_comision",
            "display_name": "Errores de Comisión",
            "is_primary": False,
            "unit": "recuento",
            "description": "Producción de palabras inválidas: nombres propios, derivaciones o palabras que no cumplen la regla."
            },
            {
            "name": "errores_perseveracion",
            "display_name": "Errores de Perseveración",
            "is_primary": False,
            "unit": "recuento",
            "description": "Repetición de la misma palabra o de la misma raíz léxica."
            },
            {
            "name": "latencia_inicial_ms",
            "display_name": "Latencia Inicial",
            "is_primary": False,
            "unit": "ms",
            "description": "Tiempo transcurrido desde el inicio del ensayo hasta la primera palabra válida."
            },
            {
            "name": "variabilidad_interrespuesta_ms",
            "display_name": "Variabilidad Inter-respuesta",
            "is_primary": False,
            "unit": "ms",
            "description": "Variabilidad temporal entre respuestas consecutivas, indicador de estabilidad en la recuperación léxica."
            }
        ]
    },
    {
        "game_code": "LEN-05",
        "name": "El Lector del Cosmos",
        "description": "El jugador selecciona palabras flotantes y las ordena para construir oraciones gramaticalmente válidas, ignorando palabras distractoras.",
        "cognitive_domain": "Lenguaje",
        "metrics": [
            {
                "name": "precision_sintactica_pct",
                "display_name": "Precisión Sintáctica",
                "is_primary": True,
                "unit": "%",
                "formula": "(oraciones_correctas / total_intentos) * 100",
                "description": "Porcentaje de oraciones construidas correctamente desde el punto de vista gramatical."
            },
            {
                "name": "tiempo_construccion_promedio_ms",
                "display_name": "Tiempo Medio de Construcción",
                "is_primary": False,
                "unit": "ms",
                "description": "Tiempo promedio empleado para construir correctamente una oración."
            },
            {
                "name": "errores_comision_lexica",
                "display_name": "Errores de Comisión Léxica",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de veces que se seleccionaron palabras distractoras durante la construcción de la oración."
            }
        ]
    },
    {
        "game_code": "VISO-01",
        "name": "Apunta y acierta!",
        "description": "Haz clic en el momento exacto en que un objeto en movimiento pasa por un punto objetivo.",
        "cognitive_domain": "Habilidades Visoespaciales y Funciones Ejecutivas",
        "metrics": [
            {
                "name": "precision_temporal_visoespacial_pct",
                "display_name": "Precisión Temporal Visoespacial",
                "is_primary": True,
                "unit": "%",
                "description": "Porcentaje de respuestas ejecutadas dentro de la ventana temporal considerada correcta."
            },
            {
                "name": "error_temporal_absoluto_promedio_ms",
                "display_name": "Error Temporal Absoluto Promedio",
                "is_primary": True,
                "unit": "ms",
                "description": "Diferencia temporal absoluta media entre la respuesta del participante y el instante objetivo."
            },
            {
                "name": "errores_anticipacion",
                "display_name": "Errores de Anticipación",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de respuestas ejecutadas antes de que el objeto alcance el punto objetivo."
            },
            {
                "name": "errores_retraso",
                "display_name": "Errores de Retraso",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de respuestas ejecutadas después de que el objeto ha superado el punto objetivo."
            },
            {
                "name": "variabilidad_error_temporal_ms",
                "display_name": "Variabilidad del Error Temporal",
                "is_primary": False,
                "unit": "ms",
                "description": "Desviación estándar del error temporal absoluto, que refleja la estabilidad del control temporal."
            }
        ]
    },
    {
        "game_code": "VISO-02",
        "name": "Construye la cañería",
        "description": "Rota o mueve piezas de tubería para crear un canal continuo de agua.",
        "cognitive_domain": "Habilidades Visoespaciales y Funciones Ejecutivas",
        "metrics": [
            {
            "name": "indice_completitud_espacial",
            "display_name": "Índice de Completitud Espacial",
            "is_primary": True,
            "unit": "%",
            "description": "Proporción de conexiones correctamente completadas entre fuentes y destinos respecto al total requerido."
            },
            {
            "name": "tiempo_total_resolucion_s",
            "display_name": "Tiempo Total de Resolución",
            "is_primary": True,
            "unit": "s",
            "description": "Tiempo total empleado por el jugador para completar correctamente el tablero."
            },
            {
            "name": "numero_rotaciones_piezas",
            "display_name": "Número de Rotaciones de Piezas",
            "is_primary": False,
            "unit": "recuento",
            "description": "Cantidad total de rotaciones realizadas sobre las piezas de tubería."
            },
            {
            "name": "numero_movimientos_piezas",
            "display_name": "Número de Movimientos de Piezas",
            "is_primary": False,
            "unit": "recuento",
            "description": "Cantidad total de desplazamientos de piezas dentro de la cuadrícula."
            },
            {
            "name": "errores_estructurales",
            "display_name": "Errores Estructurales",
            "is_primary": False,
            "unit": "recuento",
            "description": "Número de conexiones inválidas, tramos abiertos o configuraciones que impiden el flujo continuo."
            }
        ]
    },
    {
        "game_code": "VISO-03",
        "name": "Colorea el camino",
        "description": "Arrastra y coloca bloques de colores para llenar un contorno sin dejar espacios ni superponer piezas.",
        "cognitive_domain": "Habilidades visoconstructivas",
        "metrics": [
            {
            "name": "indice_precision_visoconstructiva_pct",
            "display_name": "Índice de Precisión Viso-constructiva",
            "is_primary": True,
            "unit": "%",
            "description": "Proporción del área del contorno correctamente cubierta sin superposición ni espacios vacíos."
            },
            {
            "name": "tiempo_total_construccion_ms",
            "display_name": "Tiempo Total de Construcción",
            "is_primary": True,
            "unit": "ms",
            "description": "Tiempo total empleado desde la primera colocación válida hasta completar el contorno."
            },
            {
            "name": "errores_superposicion",
            "display_name": "Errores de Superposición",
            "is_primary": False,
            "unit": "recuento",
            "description": "Número de veces que una pieza se superpone a otra."
            },
            {
            "name": "espacios_no_cubiertos",
            "display_name": "Espacios No Cubiertos",
            "is_primary": False,
            "unit": "recuento",
            "description": "Cantidad de áreas del contorno que quedan sin cubrir al finalizar."
            },
            {
            "name": "reubicaciones_piezas",
            "display_name": "Reubicaciones de Piezas",
            "is_primary": False,
            "unit": "recuento",
            "description": "Número total de ajustes realizados después de una colocación inicial."
            }
        ]
    },
    {
        "game_code": "VISO-04",
        "name": "Mosaico espejo",
        "description": "Replica un patrón de colores haciendo clic en las celdas de una cuadrícula vacía.",
        "cognitive_domain": "Habilidades visoconstructivas",
        "metrics": [
            {
            "name": "precision_reconstruccion_pct",
            "display_name": "Precisión de Reconstrucción Visoespacial",
            "is_primary": True,
            "unit": "%",
            "description": "Porcentaje de celdas correctamente replicadas respecto al patrón modelo."
            },
            {
            "name": "tiempo_resolucion_s",
            "display_name": "Tiempo Total de Resolución",
            "is_primary": True,
            "unit": "s",
            "description": "Tiempo total empleado para completar correctamente la reconstrucción del patrón."
            },
            {
            "name": "indice_eficiencia_visoconstructiva",
            "display_name": "Índice de Eficiencia Visoconstructiva",
            "is_primary": True,
            "unit": "ratio",
            "description": "Relación entre precisión alcanzada y tiempo total de resolución (Precisión / Tiempo)."
            },
            {
            "name": "errores_posicion",
            "display_name": "Errores de Posición",
            "is_primary": False,
            "unit": "recuento",
            "description": "Número de celdas seleccionadas en una posición espacial incorrecta."
            },
            {
            "name": "errores_color",
            "display_name": "Errores de Color",
            "is_primary": False,
            "unit": "recuento",
            "description": "Número de celdas seleccionadas con un color incorrecto respecto al modelo."
            }
        ]
    },
    {
        "game_code": "VISO-05",
        "name": "Trazos Conectados",
        "description": "Haz clic y arrastra entre puntos para trazar las líneas y replicar una figura objetivo.",
        "cognitive_domain": "Habilidades visoconstructivas",
        "metrics": [
            {
            "name": "indice_eficiencia_trazado",
            "display_name": "Índice de Eficiencia de Trazado",
            "is_primary": True,
            "unit": "ms",
            "formula": "tiempo_resolucion_ms / precision_trazado",
            "description": "Índice compuesto que penaliza tiempos altos y baja precisión en el trazado."
            },
            {
            "name": "tiempo_resolucion_s",
            "display_name": "Tiempo de Resolución",
            "is_primary": False,
            "unit": "s",
            "description": "Tiempo total para completar la figura."
            },
            {
            "name": "precision_trazado_pct",
            "display_name": "Precisión de Trazado",
            "is_primary": False,
            "unit": "%",
            "description": "Porcentaje de trazos correctos respecto al total requerido por la figura."
            },
            {
            "name": "numero_trazos_incorrectos",
            "display_name": "Número de Trazos Incorrectos",
            "is_primary": False,
            "unit": "recuento",
            "description": "Cantidad de intentos de conexión que no corresponden al modelo."
            }
        ]
    },
    {

        "game_code": "FE-01",
        "name": "Enfoque cambiante",
        "description": "Alterna entre reglas de decisión y requiere abandonar una regla activa para aplicar otra, evaluando flexibilidad cognitiva.",
        "cognitive_domain": "Funciones ejecutivas",
        "metrics": [
            {
            "name": "costo_cambio_regla_ms",
            "display_name": "Costo de cambio de regla",
            "is_primary": True,
            "unit": "ms",
            "description": "Diferencia entre el tiempo medio de reacción en ensayos de cambio de regla y ensayos sin cambio."
            },
            {
            "name": "precision_ensayos_cambio_pct",
            "display_name": "Precisión en ensayos de cambio",
            "is_primary": False,
            "unit": "%",
            "description": "Porcentaje de respuestas correctas únicamente en ensayos donde la regla cambia."
            },
            {
            "name": "tasa_errores_perseverativos_pct",
            "display_name": "Tasa de errores perseverativos",
            "is_primary": False,
            "unit": "%",
            "description": "Porcentaje de ensayos de cambio en los que se aplica incorrectamente la regla anterior."
            },
            {
            "name": "tr_medio_sin_cambio_ms",
            "display_name": "Tiempo medio de respuesta en ensayos sin cambio",
            "is_primary": False,
            "unit": "ms",
            "description": "Tiempo de reacción promedio en ensayos donde la regla se mantiene."
            }
        ]
    },
    {
        "game_code": "FE-02",
        "name": "Comparación de colores",
        "description": "Indica si el significado de una palabra coincide con el color de un parche, inhibiendo la lectura automática del texto.",
        "cognitive_domain": "Atención y Funciones Ejecutivas",
        "metrics": [
            {
            "name": "precision_incongruentes_pct",
            "display_name": "Precisión en Ensayos Incongruentes",
            "is_primary": True,
            "unit": "%",
            "description": "Porcentaje de respuestas correctas en ensayos con conflicto semántico (control inhibitorio)."
            },
            {
            "name": "tr_promedio_congruentes_ms",
            "display_name": "Tiempo de Reacción – Congruentes",
            "is_primary": False,
            "unit": "ms",
            "description": "Tiempo medio de reacción cuando palabra y color coinciden."
            },
            {
            "name": "tr_promedio_incongruentes_ms",
            "display_name": "Tiempo de Reacción – Incongruentes",
            "is_primary": False,
            "unit": "ms",
            "description": "Tiempo medio de reacción cuando palabra y color no coinciden."
            },
            {
            "name": "efecto_interferencia_stroop_ms",
            "display_name": "Efecto de Interferencia (Stroop)",
            "is_primary": False,
            "unit": "ms",
            "description": "Diferencia entre el TR promedio en ensayos incongruentes y congruentes."
            },
            {
            "name": "errores_comision",
            "display_name": "Errores de Comisión",
            "is_primary": False,
            "unit": "recuento",
            "description": "Respuestas incorrectas por falta de inhibición ante estímulos incongruentes."
            },
            {
            "name": "errores_omision",
            "display_name": "Errores de Omisión",
            "is_primary": False,
            "unit": "recuento",
            "description": "Fallas de respuesta ante estímulos objetivo."
            }
        ]
    },
    {
        "game_code": "FE-03",
        "name": "Hojas navegantes",
        "description": "Indica la dirección del movimiento si la hoja es naranja o la orientación si la hoja es verde.",
        "cognitive_domain": "Funciones ejecutivas",
        "metrics": [
            {
                "name": "costo_cambio_ms",
                "display_name": "Costo de Cambio (Switch Cost)",
                "is_primary": True,
                "unit": "ms",
                "description": "Diferencia de tiempo de reacción entre ensayos de cambio y ensayos de repetición (TR_cambio − TR_repetición)."
            },
            {
                "name": "precision_general_pct",
                "display_name": "Precisión General",
                "is_primary": False,
                "unit": "%",
                "description": "Porcentaje total de respuestas correctas considerando todos los ensayos."
            },
            {
                "name": "tr_promedio_repeticion_ms",
                "display_name": "Tiempo de Reacción – Ensayos de Repetición",
                "is_primary": False,
                "unit": "ms",
                "description": "Tiempo de reacción promedio en ensayos donde la regla cognitiva se mantiene."
            },
            {
                "name": "tr_promedio_cambio_ms",
                "display_name": "Tiempo de Reacción – Ensayos de Cambio",
                "is_primary": False,
                "unit": "ms",
                "description": "Tiempo de reacción promedio en ensayos donde la regla cognitiva cambia."
            },
            {
                "name": "errores_perseveracion",
                "display_name": "Errores de Perseveración",
                "is_primary": False,
                "unit": "recuento",
                "description": "Número de respuestas incorrectas en ensayos de cambio por aplicación de la regla previa."
            }
        ]
    },

    {
        "game_code": "FE-04",
        "name": "Balance de balanza",
        "description": "Deduce qué conjunto de formas equilibrará la última balanza a partir de reglas inferidas de relaciones previas.",
        "cognitive_domain": "Funciones ejecutivas",
        "metrics": [
            {
            "name": "precision_inferencial_pct",
            "display_name": "Precisión Inferencial",
            "is_primary": True,
            "unit": "%",
            "description": "Porcentaje de problemas correctamente resueltos mediante inferencia lógica relacional."
            },
            {
            "name": "tiempo_medio_resolucion_ms",
            "display_name": "Tiempo Medio de Resolución",
            "is_primary": False,
            "unit": "ms",
            "description": "Tiempo promedio requerido para resolver correctamente un problema de balance."
            },
            {
            "name": "errores_inferenciales",
            "display_name": "Errores Inferenciales",
            "is_primary": False,
            "unit": "recuento",
            "description": "Número de intentos incorrectos derivados de inferencias lógicas erróneas."
            }
        ]
    },
    {
        "game_code": "FE-05",
        "name": "Matrices progresivas",
        "description": "Deduce la regla lógica de una matriz 3x3 incompleta y selecciona la figura que la completa.",
        "cognitive_domain": "Funciones ejecutivas",
        "metrics": [
            {
            "name": "precision_matrices_pct",
            "display_name": "Precisión en matrices",
            "is_primary": True,
            "unit": "%",
            "description": "Porcentaje de matrices correctamente resueltas respecto al total de matrices presentadas."
            },
            {
            "name": "tiempo_medio_resolucion_ms",
            "display_name": "Tiempo medio de resolución",
            "is_primary": False,
            "unit": "ms",
            "description": "Tiempo promedio empleado para resolver una matriz."
            },
            {
            "name": "nivel_maximo_complejidad",
            "display_name": "Nivel máximo de complejidad alcanzado",
            "is_primary": False,
            "unit": "nivel",
            "description": "Nivel más alto de complejidad lógica que el jugador logró resolver correctamente."
            },
            {
            "name": "tasa_errores_logicos_pct",
            "display_name": "Tasa de errores lógicos",
            "is_primary": False,
            "unit": "%",
            "description": "Proporción de respuestas incorrectas atribuibles a una inferencia lógica errónea."
            }
        ]
    }

]

def create_game_with_metrics(db: Session, game: schemas.GameCreate):
    """Crea un nuevo juego y todas sus métricas asociadas."""
    # Separamos los datos del juego de los de las métricas
    game_data = game.dict(exclude={'metrics'})
    db_game = models.Game(**game_data)
    
    # Creamos los objetos de métricas y los asociamos al juego
    for metric_data in game.metrics:
        db_metric = models.Metric(**metric_data.dict())
        db_game.metrics.append(db_metric)
        
    db.add(db_game)
    db.commit()
    db.refresh(db_game)
    return db_game


def populate_games(db: Session):
    """Popula la tabla de juegos con el nuevo catálogo relacional."""
    games_created = []
    for game_data in GAMES_CATALOG_NEW: # Usamos el nuevo catálogo
        db_game = get_game_by_code(db, game_code=game_data["game_code"])
        if not db_game:
            game_schema = schemas.GameCreate(**game_data)
            # Llamamos a la nueva función de creación
            created_game = create_game_with_metrics(db, game=game_schema)
            games_created.append(created_game.name)
    
    return {"message": "Catálogo de juegos actualizado.", "new_games_added": games_created}

def sync_game_metrics(db: Session, game_code: str):
    game = get_game_by_code(db, game_code=game_code)
    if not game:
        return {"ok": False, "message": f"No existe el juego {game_code}"}

    catalog_game = next((g for g in GAMES_CATALOG_NEW if g["game_code"] == game_code), None)
    if not catalog_game:
        return {"ok": False, "message": f"No existe {game_code} en GAMES_CATALOG_NEW"}

    catalog_names = {m["name"] for m in catalog_game["metrics"]}
    existing_metrics = {m.name: m for m in game.metrics}

    created = []
    deleted = []

    # 1️⃣ Eliminar métricas que existen en BD pero NO en el catálogo teórico
    for name, metric in existing_metrics.items():
        if name not in catalog_names:
            db.delete(metric)
            deleted.append(name)

    # 2️⃣ Insertar métricas que faltan
    for metric_data in catalog_game["metrics"]:
        if metric_data["name"] not in existing_metrics:
            db_metric = models.Metric(**metric_data, game_id=game.id)
            db.add(db_metric)
            created.append(metric_data["name"])

    db.commit()
    return {
        "ok": True,
        "created": created,
        "deleted": deleted
    }

    game = get_game_by_code(db, game_code=game_code)
    if not game:
        return {"ok": False, "message": f"No existe el juego {game_code}"}

    catalog_game = next((g for g in GAMES_CATALOG_NEW if g["game_code"] == game_code), None)
    if not catalog_game:
        return {"ok": False, "message": f"No existe {game_code} en GAMES_CATALOG_NEW"}

    existing_names = {m.name for m in game.metrics}

    # 1) Insertar las que faltan
    created = []
    for metric_data in catalog_game["metrics"]:
        if metric_data["name"] not in existing_names:
            db_metric = models.Metric(**metric_data, game_id=game.id)
            db.add(db_metric)
            created.append(metric_data["name"])

    # 2) Asegurar que SOLO una quede como principal (la del catálogo)
    primary_name = next((m["name"] for m in catalog_game["metrics"] if m.get("is_primary")), None)
    if primary_name:
        db.query(models.Metric).filter(models.Metric.game_id == game.id).update({"is_primary": False})
        db.query(models.Metric).filter(
            models.Metric.game_id == game.id,
            models.Metric.name == primary_name
        ).update({"is_primary": True})

    db.commit()
    return {"ok": True, "created": created, "primary": primary_name}


def get_games(db: Session, skip: int = 0, limit: int = 100):
    games = db.query(models.Game).offset(skip).limit(limit).all()

    # ✅ ordenar métricas: principal primero, luego por id (o display_name)
    for g in games:
        if getattr(g, "metrics", None):
            g.metrics.sort(key=lambda m: (not bool(m.is_primary), m.id))

    return games


def get_game_by_code(db: Session, game_code: str):
    game = db.query(models.Game).filter(models.Game.game_code == game_code).first()
    if game and getattr(game, "metrics", None):
        game.metrics.sort(key=lambda m: (not bool(m.is_primary), m.id))
    return game


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
# FORM_THE_SENTENCE_GAME_ID = 17 # Asegúrate de que este ID sea correcto para tu juego
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
                "el niño corre en el parque grande",
                "el niño corre feliz en el parque"
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


def populate_game_levels(db: Session):
    """
    Popula niveles para El Lector del Cosmos resolviendo el game_id real
    por código (LEN-05) en lugar de depender de un ID fijo.
    """
    game = get_game_by_code(db, game_code="LEN-05")
    if not game:
        populate_games(db)
        game = get_game_by_code(db, game_code="LEN-05")
        if not game:
            return {"message": "No se encontró el juego LEN-05 (El Lector del Cosmos).", "new_levels_added": 0}

    game_id = game.id

    levels_created_count = 0
    for level_info in SENTENCE_GAME_LEVELS:
        db_level = db.query(models.GameLevel).filter_by(
            game_id=game_id, level_number=level_info["level_number"]
        ).first()
        if not db_level:
            new_level = models.GameLevel(
                game_id=game_id,
                level_number=level_info["level_number"],
                phase=level_info["phase"],
                level_data=level_info["level_data"]
            )
            db.add(new_level)
            levels_created_count += 1
    db.commit()
    return {"message": "Niveles del Lector del Cosmos añadidos.", "new_levels_added": levels_created_count}






# get_level_data se mantiene igual
def get_level_data(db: Session, game_id: int, level_number: int):
    return db.query(models.GameLevel).filter_by(game_id=game_id, level_number=level_number).first()


""""
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

"""
def check_user_sentence(db: Session, gameplay_id: int, user_sentence: str):
    """
    Verifica la oración del usuario, determina si es correcta y cuenta el
    número de palabras distractoras utilizadas en la respuesta.
    """
    db_gameplay = db.query(models.GamePlay).filter(models.GamePlay.id == gameplay_id).first()
    if not db_gameplay:
        return None

    level_config = get_level_data(db, game_id=db_gameplay.game_id, level_number=db_gameplay.current_level)
    if not level_config:
        return None

    level_data = level_config.level_data
    valid_sentences = level_data.get("valid_sentences", [])
    word_set = set(level_data.get("word_set", []))

    # 1. Determinar cuáles palabras son correctas y cuáles son distractoras
    words_in_valid_sentences = set()
    for sentence in valid_sentences:
        words_in_valid_sentences.update(sentence.split())
    
    # Las palabras distractoras son aquellas en el word_set que no pertenecen a ninguna oración válida
    distractor_words = word_set - words_in_valid_sentences

    # 2. Verificar si la oración completa es una de las válidas
    is_correct = user_sentence in valid_sentences

    # 3. Contar cuántos distractores usó el usuario en su intento
    user_words = set(user_sentence.split())
    distractors_used_count = len(user_words.intersection(distractor_words))

    # 4. Devolver un objeto con toda la información
    return {
        "is_correct": is_correct, 
        "distractors_used": distractors_used_count
    }

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


# --- LÓGICA PARA "TORMENTA DE PALABRAS" ---

# --- LÓGICA PARA "TORMENTA DE PALABRAS" ---
def populate_word_storm_levels(db: Session):
    """
    Popula GameLevel para 'Tormenta de Palabras' usando el ID real del juego
    (buscado por GAME_CODE), evitando depender de un ID fijo.
    """
    # 1) Buscar el juego por código (LEN-04)
    game = get_game_by_code(db, game_code=tormenta_de_palabras.GAME_CODE)  # "LEN-04"
    if not game:
        # Si aún no existe, poblar catálogo y volver a buscar
        populate_games(db)
        game = get_game_by_code(db, game_code=tormenta_de_palabras.GAME_CODE)
        if not game:
            return {"message": "No se encontró el juego Tormenta de Palabras (LEN-04)."}

    game_id = game.id  # ← ID real en BD

    # 2) Insertar niveles con ese game_id real
    levels_created_count = 0
    for level_info in tormenta_de_palabras.WORD_STORM_LEVELS:
        db_level = db.query(models.GameLevel).filter_by(
            game_id=game_id,
            level_number=level_info["level_number"]
        ).first()
        if not db_level:
            new_level = models.GameLevel(
                game_id=game_id,
                level_number=level_info["level_number"],
                phase=level_info["phase"],
                level_data=level_info["level_data"]
            )
            db.add(new_level)
            levels_created_count += 1

    db.commit()
    return {"message": "Niveles de Tormenta de Palabras añadidos.", "new_levels_added": levels_created_count}

    """
    Popula la tabla GameLevel con los niveles definidos en el archivo
    de lógica de Tormenta de Palabras.
    """
    levels_created_count = 0
    game_id = tormenta_de_palabras.GAME_ID
    
    for level_info in tormenta_de_palabras.WORD_STORM_LEVELS:
        db_level = db.query(models.GameLevel).filter_by(
            game_id=game_id, 
            level_number=level_info["level_number"]
        ).first()
        if not db_level:
            new_level = models.GameLevel(
                game_id=game_id,
                level_number=level_info["level_number"],
                phase=level_info["phase"],
                level_data=level_info["level_data"]
            )
            db.add(new_level)
            levels_created_count += 1
            
    db.commit()
    return {"message": "Niveles de Tormenta de Palabras añadidos.", "new_levels_added": levels_created_count}

def submit_word_storm_answers(db: Session, gameplay_id: int, submitted_words: list[str]):
    """
    Procesa las respuestas de una partida de Tormenta de Palabras, calcula
    las métricas y actualiza la base de datos.
    """
    # 1. Obtener la partida y el nivel actual
    db_gameplay = db.query(models.GamePlay).filter(models.GamePlay.id == gameplay_id).first()
    if not db_gameplay:
        return None # O lanzar una excepción

    current_level = db_gameplay.current_level or 1
    level_config = get_level_data(db, game_id=db_gameplay.game_id, level_number=current_level)
    if not level_config:
        return None # O lanzar una excepción

    # 2. Usar la función de lógica del juego para procesar los resultados
    results = tormenta_de_palabras.process_word_storm_results(
        submitted_words,
        level_config.level_data
    )

    # 3. Actualizar la partida en la base de datos
    db_gameplay.score = (db_gameplay.score or 0) + results["total_score"]
    
    # Guardar los resultados detallados del nivel
    # Es buena práctica guardar los resultados por nivel
    current_results = db_gameplay.results_data or {}
    current_results[f"level_{current_level}"] = results
    
    db_gameplay.results_data = current_results
    db.add(db_gameplay)
    db.commit()
    db.refresh(db_gameplay)
    
    return results
