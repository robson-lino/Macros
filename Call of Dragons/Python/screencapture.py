import mss
import pyautogui
import cv2 as cv
import numpy as np
import time
import multiprocessing


class ScreenCaptureAgent:
    _instance = None  # Singleton instance
    
    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super(ScreenCaptureAgent, cls).__new__(cls)
        return cls._instance

    def __init__(self) -> None:
        if not hasattr(self, 'initialized'):  # Para evitar reinicializar
            self.img = None
            self.capture_process = None
            self.fps = None
            self.enable_cv_preview = multiprocessing.Value('b', False) 
            self.queue = multiprocessing.Queue()
            self.queueProcess = multiprocessing.Queue()

            self.w, self.h = pyautogui.size()
            print("Screen Resolution: " + "w: " + str(self.w) + " h:" + str(self.h))
            self.monitor = {"top": 0, "left": 0, "width": self.w, "height": self.h}

    def capture_screen(self):

        fps_report_time = time.time()
        fps_report_delay = 5
        n_frames = 1
        with mss.mss() as sct:
            while True:
                # Captura a imagem
                self.img = sct.grab(self.monitor)
                self.img = np.array(self.img)
                # Coloca a imagem em escala de cinza
                self.img = cv.cvtColor(self.img, cv.COLOR_RGBA2BGR)
                self.img = cv.cvtColor(self.img, cv.COLOR_BGR2GRAY)
                try:
                    while not self.queue.empty():
                        self.queue.get_nowait()  # Remove um item da fila sem bloquear
                except:
                    pass
                self.queue.put(self.img)
                processada = False

                if self.enable_cv_preview.value:
                    while not self.queueProcess.empty():
                        self.img = self.queueProcess.get()
                        processada = True
                    small = cv.resize(self.img, (0, 0), fx=0.5, fy=0.5)
                    if self.fps is None:
                        fps_text = ""
                    else:
                        fps_text = f'FPS: {self.fps:.2f}'
                    # cv.putText(
                        # small, 
                        # fps_text, 
                        # (25, 50), 
                        # cv.FONT_HERSHEY_DUPLEX,
                        # 1,
                        # (255, 0, 255),
                        # 1,
                        # cv.LINE_AA)
                    cv.imshow("Computer Vision", small)
                elif cv.getWindowProperty("Computer Vision", cv.WND_PROP_VISIBLE) >= 1:
                        cv.destroyWindow("Computer Vision")

                elapsed_time = time.time() - fps_report_time
                if elapsed_time >= fps_report_delay:
                    self.fps = n_frames / elapsed_time
                    fps_report_time = time.time()
                    n_frames = 1
                n_frames += 1
                cv.waitKey(500)
                #cv.waitKey(1)

