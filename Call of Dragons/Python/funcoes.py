import random
import interception
from interception import beziercurve
import os
import sys
from datetime import datetime
import time
import ctypes
from ctypes import wintypes


class Funcoes:
    _instance = None  # Singleton instance

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super(Funcoes, cls).__new__(cls)
        return cls._instance

    def __init__(self):
        if not hasattr(self, 'initialized'):  # Para evitar reinicializar
            interception.auto_capture_devices()
            
            self.TeclaEspeciais = {
                "upkey": "0x26",
                "downkey": "0x28",
                "leftkey": "0x25",
                "rightkey": "0x27"
            }

            # Constantes para os comandos do ShowWindow
            self.SW_HIDE = 0       # Ocultar a janela
            self.SW_SHOW = 5       # Mostrar a janela
            self.SW_MINIMIZE = 6   # Minimizar a janela
            self.SW_MAXIMIZE = 3   # Maximizar a janela
            self.SW_RESTORE = 9    # Restaurar uma janela minimizada/maximizada

            janela = "Call of Dragons"
            self.user32 = ctypes.windll.user32

            curve_params = beziercurve.BezierCurveParams()

            beziercurve.set_default_params(curve_params)

            # Função para obter o handle de uma janela pelo nome da janela
            self.hwnd = self.user32.FindWindowW(None, janela)

            if self.user32.IsIconic(self.hwnd):
                self.user32.ShowWindow(self.hwnd, self.SW_RESTORE)
                input(f"{janela} minimizada, por favor abre ela")

            self.rect = wintypes.RECT()
            success = self.user32.GetWindowRect(self.hwnd, ctypes.byref(self.rect))

            print(f"Conseguiu localizar a janela {self.rect.left}")
            # Indica que a classe foi inicializada
            self.initialized = True

    def gera_log(self, conta, mensagem):
        if conta is None:
            raise Exception("Ta sem conta no log")
        if getattr(sys, 'frozen', False):
            # O programa está rodando em modo empacotado
            diretorio_atual = os.path.dirname(sys.executable)
        else:
            # O programa está rodando a partir do código fonte
            diretorio_atual = os.path.dirname(os.path.abspath(__file__))
        nomearquivo = f"codlogvm{conta}.log" if ("F" in diretorio_atual) or ("Z" in diretorio_atual) else f"codlog.log"
        caminho_log = f'{diretorio_atual}\\{nomearquivo}'
        try:
            with open(caminho_log, 'r') as file:
                # Lê o conteúdo existente
                content = file.readlines()
        except FileNotFoundError:
            content = []
        data_atual = datetime.now()

        # Formatar a data e hora
        data_formatada = data_atual.strftime('%H:%M:%S')

        # Adiciona a nova mensagem no topo
        content.insert(0, f'{data_formatada} - {mensagem}\n')

        # Escreve o conteúdo atualizado de volta no arquivo
        with open(caminho_log, 'w') as file:
            file.writelines(content)
        

    def clica_random(self, cords, var = 5, velo = 50, lado=0, clicks=1, janela=False):
        if janela:
            # gera_log(rect)
            self.user32.GetWindowRect(self.hwnd, ctypes.byref(self.rect))
            window_x, window_y = self.rect.left, self.rect.top

            # Calcula a posição do mouse relativa à janela
            cords = (cords[0] + window_x, cords[1] + window_y)
        for _ in range(clicks):
            rand = random.randint(-var, var)
            rand2 = random.randint(-var, var)

            interception.move_to(cords[0]+rand, cords[1]+rand2)
            self.espera_random(velo)
            interception.mouse_down(button="left" if lado == 0 else "right")
            self.espera_random(velo)
            interception.mouse_up(button="left" if lado == 0 else "right")
            # interception.click(
            #     cords[0]+rand, cords[1]+rand2,
            #     button="left" if lado == 0 else "right",
            #     delay=velo)
            # gera_log("Clicou")
        
    def move_mouse(self, cords, var = 5, velo = 30, janela=False):
        if janela:
            # gera_log(rect)
            self.user32.GetWindowRect(self.hwnd, ctypes.byref(self.rect))
            window_x, window_y = self.rect.left, self.rect.top

            # Calcula a posição do mouse relativa à janela
            cords = (cords[0] + window_x, cords[1] + window_y)
            
        rand = random.randint(-var, var)
        rand2 = random.randint(-var, var)

        interception.move_to(cords[0]+rand, cords[1]+rand2)
        self.espera_random(velo)
        

    def tecla(self, a, b = None, tempo = 100):
        tempo = random.randint(round(((tempo*0.7))), round(tempo*1.3))
        tempo = tempo / 1000
        if b:
            with interception.hold_key(b):
                interception.key_down(a, delay=round(tempo/2))
                interception.key_up(a, delay=round(tempo/2))
        else:
            interception.key_down(a, delay=round(tempo/2))
            self.espera_random(tempo/2)
            interception.key_up(a)

    def rand_rand(self, tempo, mili = True):
        tempo = random.randint(round(((tempo*0.7))), round(tempo*1.3))
        if not mili:
            return tempo / 1000
        return tempo

    def hold_tecla(self, key):
        interception.key_down(key)
        try:
            yield
        finally:
            interception.key_up(key)
    
    def espera_random(self, tempo=500):
        tempo = random.randint(round(((tempo*0.7))), round(tempo*1.3))
        tempo = tempo / 1000
        time.sleep(tempo)


    def ativa(self):
        # Pega a janela ativa
        try:
            if self.hwnd:
            # Traz a janela para o foco
                if self.user32.IsIconic(self.hwnd):
                    # Restaura a janela minimizada
                    self.gera_log("Estava minimizada.")
                    self.user32.ShowWindow(self.hwnd, self.SW_RESTORE)
                    time.sleep(1)  # Dá uma pausa para garantir que a janela seja restaurada
                    self.user32.ShowWindow(self.hwnd, self.SW_SHOW)
                self.user32.SetForegroundWindow(self.hwnd)
        except:
            pass
