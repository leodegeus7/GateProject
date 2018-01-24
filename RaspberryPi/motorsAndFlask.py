import subprocess
import time
import urllib2
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD)

GPIO.setup(12, GPIO.OUT)

p = GPIO.PWM(12, 50)
p.start(2.5)
def move_90():
        p.ChangeDutyCycle(2.5)  # turn towards 90 degree
        time.sleep(1) # sleep 1 second
        p.stop()
def move_0():
        p.ChangeDutyCycle(12.5)  # turn towards 90 degree
        time.sleep(1) # sleep 1 second

def move(number):
        p.ChangeDutyCycle(float(number))  # turn towards 90 degree
        time.sleep(1) # sleep 1 second

 #!/usr/bin/env python

from flask import Flask
app = Flask(__name__)

@app.route("/start")
def start():
        move_90();
        return "OK START"

@app.route("/stop")
def stop():
        move_0();
        return "OK STOP!"

@app.route("/movePos/<random>")
def movePos(random):
        move(random);
        return "ok"

if __name__ == "__main__":
   app.run("0.0.0.0",port=8080)