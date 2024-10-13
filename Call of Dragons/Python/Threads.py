import threading
from funcoes import *

class StoppableThread(threading.Thread):
    """Thread class with a stop() method. The thread itself has to check
    regularly for the stopped() condition."""

    def __init__(self, optConta, *args, **kwargs):
        super(StoppableThread, self).__init__(*args, **kwargs)
        self._stop_event = threading.Event()
        self.f = Funcoes()
        self.optConta = optConta

    def stop(self, optConta):
        self._stop_event.set()

    def stopped(self):
        return self._stop_event.is_set()
    
    def run(self):
        try:
            if self._target:
                self._target(*self._args, **self._kwargs)
        finally:
            self.f.gera_log(self.optConta, f"{self.name} encerrou.")