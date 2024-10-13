from screencapture import ScreenCaptureAgent
from gui import Gui
from funcoes import *

def main():
    try:
        screen_agent = ScreenCaptureAgent()
        f = Funcoes()
        gui = Gui(screen_agent)
        gui.show()
    except Exception as e:
        print(f"Erro: {e}")
        input("Pressione Enter para fechar...")

if __name__ == "__main__":
    # Esconde o terminal
    # ctypes.windll.user32.ShowWindow(ctypes.windll.kernel32.GetConsoleWindow(), 0)
    main()