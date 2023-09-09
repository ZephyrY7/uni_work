import torch
import cv2
from tkinter import messagebox

def labelling(image, dfResults):
    count = 0
    for index, row in dfResults.iterrows():
        #print(row)
        image = cv2.rectangle(image, (row['xmin'].astype(int), row['ymin'].astype(int)), (row['xmax'].astype(int), row['ymax'].astype(int)), (191,97,106), 2)
        perc = "%s%s%s" % ("Scratch: ", str((row['confidence']*100).astype(int)), "% CI")
        image = cv2.putText(image, perc, (row['xmin'].astype(int), row['ymin'].astype(int)-10), cv2.FONT_HERSHEY_SIMPLEX, 0.65, (208,135,112), 2)
        count += 1
    return image, count

model = torch.hub.load('./yolov5', 'custom', path = './yolov5Models/scratch_detection.pt', source = 'local')
#model.conf = 0.5

def sc_yolo(self):
    try:
        if self.vid.isOpened():
            ret, result = self.vid.read()
            result = cv2.cvtColor(result, cv2.COLOR_BGR2RGB)
            predicted = model(result)
            boxregion = predicted.pandas().xyxy[0]
            #print(boxregion)
            result, count = labelling(result, boxregion[['xmin', 'ymin', 'xmax','ymax', 'confidence']].astype(float).round(4))
            result = cv2.cvtColor(result, cv2.COLOR_BGR2RGB)
            detected = "%s%s" % (count, " Scratches Detected")
            result = cv2.putText(result, detected, (30, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, (106, 97, 191), 2, cv2.LINE_AA)
            return (ret, cv2.cvtColor(result, cv2.COLOR_BGR2RGB))
    except:
        #messagebox.showerror(title='Video Error', message='No scratches in this video, try another video.')
        self.pause = True
        self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
        pass