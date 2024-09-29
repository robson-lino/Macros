import pyautogui
import os
import win32api
import win32gui
import os
import sys
from datetime import datetime
import time
import interception
from pynput import keyboard

interception.auto_capture_devices()

def capture():
    # Recupera a posição atual do mouse
    x, y = pyautogui.position()
    # Define a área de captura (15x15)
    region = (x - 7, y - 7, 15, 15)  # (x, y, largura, altura)
    print("MOVA!")
    time.sleep(1)
    # Tira o print da área especificada
    screenshot = pyautogui.screenshot(region=region)
    
    # Pergunta o nome do arquivo
    file_name = input("Qual é o nome do arquivo (sem extensão)? ")
    # Usando barras normais para o caminho
    file_path = os.path.join(os.getcwd(), f"imgs/{file_name}.png")
    
    # Salva a imagem
    screenshot.save(file_path)
    print(f"Screenshot salvo como {file_path}")


def gera_log(mensagem):
    if getattr(sys, 'frozen', False):
        # O programa está rodando em modo empacotado
        diretorio_atual = os.path.dirname(sys.executable)
    else:
        # O programa está rodando a partir do código fonte
        diretorio_atual = os.path.dirname(os.path.abspath(__file__))

        caminho_log = f"{diretorio_atual}\\codlog.log"
        try:
            with open(caminho_log, 'r') as file:
                # Lê o conteúdo existente
                content = file.readlines()
        except FileNotFoundError:
            content = []
        data_atual = datetime.now()

        # Formatar a data e hora
        data_formatada = data_atual.strftime('%H:%M:%S %d/%m/%Y')

        # Adiciona a nova mensagem no topo
        content.insert(0, f'{data_formatada} - {mensagem}\n')

        # Escreve o conteúdo atualizado de volta no arquivo
        with open(caminho_log, 'w') as file:
            file.writelines(content)

def get_mouse_position_relative_to_window():
        
    # Pega a janela ativa
    hwnd = win32gui.GetForegroundWindow()

    # Pega a posição global do mouse
    x, y = interception.mouse_position()
    
    # Pega as coordenadas da janela ativa
    rect = win32gui.GetWindowRect(hwnd)
    window_x, window_y = rect[0], rect[1]

    # Calcula a posição do mouse relativa à janela1111111111
    relative_x = x - window_x
    relative_y = y - window_y

    gera_log(f"{relative_x}, {relative_y}")


print("Pressione 1 para tirar um print. Aperte ESC para sair.")
print("Pressione 2 para capturar a posição em relacão a janela. Aperte ESC para sair.")


def on_activate_1():
    capture()

def on_activate_2():
    get_mouse_position_relative_to_window()

# Definindo as teclas de atalho
hotkeys = {
    '1': on_activate_1,
    '2': on_activate_2
}

# Listener para pressionamentos de tecla
def on_press(key):
    try:
        if key.char in hotkeys:  # Verifica se a tecla pressionada está nas hotkeys
            hotkeys[key.char]()
    except AttributeError:
        # Se a tecla pressionada não for uma letra (ex: Shift, Ctrl), ignoramos
        pass

def on_release(key):
    pass

# Inicia o listener de teclado
with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()