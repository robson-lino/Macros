import tkinter as tk
from tkinter import ttk
import multiprocessing
import cv2 as cv
import pytesseract
import os
import sys
import numpy as np
import time
import json
import re

from funcoes import *
from Herois import *
from Threads import *
from exceptions import *


class Gui:
    _instance = None  # Singleton instance
    

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super(Gui, cls).__new__(cls)
        return cls._instance

    def __init__(self, screen_agent):
        # Criação da janela principal
        
        if not hasattr(self, 'initialized'):  # Para evitar reinicializar
            self.screen_agent = screen_agent
            self.f = Funcoes()

            # Intervalo de tempos
            self.ultimos_tempos = {}
            self.tempos = {"donate": 3600,
                                    }
            
            self.herois = Herois()

            # Diretorio atual
            if getattr(sys, 'frozen', False):
                # O programa está rodando em modo empacotado
                self.diretorio_atual = os.path.dirname(sys.executable)
            else:
                # O programa está rodando a partir do código fonte
                self.diretorio_atual = os.path.dirname(os.path.abspath(__file__))


            # Intervalo de tempos
            self.image_cache = {}
            self.thread_run = None
            self.thread_teste = None
            self.thread_mainloop = None

            if self.screen_agent.capture_process is None:
                multiprocessing.freeze_support()
                self.screen_agent.capture_process = multiprocessing.Process(
                        target=self.screen_agent.capture_screen, 
                        args=(), 
                        name="screen capture process")
            self.screen_agent.capture_process.start()
            self.root = tk.Tk()
            self.root.title("Minha GUI")

            # Configurando o redimensionamento do grid
            for i in range(8):  # Número de linhas
                self.root.grid_rowconfigure(i, weight=1)  # Permite que as linhas se expandam
            for i in range(5):  # Número de colunas
                self.root.grid_columnconfigure(i, weight=1)  # Permite que as colunas se expandam


            # Variáveis compartilhadas
            self.optConta = tk.IntVar(value=1)  # Inicializando com Conta1 selecionada
            self.chkTrocar = tk.BooleanVar(value=True)
            self.chkVisaoPC = tk.BooleanVar(value=False)
            self.chkEsperar = tk.BooleanVar(value=False)
            self.chkUpar = tk.BooleanVar(value=False)
            self.chkMaxRss = tk.BooleanVar(value=False)
            self.chkDonate = tk.BooleanVar(value=True)
            self.chkExplorar = tk.BooleanVar(value=False)

            self.chkInf = tk.BooleanVar(value=True)
            self.chkMag = tk.BooleanVar(value=True)
            self.chkCav = tk.BooleanVar(value=True)
            self.chkCel = tk.BooleanVar(value=True)
            self.chkArq = tk.BooleanVar(value=True)

            self.tInf = tk.StringVar(value="3")
            self.tMag = tk.StringVar(value="3")
            self.tCav = tk.StringVar(value="1")
            self.tCel = tk.StringVar(value="3")
            self.tArq = tk.StringVar(value="3")

            self.chkWood = tk.BooleanVar(value=True)
            self.chkRock = tk.BooleanVar(value=True)
            self.chkGold = tk.BooleanVar(value=True)
            self.chkMana = tk.BooleanVar(value=False)
            self.chkGema = tk.BooleanVar(value=False)

            self.tWood = tk.StringVar(value="1")
            self.tRock = tk.StringVar(value="1")
            self.tGold = tk.StringVar(value="1")
            self.tMana = tk.StringVar(value="1")
            self.tGema = tk.StringVar(value="1")

             # Definir as variáveis globais para padx e pady
            self.padx = 1
            self.pady = 1

            # Montando a interface
            self._create_widgets()

            self.load_settings()
            self.opt_valor_anterior = self.optConta.get()
            # Interceptar o fechamento da janela (clicar no X)
            self.root.protocol("WM_DELETE_WINDOW", self.on_closing)

            # Indica que a classe foi inicializada
            self.initialized = True

    def _create_widgets(self):
        # Radio buttons
        tk.Radiobutton(self.root, text="Conta1", variable=self.optConta, value=1, command=self.on_radio_change).grid(row=0, column=0, padx=self.padx, pady=self.pady, sticky="ew")
        tk.Radiobutton(self.root, text="Conta2", variable=self.optConta, value=2, command=self.on_radio_change).grid(row=0, column=1, padx=self.padx, pady=self.pady, sticky="ew")
        tk.Button(self.root, text="Save", command=self.save_settings).grid(row=0, column=2, padx=self.padx, pady=self.pady, sticky="ew")
        tk.Button(self.root, text="Load", command=self.load_settings).grid(row=0, column=3, padx=self.padx, pady=self.pady, sticky="ew")
        tk.Checkbutton(self.root, text="Trocar", variable=self.chkTrocar).grid(row=0, column=4, padx=self.padx, pady=self.pady, sticky="ew")
        # Checkboxes and Dropdowns

        self.create_checkbox_with_combobox("Inf", self.chkInf, self.tInf, 1, 0)
        self.create_checkbox_with_combobox("Mag", self.chkMag, self.tMag, 1, 1)
        self.create_checkbox_with_combobox("Cav", self.chkCav, self.tCav, 1, 2)
        self.create_checkbox_with_combobox("Cel", self.chkCel, self.tCel, 1, 3)
        self.create_checkbox_with_combobox("Arq", self.chkArq, self.tArq, 1, 4)

        self.create_checkbox_with_combobox("Wood", self.chkWood, self.tWood, 3, 0)
        self.create_checkbox_with_combobox("Rock", self.chkRock, self.tRock, 3, 1)
        self.create_checkbox_with_combobox("Gold", self.chkGold, self.tGold, 3, 2)
        self.create_checkbox_with_combobox("Mana", self.chkMana, self.tMana, 3, 3)
        self.create_checkbox_with_combobox("Gema", self.chkGema, self.tGema, 3, 4)

        # Buttons
        tk.Button(self.root, text="Screen", command=self.show_screen_action).grid(row=5, column=0, padx=self.padx, pady=self.pady, sticky="ew")
        tk.Button(self.root, text="Restart", command=self.restart_action).grid(row=5, column=1, padx=self.padx, pady=self.pady, sticky="ew")
        tk.Button(self.root, text="Start", command=self.start_action).grid(row=6, column=0, padx=self.padx, pady=self.pady, sticky="ew")
        tk.Button(self.root, text="Stop", command=self.stop_action).grid(row=6, column=1, padx=self.padx, pady=self.pady, sticky="ew")
        tk.Button(self.root, text="Teste", command=self.teste_action).grid(row=6, column=2, padx=self.padx, pady=self.pady, sticky="ew")
        
        # Textbox
        self.lbRodando = tk.Label(self.root, text="")
        self.lbRodando.grid(row=6, column=3, padx=self.padx, pady=self.pady, sticky="ew")

        # Additional Checkbuttons
        tk.Checkbutton(self.root, text='Visao', variable=self.chkVisaoPC).grid(row=7, column=0, padx=self.padx, pady=self.pady, sticky="w")
        tk.Checkbutton(self.root, text='Espera', variable=self.chkEsperar).grid(row=7, column=1, padx=self.padx, pady=self.pady, sticky="w")
        tk.Checkbutton(self.root, text='Builds', variable=self.chkUpar).grid(row=7, column=2, padx=self.padx, pady=self.pady, sticky="w")
        tk.Checkbutton(self.root, text='M. rss', variable=self.chkMaxRss).grid(row=7, column=3, padx=self.padx, pady=self.pady, sticky="w")
        tk.Checkbutton(self.root, text='Donate', variable=self.chkDonate).grid(row=7, column=4, padx=self.padx, pady=self.pady, sticky="w")
        tk.Checkbutton(self.root, text="Explorar", variable=self.chkExplorar).grid(row=8, column=0, padx=self.padx, pady=self.pady, sticky="w")

    def create_checkbox_with_combobox(self, text, variable, tvariable, row, column):
        tk.Checkbutton(self.root, text=text, variable=variable).grid(row=row, column=column, padx=self.padx, pady=self.pady, sticky="ew")
        ttk.Combobox(self.root, textvariable=tvariable, values=["1", "2", "3", "4", "5"], width=3).grid(row=row+1, column=column, padx=self.padx, pady=self.pady, sticky="ew")

    def load_settings(self):
        # Se o arquivo existir, carregar os valores salvos
        if os.path.exists(self.nome_arquivo_config()):
            with open(self.nome_arquivo_config(), "r") as f:
                data = json.load(f)
                for key, value in data.items():
                    if hasattr(self, key) and key != "chkTrocar":
                        var = getattr(self, key)
                        if isinstance(var, (tk.IntVar, tk.BooleanVar, tk.StringVar)):
                            var.set(value)
        self.gera_log(f"Configuração carregada do {self.nome_arquivo_config()}")

    def save_settings(self):
        # Salvar os valores atuais no arquivo JSON
        data = {}
        for key, var in vars(self).items():
            if isinstance(var, (tk.IntVar, tk.BooleanVar, tk.StringVar)) and key != "chkTrocar":
                data[key] = var.get()
        with open(self.nome_arquivo_config(), "w") as f:
            json.dump(data, f)
        self.gera_log(f"Configuração salva em {self.nome_arquivo_config()}")

    def on_radio_change(self):
        # Gambiarra monstra pra salvar ao mudar.
        if self.optConta.get() != self.opt_valor_anterior:
            aux = self.optConta.get()
            self.optConta.set(self.opt_valor_anterior)
            self.save_settings()
            self.optConta.set(aux)
            self.opt_valor_anterior = self.optConta.get()
        # Função chamada ao mudar o valor do Radiobutton
        self.load_settings()

    def show(self):
        self.root.update()
        self.root.geometry("")  # Permite que a janela expanda conforme o conteúdo
        self.root.mainloop()

    def listar_valores(self):
        valores = {
            "Conta Selecionada": self.optConta1.get(),
            "Explorar": self.chkExplorar.get(),
            "VisaoPC": self.chkVisaoPC.get(),
            "Esperar": self.chkEsperar.get(),
            "Upar": self.chkUpar.get(),
            "Inf": (self.chkInf.get(), self.tInf.get()),
            "Mag": (self.chkMag.get(), self.tMag.get()),
            "Cav": (self.chkCav.get(), self.tCav.get()),
            "Cel": (self.chkCel.get(), self.tCel.get()),
            "Arq": (self.chkArq.get(), self.tArq.get()),
            "Wood": (self.chkWood.get(), self.tWood.get()),
            "Rock": (self.chkRock.get(), self.tRock.get()),
            "Gold": (self.chkGold.get(), self.tGold.get()),
            "Mana": (self.chkMana.get(), self.tMana.get()),
            "Gema": (self.chkGema.get(), self.tGema.get())
        }

        # Print all values
        for key, value in valores.items():
            print(f"{key}: {value}")

    def stop_action(self):
        if self.thread_run is not None and self.thread_run.is_alive():
            self.thread_run.stop(self.optConta)
        if self.thread_teste is not None and self.thread_teste.is_alive():
            self.thread_teste.stop(self.optConta)
        if (self.screen_agent.capture_process is not None and
            (self.thread_run is None or (self.thread_run is not None and not self.thread_run.is_alive())) and
            (self.thread_teste is None or (self.thread_teste is not None and not self.thread_teste.is_alive()))):
            self.screen_agent.capture_process.terminate()
            self.screen_agent.capture_process = None

    def restart_action(self):
        if self.thread_run is not None and self.thread_run.is_alive():
            self.thread_run.stop(self.optConta)
            print(f"A {self.thread_run.name} está ativa, tente depois. (COMO RESOLVER ISSO?)")
            return
        if self.thread_teste is not None and self.thread_teste.is_alive():
            self.thread_teste.stop(self.optConta)
            print(f"A {self.thread_teste.name} de Teste está ativa, tente depois. (COMO RESOLVER ISSO?)")
            return
    
        if self.screen_agent.capture_process is not None:
            self.screen_agent.capture_process.terminate()
            self.screen_agent.capture_process = None
        if self.screen_agent.capture_process is None:
            multiprocessing.freeze_support()
            self.screen_agent.capture_process = multiprocessing.Process(
                    target=self.screen_agent.capture_screen, 
                    args=(), 
                    name="screen capture process")
        self.screen_agent.capture_process.start()

    def start_action(self):
        self.thread_run = StoppableThread(optConta=self.optConta.get(), target=self.run, args=())
        self.thread_run.start()
        if self.thread_run.is_alive():
            self.gera_log(f"{self.thread_run.name} iniciada com sucesso.")
        
    def teste_action(self):
        self.thread_teste = StoppableThread(optConta=self.optConta.get(), target=self.teste, args=())
        self.thread_teste.start()
        if self.thread_teste.is_alive():
            self.gera_log(f"{self.thread_teste.name} iniciada com sucesso.")
    
    def run(self):
        self.f.ativa()
        while True:
            if self.thread_run.stopped():
                self.gera_log("Vai encerrar a thread.")
                break
            self.lbRodando.config(text=f"")
            self.verifica()
            count = 0
            start_time = time.time()
            tempo = 2 * (60)
            temporand = random.randint(round(((tempo*0.7))), round(tempo*1.3))
            while (time.time() - start_time) < temporand or bool(self.chkEsperar.get()):
                time.sleep(1)
                count += 1
                #if count % 5 == 0:
                self.lbRodando.config(text=f"Foi {count} sec.")
                if self.thread_run.stopped():
                    self.gera_log("Vai encerrar a thread.")
                    break
            if bool(self.chkTrocar.get()):
                if not self.troca_personagem():
                    self.gera_log("Não deu certo, pra trocar o personagem.")

    def teste(self):
        # while True:
        #     if self.thread_teste.stopped():
        #         return
        self.f.ativa()
        self.f.espera_random()
        start_time = time.time()

        self.troca_personagem()

        print(f"Teste: {time.time() - start_time} segundos") 


    def show_screen_action(self):
            self.screen_agent.enable_cv_preview.value = not self.screen_agent.enable_cv_preview.value

    def on_closing(self):
        if self.thread_run is not None and self.thread_run.is_alive():
            self.thread_run.stop(self.optConta)
            print(f"A {self.thread_run.name} está ativa, tente depois. (COMO RESOLVER ISSO?)")
            return
        if self.thread_teste is not None and self.thread_teste.is_alive():
            self.thread_teste.stop(self.optConta)
            print(f"A {self.thread_teste.name} de Teste está ativa, tente depois. (COMO RESOLVER ISSO?)")
            return
        # Exibe uma caixa de diálogo perguntando se deseja fechar
        if self.screen_agent.capture_process is not None:
                self.screen_agent.capture_process.terminate()
                self.screen_agent.capture_process = None
        self.save_settings()
        print("Fechando a GUI...")
        self.root.destroy()
        sys.exit()


    def gera_log(self, mensagem):
        self.f.gera_log(f"{self.optConta.get()} - {mensagem}")

    def last_screen(self, timeout=5000):
        screen = None
        if self.screen_agent.capture_process is not None:
            screen = self.screen_agent.queue.get()
        return screen
        
    def read_img_file(self, file):
        # Verifica se a imagem já está no cache
        if file in self.image_cache:
            return self.image_cache[file]

        # Carrega a imagem do disco se ela existir
        img_path = f'{self.diretorio_atual}\\imgs\\{file}.png'
        if os.path.exists(img_path):
            file_img = cv.imread(img_path, cv.IMREAD_GRAYSCALE)
            self.image_cache[file] = file_img  # Armazena a imagem no cache
        else:
            file_img = None
        
        return file_img
            
    def match_imgs(self, img, nomeimg, precision, ret, ignora_cords):       
        
        tela = self.last_screen()

        deslocamento_y_inferior = 100
        deslocamento_y_superior = 30
        deslocamento_x_inferior = 50
        deslocamento_x_superior = 45

        if ret is not None:
            x, y = ret[0], ret[1]
            tela = tela[y-deslocamento_y_inferior:y+deslocamento_y_superior, x-deslocamento_x_inferior:x+deslocamento_x_superior]           

        if ignora_cords:
            for cord in ignora_cords:
                x, y = cord[0], cord[1]

                numero_de_linhas = (y + deslocamento_y_superior) - (y - deslocamento_y_inferior)
                numero_de_colunas = (x + deslocamento_x_superior) - (x - deslocamento_x_inferior)
                
                tela[y-deslocamento_y_inferior:y+deslocamento_y_superior, x-deslocamento_x_inferior:x+deslocamento_x_superior] = np.zeros((numero_de_linhas, numero_de_colunas), dtype=np.uint8)
        try:
            match = cv.matchTemplate(tela, img, cv.TM_CCOEFF_NORMED)
        except:
            return None

        min_val, max_val, min_loc, max_loc = cv.minMaxLoc(match)
        top_left = max_loc
        bottom_right = (top_left[0] + 30, top_left[1] + 30)

        if self.chkVisaoPC.get():
            data_atual = datetime.now()
            data_formatada = data_atual.strftime('%H%M%S.%f')
            # Formatar a data e hora
            telabkp = tela
            tela = match
            if self.screen_agent.enable_cv_preview.value:
                cv.putText(
                tela, 
                f"{nomeimg}: {"{:.2f}".format(max_val)}", 
                (top_left[0]-15, top_left[1]-20), 
                cv.FONT_HERSHEY_DUPLEX,
                1,
                (255, 0, 255),
                1,
                cv.LINE_AA)
                # cv.rectangle(tela, (top_left[0]-15, top_left[1]-15), bottom_right, (255, 0, 0), 2)
                # self.screen_agent.queueProcess.put(tela)
                cv.rectangle(match, (top_left[0]-15, top_left[1]-15), bottom_right, (255, 0, 0), 2)
                self.screen_agent.queueProcess.put(match)
                # cv.imwrite(f'{self.diretorio_atual}\\imgs\\matchs\\{data_formatada} {nomeimg} {max_val}.png', telabkp)
                # cv.imwrite(f'{self.diretorio_atual}\\imgs\\matchs\\{data_formatada} {nomeimg}match {max_val}.png', match)

        if max_val > precision:
            # data_atual = datetime.now()
            # # Formatar a data e hora
            # data_formatada = data_atual.strftime('%H%M%S.%f')
            # cv.rectangle(tela, (top_left[0]-15, top_left[1]-15), bottom_right, (255, 0, 0), 2)
            # cv.imwrite(f'{self.diretorio_atual}\\imgs\\matchs\\{data_formatada} {nomeimg} {max_val}.png', tela)
            if self.screen_agent.enable_cv_preview.value:
                cv.putText(
                tela, 
                f"P: {"{:.2f}".format(max_val)}", 
                (top_left[0]-15, top_left[1]-20), 
                cv.FONT_HERSHEY_DUPLEX,
                1,
                (255, 0, 255),
                1,
                cv.LINE_AA)
                cv.rectangle(tela, (top_left[0]-15, top_left[1]-15), bottom_right, (255, 0, 0), 2)
                self.screen_agent.queueProcess.put(tela)
            h2, w2 = img.shape[:2]
            if ret is None:
                retornoX = round(top_left[0] + (w2/2))
                retornoY = round(top_left[1] + (h2/2))
            else:
                retornoX = round(top_left[0] + (w2/2)) + (x-50)
                retornoY = round(top_left[1] + (h2/2)) + (y-100)
            return (retornoX, retornoY)
        return None
    
    def procura_ate_achar(
                        self,
                        nomeimg,
                        timeout=3000,
                        interval=300,
                        precision = 0.90,
                        ret = None,
                        ignora_cords = []):
        img = self.read_img_file(nomeimg)

        if img is None:
            return None
        
        interval = interval / 1000
        start_time = time.time()
        while ((time.time() - start_time) * 1000) < timeout:
            self.verificaoEssencialLoop()

            cords = self.match_imgs(img, nomeimg, precision, ret, ignora_cords)
            time.sleep(interval)
            if cords:
                return cords
    
    def procura_ate_nao_achar(
                        self,
                        nomeimg,
                        timeout=3000,
                        interval=300,
                        precision = 0.90,
                        ret = None,
                        ignora_cords = []):
        self.f.ativa()

        img = self.read_img_file(nomeimg)
        if img is None:
            return None
        
        interval = interval / 1000
        start_time = time.time()
        while ((time.time() - start_time) * 1000) < timeout:
            self.verificaoEssencialLoop()
            cords = self.match_imgs(img, nomeimg, precision, ret, ignora_cords)
            if not cords:
                return None
            
            time.sleep(interval)
        return cords

    def procura_img(
                    self,
                    nomeimg,
                    precision = 0.90,
                    ret = None,
                    ignora_cords = []):
        
        img = self.read_img_file(nomeimg)
        cords = self.match_imgs(img, nomeimg, precision, ret, ignora_cords)
        return cords

    def place_holder(self):
        self.gera_log("Entrou no faz tropas")
        cords = self.procura_ate_achar("pan")
        if cords is not None:
            self.gera_log(f"Achou {cords}")
            self.f.clica_random(cords)
            self.f.espera_random()
            self.f.tecla("space")
            self.f.espera_random(1500)
            self.f.clica_random((934, 416), 100, janela=True)
        else:
            self.gera_log(f"Não achou.")
        self.gera_log(f"Terminou")
        pass
        

    def tropas(self):
        self.gera_log("Entrou no faz tropas")
        if not self.muda_view("cidade"):
            self.muda_view("cidade")
        for tipo in ["Inf", "Mag", "Cav", "Cel", "Arq"]:
            chk = getattr(self, f"chk{tipo}")
            if chk.get():
                nivel = int(getattr(self, f"t{tipo}").get())
                self.gera_log(f"Vai procurar o {tipo}T{nivel} pra coletar.")
                cords = self.procura_ate_achar(f"{tipo}{nivel}", precision=0.77)
                if cords is not None:
                    self.gera_log(f"Tinha o {tipo}T{nivel} pra coletar.")
                    self.f.clica_random(cords)
                    start_time = time.time()
                    cordsbkp = cords
                    cords = None
                    while ((time.time() - start_time) * 1000) < 3000:
                        if cords is not None:
                            break
                        self.f.clica_random((cordsbkp[0], cordsbkp[1]+70))
                        cords = self.procura_ate_achar(f"up", timeout=500, precision=0.75)
                        if cords is not None:
                            break
                        self.verificaoEssencialLoop()
                    if cords is None:
                        self.gera_log(f"Deu merda no {tipo}")
                        self.volta()
                        continue
                    self.f.clica_random((cords[0]+80, cords[1]-40))
                    cords = self.procura_ate_achar(f"train")
                    if cords is not None:
                        x = 238 + (74 * (nivel if tipo != "Cel" else nivel - 1))
                        y = 693
                        self.f.clica_random((x, y), janela=True)
                        self.f.espera_random()
                        self.f.clica_random(cords)
                        self.gera_log(f"Colocou pra treinar o {tipo}T{nivel}.")


    def muda_view(self, tipo):
        # self.gera_log(f"Mudando pra {tipo}")
        if tipo == "cidade":
            tipo1 = "mapa"
            tipo2 = "cidade"
        if tipo == "mapa":
            tipo1 = "cidade"
            tipo2 = "mapa"

        if tipo in ("cidade","mapa"):
            cords = self.procura_ate_achar(tipo1, timeout=500, interval=100)
            if cords is not None:
                return True
                self.gera_log(f"Estava no {tipo2}.")
                self.f.tecla("space")
                cords = self.procura_ate_achar(tipo2)
                if cords is not None:
                    self.f.espera_random()
                    self.f.tecla("space")
                    cords = self.procura_ate_achar(tipo1)
                    if cords is not None:
                        self.gera_log(f"Entrou no {tipo2}.")
                        return True
                    else: 
                        self.gera_log(f"Não conseguiu achar o {tipo1}")
                        return False
                else: 
                    self.gera_log(f"Não conseguiu achar o {tipo2}")
                    return False
            else:
                self.f.tecla("space")
                cords = self.procura_ate_achar(tipo1)
                # self.gera_log(f"Entrou no {tipo}.")
                return True
        return False
    
    def explore(self):
        if not self.chkExplorar.get():
            return
        self.gera_log("Entrou no explore.")
        cords = self.procura_ate_achar("scout", precision=0.8)
        while cords is not None:
            self.f.clica_random(cords)
            cords = self.procura_ate_achar("scope")
            if cords is not None:
                self.f.espera_random()
                self.f.tecla("a")
                cords = self.procura_ate_achar("explore")
                if cords is not None:
                    self.f.espera_random()
                    self.f.clica_random(cords)
                    self.gera_log(f"Colocou o Scout pra explorar!")
                    self.f.espera_random(1000)
            cords = self.procura_ate_achar("scout", precision=0.80)
        self.muda_view("cidade")


    def ajuda_alianca(self):
        cords = self.procura_ate_achar("ajuda", precision=0.8)
        if cords is not None:
            self.f.clica_random(cords)
            self.gera_log(f"Ajudou a aliança.")
        cords = self.procura_ate_achar("aliancaup", precision=0.6)
        if cords is not None:
            self.f.clica_random(cords)
            self.gera_log(f"Colocou predio pra upar.")

    
    def coleta_rss(self, heroi, tipo):
        cords = self.procura_ate_achar(heroi, precision=0.75)
        if cords is None:
            self.volta()
            self.gera_log(f"Vai colocar o {heroi} no {tipo}.")
            if self.busca_rss(tipo):
                cordsmarch = self.procura_ate_achar("march")
                if cordsmarch is not None:
                    menosred = self.procura_ate_achar("menosred")
                    if menosred is not None:
                        self.f.clica_random(menosred)
                        self.f.espera_random()
                    self.f.clica_random((475, 463), janela=True)
                    cords = self.procura_ate_achar(f"{heroi}2", timeout=5000, precision=0.80)
                    if cords is not None:
                        self.f.clica_random(cords)
                        self.f.espera_random(1000)
                        self.f.clica_random(cordsmarch)
                        return True
                    else:
                        self.gera_log("Não encontrou o heroi pra colocar.")
                        self.volta()
                        return False
                else:
                    self.gera_log("Não conseguiu abrir a janela pra colocar o heroi.")
            else:
                self.gera_log("Acabou as filas.")
                self.volta()
        return False

    def pedra(self):
        pass
    
    def ress_city(self):
        self.muda_view("cidade")
        cords = self.procura_ate_achar("madeiracity", timeout=100)
        if cords is not None:
            self.gera_log("Coletou a madeira da cidade.")
            self.f.clica_random(cords)
        cords = self.procura_ate_achar("goldcity", timeout=100)
        if cords is not None:
            self.gera_log("Coletou o gold da cidade.")
            self.f.clica_random(cords)
        cords = self.procura_ate_achar("pedracity", timeout=100)
        if cords is not None:
            self.gera_log("Coletou a pedra da cidade.")
            self.f.clica_random(cords)

    def verifica(self):
        self.f.ativa()
        self.confirm()
        self.explore()
        self.ajuda_alianca()
        self.tropas()
        self.ress_city()
        self.coleta_dinamica_v2()
        self.up_build()
        self.donate()
        self.skills()
        

        
    def volta(self):
        cords = self.procura_img("settings")
        while cords is None:
            self.f.ativa()
            self.f.tecla("esc")
            cords = self.procura_ate_achar("settings", timeout=3000)
        self.f.tecla("esc")
        self.muda_view("cidade")
        
        
    def descobre_vilas(self):
        self.f.ativa()
        cords = self.procura_ate_achar("visit", precision=0.85)
        if cords is not None:
            self.f.clica_random(cords)
            self.f.espera_random(1000)
            self.f.clica_random((675, 416), janela=True)
            self.f.espera_random(1000)
            cords = self.procura_ate_achar("opc")
            while cords is not None:
                self.f.clica_random(cords)
                self.f.espera_random()
                cords = self.procura_ate_achar("opc")
            
            cords = self.procura_ate_achar("claim")
            if cords is not None:
                self.f.clica_random(cords)
                cords = self.procura_ate_achar("go")
                if cords is not None:
                    self.f.clica_random(cords)
                    self.f.espera_random(10000)
                    self.f.clica_random((652, 420), janela=True)
                    self.descobre_vilas()
        cords = self.procura_ate_achar("supplies", precision=0.85)
        if cords is not None:
            cords = self.procura_ate_achar("go", precision=0.85)
            if cords is not None:
                self.f.clica_random(cords)
                self.f.espera_random(5000)
                self.f.clica_random((646, 430), janela=True)
        cords = self.procura_ate_achar("go")
        if cords is not None:
            if cords is not None:
                self.f.clica_random(cords)
                self.f.espera_random(10000)
                self.f.clica_random((652, 420), janela=True)
        cords = self.procura_ate_achar("bonus")
        if cords is not None:
            if cords is not None:
                self.f.clica_random(cords)
                        

    def coleta_dinamica(self):
        for rss in [TipoRss.Gold, TipoRss.Wood, TipoRss.Rock, TipoRss.Mana, TipoRss.Gema]:
            if bool(getattr(self, f"chk{rss.name}").get()):
                cont = 0
                for heroi in getattr(self.herois, f"{rss.name}"):
                    self.att_herois_em_uso()
                    for recurso in self.herois.herois_em_uso.values():
                        if recurso == rss.name:
                            cont += 1
                    if cont >= int(getattr(self, f"t{rss.name}").get()):
                        self.gera_log(f"{cont} herois coletando o {rss.name}")
                        break
                    if self.herois.herois_em_uso[heroi] is None and self.coleta_rss(heroi, rss.value):
                        self.herois.herois_em_uso[heroi] = rss.name
                        break

    def up_build(self):
        if not self.chkUpar.get():
            return
        self.muda_view("cidade")
        cords = self.procura_ate_achar("upbuild", timeout=1500)
        if cords is not None:
            self.gera_log("Vai colocar a build pra upar.")
            self.f.clica_random(cords)
            cords = self.procura_ate_achar("up", precision=0.85)
            if cords is not None:
                self.f.clica_random(cords)
                cords = self.procura_ate_achar("upgrade")
                if cords is not None:
                    self.f.clica_random(cords)
                    self.gera_log("Conseguiu colocar a build.")
                    cords = self.procura_ate_achar("aliancaup", precision=0.8)
                    while cords is not None:
                        self.f.clica_random(cords)
                        cords = self.procura_ate_achar("aliancaup", precision=0.8)


    def busca_rss(self, tipo):
        self.muda_view("mapa")
        if tipo != 5:
            self.f.tecla("f")
            cords = self.procura_ate_nao_achar("cidade")
            if cords is None:
                x = 350 + (150 * tipo)
                y = 778
                self.f.clica_random((x, y), janela=True, var=10, velo=100, clicks=5)
                cordssearch = self.procura_ate_achar("search")
                if cordssearch is not None:
                    if self.chkMaxRss.get():
                        mais = self.procura_ate_achar("mais")
                        if mais is not None:
                            for i in range(5):
                                self.f.clica_random(mais, var=0)
                        while True:
                            self.verificaoEssencialLoop()
                            menos = self.procura_ate_achar("menos")
                            if menos is not None:
                                self.f.clica_random(cordssearch)
                                self.f.espera_random()
                                self.f.move_mouse((644, 424), var=200, janela=True)
                                check = self.procura_ate_nao_achar("search", interval=100, timeout=1000)
                                if check is not None:
                                    self.f.clica_random(menos)
                                    continue
                                break
                    else:
                        menos = self.procura_ate_achar("menos")
                        if menos is not None:
                            self.f.espera_random()
                            for i in range(5):
                                self.f.clica_random(menos, var=0)
                            self.f.espera_random()
                            self.f.clica_random(cordssearch)
        else:
            self.procura_gema()

        start_time = time.time()
        while ((time.time() - start_time) * 1000) < 10000:
            self.f.clica_random((644, 424), janela=True)
            cords = self.procura_ate_achar(f"gather")
            if cords is not None:
                break
        if cords is None:
            self.gera_log("Falhou na tentativa de recurso.")
            self.volta()
            return
        self.f.espera_random()
        self.f.clica_random(cords)
        cords = self.procura_ate_achar("legion", precision=0.8)
        if cords is not None:
            self.f.clica_random(cords)
            cords = self.procura_ate_achar("march")
            if cords is not None:
                return True
            else:
                return False
        else:
            return False
        
    # b:1 d:1 c:2 e:2 b:3 d:2
    def anda_no_mapa(self, vez, step):
        if step == 1:
            for i in range(5*vez):
                self.f.tecla("up", tempo=self.f.rand_rand(700))
            for i in range(0,10*(vez+1)):
                self.f.tecla("down", tempo=self.f.rand_rand(700))
        if step == 2:
            for i in range(0,10*(vez+1)):
                self.f.tecla("right", tempo=self.f.rand_rand(700))
        if step == 3:
            for i in range(0,20*(vez+1)):
                self.f.tecla("up", tempo=self.f.rand_rand(700))
        if step == 4:
            for i in range(0,20*(vez+1)):
                self.f.tecla("left", tempo=self.f.rand_rand(700))
        if step == 5:
            for i in range(0,20*(vez+1)):
                self.f.tecla("down", tempo=self.f.rand_rand(700))
        if step == 6:
            for i in range(0,10*(vez+1)):
                self.f.tecla("right", tempo=self.f.rand_rand(700))


    def procura_gema(self):
        self.volta()
        self.f.tecla("space", "shift")
        cords = self.procura_ate_achar("arvore")
        if cords is not None:
            self.f.clica_random(cords)
            cordsbkp = None
            for vez in range(2):
                for step in range(7):
                    lista_cords = []
                    for gem in range(1, 3):
                        cordsbkp = self.procura_ate_achar(f"gemmap{gem}", timeout=600, precision=0.70, ignora_cords=lista_cords)
                        if cordsbkp is not None:
                            ocupado = False
                            for i in range(1, 5):
                                self.gera_log(f"vai procurar no ocup{i}")
                                cords = self.procura_ate_achar(f"ocup{i}", timeout=1000, precision=0.70, ret=cordsbkp)
                                if cords is not None:
                                    self.gera_log(f"Ocupado {i}")
                                    ocupado = True
                                    break
                            if ocupado:
                                lista_cords.append(cordsbkp)
                                cordsbkp = None
                                self.gera_log(f"Estava ocupado mesmo.")
                                break
                            else:
                                self.gera_log("Gema desocupada.")
                                break
                    if cordsbkp is not None:
                        self.gera_log(f"Achou gema no {cordsbkp}")                
                        self.f.clica_random(cordsbkp)
                        self.f.espera_random(5000)
                        return True
                    self.anda_no_mapa(vez, step)
                    self.f.espera_random()
            return True if cordsbkp else False
        

    def confirm(self):
        cords = self.procura_img("confirm", precision=0.8)
        if cords is not None:
            self.f.clica_random(cords)
            self.f.espera_random()
            for i in range(2):
                self.f.clica_random(cords)
            self.gera_log(f"Estava deslogado.")

    def verificaoEssencialLoop(self):
        self.f.ativa()
        self.confirm()

    def donate(self):
        if not self.esta_no_tempo("donate"):
            return
        self.f.clica_random((1093, 803), janela=True, velo=70)
        cords = self.procura_ate_achar("research", precision=0.8)
        if cords is not None:
            self.f.clica_random(cords)
            cords = self.procura_ate_achar("donate", precision=0.8)
            if cords is not None:
                for _ in range(11):
                    self.f.clica_random(cords)
            self.volta()

    def esta_no_tempo(self, func_name):
        agora = time.time()
        if func_name not in self.ultimos_tempos:
            self.ultimos_tempos[func_name] = agora
            return True

        if agora - self.ultimos_tempos[func_name] >= self.tempos[func_name]:
            self.ultimos_tempos[func_name] = agora
            return True
        return False
    
    def att_herois_em_uso(self):
        self.muda_view("cidade")
        for heroi, rss in self.herois.herois_em_uso.items():
            self.f.tecla("space")
            cords = self.procura_ate_achar(heroi, precision=0.75, timeout=1000)
            if cords is None:
                if rss is not None:
                    self.gera_log(f"{heroi} terminou de coletar o {rss}")
                self.herois.herois_em_uso[heroi] = None
            else:
                for i in range(3):
                    self.f.clica_random(cords, var=2)
                    if i == 0:
                        self.f.espera_random()
                    self.f.espera_random()
                self.f.espera_random(1000)
                cords = self.procura_ate_achar("rss_info", precision=0.8)
                if cords is not None:
                    for rss in [TipoRss.Gold, TipoRss.Wood, TipoRss.Rock, TipoRss.Mana, TipoRss.Gema]:
                        cords = self.procura_img(rss.name, precision=0.75)
                        if cords is not None:
                            self.herois.herois_em_uso[heroi] = rss.name
                            self.gera_log(f"{heroi} está ainda coletando o {rss.name}.")
                            break
                        self.herois.herois_em_uso[heroi] = "?"
                else:
                    self.gera_log(f"Provavelmente o {heroi} está andando.")
        self.gera_log(self.herois.herois_em_uso)

    def skills(self):
        for skill in self.herois.skills:
            cords = self.procura_img(skill, precision=0.75)
            if cords is not None:
                self.f.clica_random(cords)

    def coleta_dinamica_v2(self):
        self.att_herois_em_uso()
        for rss in [TipoRss.Gold, TipoRss.Wood, TipoRss.Rock, TipoRss.Mana, TipoRss.Gema]:
            if bool(getattr(self, f"chk{rss.name}").get()):
                cont = 0
                for recurso in self.herois.herois_em_uso.values():
                    if recurso == rss.name:
                        cont += 1
                if cont >= int(getattr(self, f"t{rss.name}").get()):
                    self.gera_log(f"{cont} herois coletando o {rss.name}")
                    continue
                for heroi in getattr(self.herois, f"{rss.name}"):
                    if cont >= int(getattr(self, f"t{rss.name}").get()):
                        self.gera_log(f"{cont} herois coletando o {rss.name}")
                        break
                    if self.herois.herois_em_uso[heroi] is None:
                        if self.coleta_rss(heroi, rss.value):
                            cont += 1
                            self.herois.herois_em_uso[heroi] = rss.name
                            self.gera_log(f"Conseguiu colocar o {heroi} no {rss.name}.")
                        else:
                            self.gera_log(f"Tentou colocar o {heroi}, mas não deu certo.")
                    else:
                        self.gera_log(f"iria colocar o {heroi}, mas ele estava coletando o {self.herois.herois_em_uso[heroi]}")
        self.gera_log(f"Atualizado: {self.herois.herois_em_uso}")


    def nome_arquivo_config(self):
        if "Z:" in self.diretorio_atual:
            return f"config1-{self.optConta.get()}.json"
        if "F:" in self.diretorio_atual:
            return f"config2-{self.optConta.get()}.json"
        return f"config-{self.optConta.get()}.json"
        
    def area_to_str(self):
        # Configurar o caminho para o executável do Tesseract no Windows
        # No Linux ou Mac, não é necessário
        pytesseract.pytesseract.tesseract_cmd = f"{self.diretorio_atual}\\Tesseract-OCR\\tesseract.exe"

        # Carregar a imagem usando OpenCV
        start_time = time.time()

        img = self.last_screen()

        print(f"last_screen: {time.time() - start_time} segundos") 

        start_time = time.time()

        texto_extraido = pytesseract.image_to_string(img)

        print(f"image_to_string: {time.time() - start_time} segundos") 

        match = re.search(r'Reserves\s+([\d,]+)', texto_extraido)

        if match:
            # Captura o número após "Reserves"
            resultado = match.group(1).strip()
            print(f'Trecho encontrado: {resultado}')
        else:
            print("A palavra 'Reserves' não foi encontrada.")


    def troca_personagem(self):
        self.gera_log("Inicia troca de personagem")
        if str(self.optConta.get()) == "1":
            self.optConta.set(2)
        else:
            self.optConta.set(1)
        self.load_settings()
        self.gera_log("Mudou as configurações")
        cords = self.procura_img("settings")
        while cords is None:
            self.f.ativa()
            self.f.tecla("esc")
            cords = self.procura_ate_achar("settings")
        self.f.clica_random(cords)
        cords = self.procura_ate_achar("account")
        if cords is not None:
            self.f.clica_random(cords)
            self.f.espera_random(2000)
            start_time1 = time.time()
            while ((time.time() - start_time1) * 1000) < 60000:
                cords = None
                if str(self.optConta.get()) == "1":
                    self.f.clica_random((390, 383), janela=True)
                else:
                    self.f.clica_random((948, 387), janela=True)
                interval = 0.1
                start_time = time.time()
                while ((time.time() - start_time) * 1000) < 3000:
                    time.sleep(interval)
                    cords = self.procura_img("confirm")
                    if cords is not None:
                        break
                if cords is not None:
                    break
            self.f.clica_random(cords)
            self.f.espera_random(5000)
            cords = self.procura_ate_achar("mapa", timeout=120000)
            if cords is not None:
                self.gera_log("Conseguiu trocar personagem com sucesso.")
                return True
            
        self.gera_log("Não conseguiu trocar de personagem")
        if str(self.optConta.get()) == "1":
            self.optConta.set(2)
        else:
            self.optConta.set(1)
        self.load_settings()
        self.gera_log("Voltou as configurações")
        return False