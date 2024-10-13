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

        self.skills = [
            "greenfinger"
        ]

        self.herois_em_uso = {
            "kella": None,
            "pan": None,
            "chak": None,
            "ordo": None,
            "tarra": None,
            "naernin": None,
            }

        self.Gold = [
            "kella",
            "naernin",
            "pan",
            "chak",
            "tarra",
            "ordo",
        ]
        self.Wood = [
            "pan",
            "naernin",
            "chak",
            "kella",
            "tarra",
            "ordo",
        ]
        self.Rock = [
            "chak",
            "naernin",
            "tarra",
            "kella",
            "pan",
            "ordo",
        ]
        self.Mana = [
            "tarra",
            "ordo",
            "naernin",
            "pan",
            "chak",
            "kella",
        ]
        self.Gema = [
            "pan",
            "chak",
            "kella",
            "tarra",
            "ordo",
            "naernin",
        ]