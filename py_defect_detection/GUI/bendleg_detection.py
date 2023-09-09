import cv2
import numpy as np
from tkinter import messagebox

checker = 0

def bdleg_detection(self):
    try:
        if self.vid.isOpened():
            ret, result = self.vid.read()
            SILVER_MIN = np.array([135,135,129], np.uint8)
            SILVER_MAX = np.array([220, 220, 220], np.uint8)

            kernel = np.ones((4, 4), np.float32) / 49
            kernel2 = np.ones((3,3), np.float32) / 49
            kernel3 = np.ones((5,4), np.float32) / 49

            frame_threshed = cv2.inRange(result, SILVER_MIN, SILVER_MAX)

            dilation = cv2.dilate(frame_threshed, kernel, iterations=1)
            erosion = cv2.erode(dilation, kernel2, iterations=4)
            dilation = cv2.dilate(erosion, kernel3, iterations=6)
            # comparing frame here
            # contour find here
            contours, _ = cv2.findContours(dilation, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
            number = 0
            for contour in contours:
                area = cv2.contourArea(contour)
                if area > 1500:
                    number += 1
                #if area >= 1400:
                    x, y, w, h = cv2.boundingRect(contour)
                    cv2.rectangle(result, (x, y), (x + w, y + h), (0, 0, 255), 2)
                #cv2.imshow('output.jpg', frame)
            if number >0:
                cv2.putText(result, str(number)+" Bend Leg Detected", (30, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2, cv2.LINE_AA)
            else:
                cv2.putText(result, str(number)+" Bend Leg Detected", (30, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2, cv2.LINE_AA)
            
            return (ret, cv2.cvtColor(result, cv2.COLOR_BGR2RGB))
        
    except:
        #messagebox.showerror(title='Video Error', message='No bendleg in this video, try another video.')
        self.pause = True
        self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
        pass
