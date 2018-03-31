import sys
import threading
import time


class Spinner:
    busy = False
    delay = 0.1
    text = ""
    reset_string = "\b"

    @staticmethod
    def spinning_cursor():
        while 1:
            for cursor in '|/-\\': yield cursor
            # for cursor in '': yield cursor

    def __init__(self, text="", delay=None):
        self.spinner_generator = self.spinning_cursor()
        if delay and float(delay): self.delay = delay
        if text:
            self.text = text
            self.reset_string = self.reset_string * (len(text) + 2)

    def spinner_task(self):
        while self.busy:
            sys.stdout.write("{} {}".format(next(self.spinner_generator), self.text))
            sys.stdout.flush()
            time.sleep(self.delay)
            sys.stdout.write(self.reset_string)
            sys.stdout.flush()

    def set_text(self, text):
        self.text = text
        self.reset_string = self.reset_string * (len(text) + 2)

    def start(self):
        self.busy = True
        threading.Thread(target=self.spinner_task).start()

    def stop(self):
        self.busy = False
        time.sleep(self.delay)


# spinner = Spinner("Loading...")
# spinner.start()
# # ... some long-running operations
# time.sleep(1)
# spinner.stop()
