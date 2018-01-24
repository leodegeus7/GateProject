import subprocess
import time
import urllib
import RPi.GPIO as GPIO

def nfc_raw():
        lines=subprocess.check_output("/usr/bin/nfc-poll", stderr=open('/dev/null','w'))
        return lines

def read_nfc():
        lines=nfc_raw()
        return lines

try:
        while True:
                myLines=read_nfc()
                buffer=[]
                for line in myLines.splitlines():
                        line_content=line.split()
                        if(not line_content[0] =='UID'):
                                pass
                        else:
                                buffer.append(line_content)
                                
                str=buffer[0]
                id_str=str[2]+str[3]+str[4]+str[5]
                print (id_str)
                if len(id_str) > 0:
                        content = urllib.urlopen("http://172.20.10.2:8000/api/tasks/" + id_str).read()
                        print(content)
                


except KeyboardInterrupt:
        p.stop()
        GPIO.cleanup()