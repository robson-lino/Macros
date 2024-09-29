from enum import Enum

# Define um Enum para os tipos de recursos
class TipoRss(Enum):
    Gold = 1
    Wood = 2
    Rock = 3
    Mana = 4
    Gema = 5

class Herois:
    def __init__(self):
        # Criando heróis com suas prioridades para diferentes recursos
        self.Gold = [
            "kella",
            "pan",
            "chak",
            "ordo",
            "tarra",
        ]
        self.Wood = [
            "pan",
            "chak",
            "kella",
            "ordo",
            "tarra",
        ]
        self.Rock = [
            "chak",
            "pan",
            "kella",
            "ordo",
            "tarra",
        ]
        self.Mana = [
            "tarra",
            "ordo",
            "pan",
            "chak",
            "kella",
        ]
        self.Gema = [
            "pan",
            "chak",
            "kella",
            "ordo",
            "tarra",
        ]