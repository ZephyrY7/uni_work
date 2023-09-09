import cv2
import torch
from tkinter import messagebox

#relocate the save pathway
def drawRectangles(image, dfResults):
    for index, row in dfResults.iterrows():
        image = cv2.rectangle(image, (row['xmin'].astype(int), row['ymin'].astype(int)), (row['xmax'].astype(int), row['ymax'].astype(int)), (255, 0, 0), 2)
        label = "%s%s%s" % ("Bend Leg: ", ((row['confidence']*100).astype(int)), "%")
        image = cv2.putText(image, label, (row['xmin'].astype(int), row['ymin'].astype(int)-10), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)    
    return image

model = torch.hub.load("./yolov5", 'custom', path = "./yolov5Models/bendleg_detection.pt", source = 'local')
# Capturing the video
#cap = cv2.VideoCapture("D:\\Onedrive\\OneDrive - Asia Pacific University\\APD3F2205TE\\Sem2\\Machine Vision & Intelligence\\Assignment MVI\\GROUP_GUI\\Videos\\bended_IC.avi")
model.conf = 0.3

def bd_yolo(self):
    try:
        if self.vid.isOpened():
            ret, result = self.vid.read()
            results = model(result)
            dfResults = results.pandas().xyxy[0]
            result=drawRectangles(result, dfResults[['xmin', 'ymin', 'xmax','ymax','confidence']].astype(float))
            return (ret, cv2.cvtColor(result, cv2.COLOR_BGR2RGB))
    except:
        #messagebox.showerror(title='Video Error', message='No bendleg in this video, try another video.')
        self.pause = True
        self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
        pass