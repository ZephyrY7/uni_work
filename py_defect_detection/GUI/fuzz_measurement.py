import cv2
import numpy as np
import skfuzzy as fuzz
from skfuzzy import control as ctrl
import matplotlib.pyplot as plt
from tkinter import messagebox

# Define fuzzy variables
ic_width = ctrl.Antecedent(np.arange(0, 160, 10), 'ic_width')
ic_length = ctrl.Antecedent(np.arange(0, 160, 10), 'ic_length')
ic_size = ctrl.Consequent(np.arange(0, 160,10), 'ic_size')

# Define fuzzy membership functions
ic_width['small'] = fuzz.trimf(ic_width.universe, [0, 0, 50])
ic_width['medium'] = fuzz.trimf(ic_width.universe, [0,50, 100])
ic_width['large'] = fuzz.trimf(ic_width.universe, [50, 100, 150])

ic_length['small'] = fuzz.trimf(ic_length.universe, [0, 0, 50])
ic_length['medium'] = fuzz.trimf(ic_length.universe, [0, 50, 100])
ic_length['large'] = fuzz.trimf(ic_length.universe, [50, 100, 150])

ic_size['small'] = fuzz.trimf(ic_size.universe, [0, 0, 50])
ic_size['medium'] = fuzz.trimf(ic_size.universe, [0, 50, 100])
ic_size['large'] = fuzz.trimf(ic_size.universe, [50,100, 150])

#ic_size.view()
#plt.title('IC Size')
#plt.show()
# Define fuzzy rules
rule1 = ctrl.Rule(ic_width['small'] & ic_length['small'], ic_size['small'])
rule2 = ctrl.Rule(ic_width['medium'] & ic_length['medium'], ic_size['medium'])
rule3 = ctrl.Rule(ic_width['large'] & ic_length['large'], ic_size['large'])
# Create control system
ic_measurement_ctrl = ctrl.ControlSystem([rule1, rule2, rule3])
# Create control system simulation
ic_measurement = ctrl.ControlSystemSimulation(ic_measurement_ctrl)

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

def ms_fuzz(self):
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
                (x, y), (w, l), angle = rectangle
                # Get Width and Height of the ic
                ic_width_value = w / pixel_mm_ratio
                ic_length_value = l / pixel_mm_ratio
                # Pass values to control system
                ic_measurement.input['ic_width'] = ic_width_value
                ic_measurement.input['ic_length'] = ic_length_value
                # Calculate size
                ic_measurement.compute()
                ic_size_ratio=round(ic_measurement.output['ic_size'])
                ic_sizes = ''
                if ic_size_ratio==48:
                    ic_sizes = ", large"
                elif ic_size_ratio>31:
                    ic_sizes = ", medium"
                elif ic_size_ratio ==31:
                    ic_sizes = ", small"
                # Display rectangle
                box = cv2.boxPoints(rectangle)
                box = np.intp(box)
                # Draw circle as midpoint of object
                cv2.circle(result, (int(x), int(y)), 8, (0, 0, 255), -1)
                # Draw lines around ic
                cv2.polylines(result, [box], True, (75,0,130), 4)
                # Write texts for measurements n units
                cv2.putText(result, "Width : {} mm".format(round(ic_width_value, 1)), (int(x - 100), int(y - 20)),
                            cv2.FONT_HERSHEY_PLAIN, 2, (0, 0, 300), 3)
                cv2.putText(result, "Length : {} mm".format(round(ic_length_value, 1)), (int(x - 100), int(y + 20)),
                            cv2.FONT_HERSHEY_PLAIN, 2, (255,185,15), 3)
                cv2.putText(result, "Size : {}{}".format(round(ic_measurement.output['ic_size']),ic_sizes), (int(x - 100), int(y + 60)),cv2.FONT_HERSHEY_PLAIN, 2, (0, 255, 0), 3)
                cv2.putText(result,'IC Measurement using Fuzzy Logic',(30,60),cv2.FONT_HERSHEY_PLAIN,4,(0,0,0),2,cv2.LINE_AA)
                # Draw Line under Title
                result = cv2.line(result, (1200,75), (30,75), (0, 0, 0), 2)
            return (ret, cv2.cvtColor(result, cv2.COLOR_BGR2RGB))
    except:
        messagebox.showerror(title='Video Error', message='No aruco marker in this video, try another video.')
        self.pause = True
        self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
        pass