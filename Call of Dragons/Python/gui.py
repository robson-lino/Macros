import tkinter as tk
from tkinter import ttk
from screencapture import ScreenCaptureAgent
import multiprocessing
import cv2 as cv
import os
import sys
from exceptions import *
import pyautogui
import time
import threading

from funcoes import *
from Herois import *
from Threads import *

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

            # Variáveis compartilhadas
            self.optConta1 = tk.IntVar(value=1)  # Inicializando com Conta1 selecionada
            self.chkExplorar = tk.BooleanVar(value=True)
            self.chkVisaoPC = tk.BooleanVar(value=False)
            self.chkEsperar = tk.BooleanVar(value=False)
            self.chkUpar = tk.BooleanVar(value=False)

            self.chkInf = tk.BooleanVar(value=True)
            self.chkMag = tk.BooleanVar(value=True)
            self.chkCav = tk.BooleanVar(value=True)
            self.chkCel = tk.BooleanVar(value=True)
            self.chkArq = tk.BooleanVar(value=True)

            self.tInf = tk.StringVar(value="1")
            self.tMag = tk.StringVar(value="1")
            self.tCav = tk.StringVar(value="1")
            self.tCel = tk.StringVar(value="1")
            self.tArq = tk.StringVar(value="1")

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



            # Montando a interface
            self._create_widgets()

            # Interceptar o fechamento da janela (clicar no X)
            self.root.protocol("WM_DELETE_WINDOW", self.on_closing)

            # Indica que a classe foi inicializada
            self.initialized = True

    def _create_widgets(self):
        # Radio buttons
        tk.Radiobutton(self.root, text="Conta1", variable=self.optConta1, value=1).place(x=24, y=8)
        tk.Radiobutton(self.root, text="Conta2", variable=self.optConta1, value=2).place(x=152, y=8)

        # Checkboxes e Dropdowns
        tk.Checkbutton(self.root, text="Explorar", variable=self.chkExplorar).place(x=250, y=8)
        tk.Checkbutton(self.root, text="Inf", variable=self.chkInf).place(x=24, y=40)
        tk.Checkbutton(self.root, text="Mag", variable=self.chkMag).place(x=74, y=40)
        tk.Checkbutton(self.root, text="Cav", variable=self.chkCav).place(x=124, y=40)
        tk.Checkbutton(self.root, text="Cel", variable=self.chkCel).place(x=174, y=40)
        tk.Checkbutton(self.root, text="Arq", variable=self.chkArq).place(x=224, y=40)

        ttk.Combobox(self.root, textvariable=self.tInf, values=["1", "2", "3", "4", "5"], width=3).place(x=24, y=63)
        ttk.Combobox(self.root, textvariable=self.tMag, values=["1", "2", "3", "4", "5"], width=3).place(x=74, y=63)
        ttk.Combobox(self.root, textvariable=self.tCav, values=["1", "2", "3", "4", "5"], width=3).place(x=124, y=63)
        ttk.Combobox(self.root, textvariable=self.tCel, values=["1", "2", "3", "4", "5"], width=3).place(x=174, y=63)
        ttk.Combobox(self.root, textvariable=self.tArq, values=["1", "2", "3", "4", "5"], width=3).place(x=224, y=63)

        tk.Checkbutton(self.root, text="Wood", variable=self.chkWood).place(x=24, y=93)
        tk.Checkbutton(self.root, text="Rock", variable=self.chkRock).place(x=74, y=93)
        tk.Checkbutton(self.root, text="Gold", variable=self.chkGold).place(x=124, y=93)
        tk.Checkbutton(self.root, text="Mana", variable=self.chkMana).place(x=174, y=93)
        tk.Checkbutton(self.root, text="Gema", variable=self.chkGema).place(x=224, y=93)

        ttk.Combobox(self.root, textvariable=self.tWood, values=["1", "2", "3", "4", "5"], width=3).place(x=24, y=118)
        ttk.Combobox(self.root, textvariable=self.tRock, values=["1", "2", "3", "4", "5"], width=3).place(x=74, y=118)
        ttk.Combobox(self.root, textvariable=self.tGold, values=["1", "2", "3", "4", "5"], width=3).place(x=124, y=118)
        ttk.Combobox(self.root, textvariable=self.tMana, values=["1", "2", "3", "4", "5"], width=3).place(x=174, y=118)
        ttk.Combobox(self.root, textvariable=self.tGema, values=["1", "2", "3", "4", "5"], width=3).place(x=224, y=118)

        # Botão Start
        tk.Button(self.root, text="Visualiza Screen", command=self.show_screen_action).place(x=23, y=146)
        tk.Checkbutton(self.root, text='', variable=self.chkVisaoPC, padx=0, pady=0, borderwidth=0).place(x=5, y=150)

        # Botão Restart
        tk.Button(self.root, text="Restart", command=self.restart_action).place(x=125, y=146)

        # Botão Start
        tk.Button(self.root, text="Start", command=self.start_action).place(x=23, y=176)
        tk.Checkbutton(self.root, text='', variable=self.chkEsperar, padx=0, pady=0, borderwidth=0).place(x=5, y=180)

        # Botão stop
        tk.Button(self.root, text="Stop", command=self.stop_action).place(x=80, y=176)

        # Botão teste
        tk.Button(self.root, text="Teste", command=self.teste_action).place(x=125, y=176)

        #Check upar
        tk.Checkbutton(self.root, text='Upar builds', variable=self.chkUpar, padx=0, pady=0, borderwidth=0).place(x=5, y=206)

    def stop_action(self):
        if self.thread_run is not None and self.thread_run.is_alive():
            self.thread_run.stop()
        if self.thread_teste is not None and self.thread_teste.is_alive():
            self.thread_teste.stop()
        if (self.screen_agent.capture_process is not None and
            (self.thread_run is None or (self.thread_run is not None and not self.thread_run.is_alive())) and
            (self.thread_teste is None or (self.thread_teste is not None and not self.thread_teste.is_alive()))):
            self.screen_agent.capture_process.terminate()
            self.screen_agent.capture_process = None

    def restart_action(self):
        if self.thread_run is not None and self.thr6ead_run.is_alive():
            self.thread_run.stop()
            print(f"A {self.thread_run.name} está ativa, tente depois. (COMO RESOLVER ISSO?)")
            return
        if self.thread_teste is not None and self.thread_teste.is_alive():
            self.thread_teste.stop()
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
        self.thread_run = StoppableThread(target=self.run, args=())
        self.thread_run.start()
        if self.thread_run.is_alive():
            self.f.gera_log(f"{self.thread_run.name} iniciada com sucesso.")
        
    def teste_action(self):
        self.thread_teste = StoppableThread(target=self.teste, args=())
        self.thread_teste.start()
        if self.thread_teste.is_alive():
            self.f.gera_log(f"{self.thread_teste.name} iniciada com sucesso.")
    
    def run(self):
        self.f.ativa()
        while True:
            if self.thread_run.stopped():
                self.f.gera_log("Vai encerrar a thread.")
                break
            self.verifica()
            count = 0
            start_time = time.time()
            start_time = time.time()
            while (time.time() - start_time) < 30 or bool(self.chkEsperar.get()):
                time.sleep(1)
                count += 1
                self.f.gera_log(f"Ja esperou por {count} segundos.")
                
                

    def teste(self):
        if self.thread_teste.stopped():
            return
        self.f.ativa()
        self.coleta_dinamica()
            


    def show_screen_action(self):
            self.screen_agent.enable_cv_preview.value = not self.screen_agent.enable_cv_preview.value

    def on_closing(self):
        if self.thread_run is not None and self.thread_run.is_alive():
            self.thread_run.stop()
            print(f"A {self.thread_run.name} está ativa, tente depois. (COMO RESOLVER ISSO?)")
            return
        if self.thread_teste is not None and self.thread_teste.is_alive():
            self.thread_teste.stop()
            print(f"A {self.thread_teste.name} de Teste está ativa, tente depois. (COMO RESOLVER ISSO?)")
            return
        # Exibe uma caixa de diálogo perguntando se deseja fechar
        if self.screen_agent.capture_process is not None:
                self.screen_agent.capture_process.terminate()
                self.screen_agent.capture_process = None
        
        print("Fechando a GUI...")
        self.root.destroy()
        sys.exit()

    def show(self):
        # Exibe a interface
        self.root.update() 
        self.root.pack_propagate(True)
        self.root.geometry("320x320")
        self.root.mainloop()

    def last_screen(self, timeout=5000):
        screen = None
        if self.screen_agent.capture_process is not None:
            screen = self.screen_agent.queue.get()
        return screen
        
    
    def read_img_file(self, file):
        if getattr(sys, 'frozen', False):
            # O programa está rodando em modo empacotado
            diretorio_atual = os.path.dirname(sys.executable)
        else:
            # O programa está rodando a partir do código fonte
            diretorio_atual = os.path.dirname(os.path.abspath(__file__))
        if os.path.exists(f'{diretorio_atual}\\imgs\\{file}.png'):
            file_img = cv.imread(f'{diretorio_atual}\\imgs\\{file}.png', cv.IMREAD_GRAYSCALE)
        else:
            file_img = None
        return file_img
            
    def match_imgs(self, img, nomeimg, precision):        
        tela = self.last_screen()

        match = cv.matchTemplate(tela, img, cv.TM_CCOEFF_NORMED)

        min_val, max_val, min_loc, max_loc = cv.minMaxLoc(match)
        top_left = max_loc
        bottom_right = (top_left[0] + 30, top_left[1] + 30)

        if self.chkVisaoPC.get():
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
                cv.rectangle(tela, (top_left[0]-15, top_left[1]-15), bottom_right, (255, 0, 0), 2)
                self.screen_agent.queueProcess.put(tela)
            # cv.rectangle(match, (top_left[0]-15, top_left[1]-15), bottom_right, (255, 0, 0), 2)
            # self.screen_agent.queueProcess.put(match)
            # cv.rectangle(tela, (top_left[0]-15, top_left[1]-15), bottom_right, (255, 0, 0), 2)
            # cv.imwrite(f'{diretorio_atual}\\imgs\\matchs\\{data_formatada} {nomeimg} {max_val}.png', tela)
        
        if max_val > precision:
            # if getattr(sys, 'frozen', False):
            #     # O programa está rodando em modo empacotado
            #     diretorio_atual = os.path.dirname(sys.executable)
            # else:
            #     # O programa está rodando a partir do código fonte
            #     diretorio_atual = os.path.dirname(os.path.abspath(__file__))
            # data_atual = datetime.now()
            # # Formatar a data e hora
            # data_formatada = data_atual.strftime('%H%M%S.%f')
            # cv.rectangle(tela, (top_left[0]-15, top_left[1]-15), bottom_right, (255, 0, 0), 2)
            # cv.imwrite(f'{diretorio_atual}\\imgs\\matchs\\{data_formatada} {nomeimg} {max_val}.png', tela)
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
            return (round(top_left[0]+ (h2/2)), round(top_left[1]+(w2/2)))
        return None
    
    def procura_ate_achar(self, nomeimg, timeout=3000, interval=300, precision = 0.90):
        self.f.ativa()
        interval = interval / 1000
        start_time = time.time()
        cords = None

        img = self.read_img_file(nomeimg)
        if img is None:
            return None
         
        while ((time.time() - start_time) * 1000) < timeout:

            cords = self.match_imgs(img, nomeimg, precision)
            if cords:
                time.sleep(interval)
                return cords
            time.sleep(interval)
        return cords
    
    def procura_ate_nao_achar(self, nomeimg, timeout=3000, interval=300, precision = 0.90):
        self.f.ativa()
        interval = interval / 1000
        start_time = time.time()
        cords = None

        img = self.read_img_file(nomeimg)
        if img is None:
            return None
         
        while ((time.time() - start_time) * 1000) < timeout:

            cords = self.match_imgs(img, nomeimg, precision)
            if not cords:
                return None
            
            time.sleep(interval)
        return cords

    def place_holder(self):
        self.f.gera_log("Entrou no faz tropas")
        cords = self.procura_ate_achar("pan")
        if cords is not None:
            self.f.gera_log(f"Achou {cords}")
            self.f.clica_random(cords)
            self.f.espera_random()
            self.f.tecla("space")
            self.f.espera_random(1500)
            self.f.clica_random((934, 416), 100, janela=True)
        else:
            self.f.gera_log(f"Não achou.")
        self.f.gera_log(f"Terminou")
        pass
        

    def tropas(self):
        self.f.gera_log("Entrou no faz tropas")
        if not self.muda_view("cidade"):
            self.muda_view("cidade")
        for tipo in ["Inf", "Mag", "Cav", "Cel", "Arq"]:
            chk = getattr(self, f"chk{tipo}")
            if chk.get():
                nivel = int(getattr(self, f"t{tipo}").get())
                cords = self.procura_ate_achar(f"{tipo}{nivel}", precision=0.77)
                if cords is not None:
                    self.f.gera_log(f"Tinha o {tipo}T{nivel} pra coletar.")
                    self.f.clica_random(cords)
                    start_time = time.time()
                    cordsbkp = cords
                    cords = None
                    while ((time.time() - start_time) * 1000) < 3000:
                        if cords is not None:
                            break
                        self.f.clica_random((cordsbkp[0], cordsbkp[1]+50))
                        cords = self.procura_ate_achar(f"up", timeout=500, precision=0.86)
                        if cords is not None:
                            break
                    if cords is None:
                        self.f.gera_log(f"Deu merda no {tipo}")
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
                        self.f.gera_log(f"Colocou pra treinar o {tipo}T{nivel}.")


    def muda_view(self, tipo):
        # self.f.gera_log(f"Mudando pra {tipo}")
        if tipo == "cidade":
            tipo1 = "mapa"
            tipo2 = "cidade"
        if tipo == "mapa":
            tipo1 = "cidade"
            tipo2 = "mapa"

        if tipo in ("cidade","mapa"):
            cords = self.procura_ate_achar(tipo1, timeout=1000)
            if cords is not None:
                return True
                self.f.gera_log(f"Estava no {tipo2}.")
                self.f.tecla("space")
                cords = self.procura_ate_achar(tipo2)
                if cords is not None:
                    self.f.espera_random()
                    self.f.tecla("space")
                    cords = self.procura_ate_achar(tipo1)
                    if cords is not None:
                        self.f.gera_log(f"Entrou no {tipo2}.")
                        return True
                    else: 
                        self.f.gera_log(f"Não conseguiu achar o {tipo1}")
                        return False
                else: 
                    self.f.gera_log(f"Não conseguiu achar o {tipo2}")
                    return False
            else:
                self.f.tecla("space")
                cords = self.procura_ate_achar(tipo1)
                # self.f.gera_log(f"Entrou no {tipo}.")
                return True
        return False
    
    def explore(self):
        if not self.chkExplorar.get():
            return
        self.f.gera_log("Entrou no explore.")
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
                    self.f.gera_log(f"Colocou o Scout pra explorar!")
                    self.f.espera_random(1000)
            cords = self.procura_ate_achar("scout", precision=0.80)
        self.muda_view("cidade")


    def ajuda_alianca(self):
        cords = self.procura_ate_achar("ajuda", precision=0.8)
        if cords is not None:
            self.f.clica_random(cords)
            self.f.gera_log(f"Ajudou a aliança.")
    
    def coleta_rss(self, heroi, tipo):
        self.volta()
        cords = self.procura_ate_achar(heroi, precision=0.75)
        if cords is None:
            self.f.gera_log(f"Vai colocar o {heroi} no {tipo}.")
            if self.busca_rss(tipo):
                cordsmarch = self.procura_ate_achar("march")
                if cordsmarch is not None:
                    menosred = self.procura_ate_achar("menosred")
                    if menosred is not None:
                        self.f.clica_random(menosred)
                        self.f.espera_random()
                    self.f.clica_random((475, 463), janela=True)
                    cords = self.procura_ate_achar(f"{heroi}2", timeout=5000)
                    if cords is not None:
                        self.f.clica_random(cords)
                        self.f.espera_random(1000)
                        self.f.clica_random(cordsmarch)
                        return True
                    else:
                        self.f.gera_log("Não encontrou o heroi pra colocar.")
                        self.volta()
                else:
                    self.f.gera_log("Não conseguiu abrir a janela pra colocar o heroi.")
            else:
                self.f.gera_log("Acabou as filas.")
                self.volta()

    def pedra(self):
        pass
    
    def ress_city(self):
        self.muda_view("cidade")
        cords = self.procura_ate_achar("madeiracity", timeout=100)
        if cords is not None:
            self.f.gera_log("Coletou a madeira da cidade.")
            self.f.clica_random(cords)
        cords = self.procura_ate_achar("goldcity", timeout=100)
        if cords is not None:
            self.f.gera_log("Coletou o gold da cidade.")
            self.f.clica_random(cords)
        cords = self.procura_ate_achar("pedracity", timeout=100)
        if cords is not None:
            self.f.gera_log("Coletou a pedra da cidade.")
            self.f.clica_random(cords)

    def verifica(self):
        self.f.ativa()
        self.explore()
        self.ajuda_alianca()
        self.tropas()
        self.ress_city()
        self.coleta_dinamica()
        self.up_build()
        

        
    def volta(self):
        cords = self.procura_ate_achar("settings", timeout=300)
        while cords is None:
            self.f.tecla("esc")
            self.f.espera_random()
            cords = self.procura_ate_achar("settings", timeout=300)
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
            if cords is not None:
                self.f.clica_random(cords)
                cords = self.procura_ate_achar("claim")
                if cords is not None:
                    self.f.clica_random(cords)
                    cords = self.procura_ate_achar("go")
                    if cords is not None:
                        self.f.clica_random(cords)
                        self.f.espera_random(10000)
                        self.f.clica_random((652, 420), janela=True)
                        self.descobre_vilas()
                            

    def coleta_dinamica(self):
        herois = Herois()
        for rss in [TipoRss.Gold, TipoRss.Wood, TipoRss.Rock, TipoRss.Mana, TipoRss.Gema]:
            if bool(getattr(self, f"chk{rss.name}").get()):
                cont = 0
                for heroi in getattr(herois, f"{rss.name}"):
                    if (self.coleta_rss(heroi, rss.value)):
                        cont += 1
                    if cont >= int(getattr(self, f"t{rss.name}").get()):
                        break
                    
    def up_build(self):
        if not self.chkUpar.get():
            return
        self.muda_view("cidade")
        cords = self.procura_ate_achar("upbuild", timeout=1500)
        if cords is not None:
            self.f.gera_log("Vai colocar a build pra upar.")
            self.f.clica_random(cords)
            cords = self.procura_ate_achar("up", precision=0.85)
            if cords is not None:
                self.f.clica_random(cords)
                cords = self.procura_ate_achar("upgrade")
                if cords is not None:
                    self.f.clica_random(cords)
                    self.f.gera_log("Conseguiu colocar a build.")
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
                self.f.clica_random((x, y), janela=True)
                self.f.espera_random(3000)
                cordssearch = self.procura_ate_achar("search")
                if cordssearch is not None:
                    cords = self.procura_ate_achar("menos")
                    if cords is not None:
                        for i in range(5):
                            self.f.clica_random(cords)
                    self.f.clica_random(cordssearch)
                    self.f.espera_random(5000)
        else:
            self.f.tecla("space", "shift")
            cords = self.procura_ate_achar("arvore")
            if cords is not None:
                self.f.clica_random(cords)
                self.f.espera_random(5000)
                cords = self.procura_ate_achar("gemmap", precision=0.7999)
                if cords is not None:
                    self.f.clica_random(cords)
                    self.f.espera_random(5000)
                else:
                    return False

        start_time = time.time()
        while ((time.time() - start_time) * 1000) < 10000:
            self.f.clica_random((644, 424), janela=True)
            cords = self.procura_ate_achar(f"gather")
            if cords is not None:
                break
        if cords is None:
            self.f.gera_log("Falhou na tentativa de recurso.")
            self.volta()
            return
        self.f.clica_random(cords)
        cords = self.procura_ate_achar("legion")
        if cords is not None:
            self.f.clica_random(cords)
            if self.procura_ate_achar("march") is not None:
                return True
        else:
            return False