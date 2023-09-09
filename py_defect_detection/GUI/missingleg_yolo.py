import torch
import cv2
from tkinter import messagebox

def rectangle (frame,show_res):
    for indes, row in show_res.iterrows():
        frame = cv2.rectangle(frame, (row['xmin'].astype(int), row['ymin'].astype(int)), (row['xmax'].astype(int), row['ymax'].astype(int)), (255, 0, 0), 2)
        label = "%s%s%s" % ("Missing Leg: ", str((row['confidence']*100).astype(int)), "%")
        cv2.putText(frame, label, (row['xmin'].astype(int), row['ymin'].astype(int)-10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (36,255,12), 2)
    return frame

model = torch.hub.load("./yolov5", "custom", path = "./yolov5Models/missingleg_detection.pt", source="local")  # local repo
model.conf = 0.6

def msleg_yolo(self):
    try:
        if self.vid.isOpened():
            ret, result = self.vid.read()
            results = model(result)
            show_res = results.pandas().xyxy[0]
            result = rectangle(result, show_res[['xmin', 'ymin','xmax','ymax', 'confidence']].astype(float))
            return (ret, cv2.cvtColor(result, cv2.COLOR_BGR2RGB))
    except:
        #messagebox.showerror(title='Video Error', message='No missing leg found in this video, try another video.')
        self.pause = True
        self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
        pass