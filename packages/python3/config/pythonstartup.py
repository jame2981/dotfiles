import atexit
import os
import readline
import rlcompleter
import sys

history_path = os.path.expanduser("~/.pyhistory")

def save_history(path=history_path):
    try:
        readline.write_history_file(path)
    except Exception:
        pass

try:
    if os.path.exists(history_path):
        readline.set_history_length(10000)
        readline.read_history_file(history_path)
except Exception:
    pass

atexit.register(save_history)
readline.parse_and_bind("tab: complete")

del os, atexit, readline, rlcompleter, save_history, history_path
