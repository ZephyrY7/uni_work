import cv2
import numpy as np
from tkinter import messagebox

def image_process(ic):
        # Convert video to grayscale
        gray = cv2.cvtColor(ic, cv2.COLOR_BGR2GRAY)
        # Create a mask with adaptive threshold
        mask = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY_INV, 19, 5)
        # Find contours
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        objects_contours = []
        for cnt in contours:
            area = cv2.contourArea(cnt)
            if area > 2000:
                objects_contours.append(cnt)
        return objects_contours

# Load Aruco detector
arucoparam = cv2.aruco.DetectorParameters()
arucodict = cv2.aruco.getPredefinedDictionary(cv2.aruco.DICT_5X5_100)
#arucodict = cv2.aruco.Dictionary_get(cv2.aruco.DICT_5X5_100)

def ms(self):
    try:
        if self.vid.isOpened():
            ret, result = self.vid.read()
            corners, _, _ = cv2.aruco.detectMarkers(result, arucodict, parameters=arucoparam)
            # Draw polygon around the marker
            int_corners = np.intp(corners)
            cv2.polylines(result, int_corners, True, (0, 255, 0), 5)
            # Aruco Perimeter
            arucoperi = cv2.arcLength(corners[0], True)
            # Pixel to mm ratio
            pixel_mm_ratio = arucoperi / 40
            contour = image_process(result)
            # Draw ic boundaries
            for obj in contour:
                # Get rectangle shape
                rectangle = cv2.minAreaRect(obj)
                (x, y), (w, h), angle = rectangle
                # Get Width and Height of the ic
                ic_width = w / pixel_mm_ratio
                ic_height = h / pixel_mm_ratio
                # Display rectangle
                box = cv2.boxPoints(rectangle)
                box = np.intp(box)
                # Draw circle as midpoint of object
                cv2.circle(result, (int(x), int(y)), 8, (0, 0, 255), -1)
                # Draw lines around ic
                cv2.polylines(result, [box], True, (75,0,130), 4)
                # Write texts for measurements n units
                cv2.putText(result, "Width : {} mm".format(round(ic_width, 1)), (int(x - 100), int(y - 20)),
                            cv2.FONT_HERSHEY_PLAIN, 2, (0, 0, 300), 3)
                cv2.putText(result, "Height : {} mm".format(round(ic_height, 1)), (int(x - 100), int(y + 15)),
                            cv2.FONT_HERSHEY_PLAIN, 2, (255,185,15), 3)
                cv2.putText(result,'IC Measurement',(30,60),cv2.FONT_HERSHEY_PLAIN,4,(0,0,0),2,cv2.LINE_AA)
                # Draw Line under Title
            result = cv2.line(result, (560,65), (30,65), (0, 0, 0), 2)
                # Using resizeWindow()
            return (ret, cv2.cvtColor(result, cv2.COLOR_BGR2RGB))
    except:
        #messagebox.showerror(title='Video Error', message='No measurement in this video, try another video.')
        self.pause = True
        self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
        pass