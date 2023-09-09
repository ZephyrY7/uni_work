import cv2
from tkinter import messagebox
import numpy as np

def sc_detection(self):
    try:
        if self.vid.isOpened():
            # retreive video frames to frame1
            ret, result = self.vid.read()
            # print(frame,ret)
                # convert video to grayscale
            gray = cv2.cvtColor(result, cv2.COLOR_BGR2GRAY)
                # apply gaussian 
            blurred = cv2.GaussianBlur(gray, (25,25), cv2.BORDER_DEFAULT)
                # threshold the video to create masking of IC
            _, thresh = cv2.threshold(blurred, 45, 220, cv2.THRESH_BINARY)
                # detect edges from the thresholded videos
            edges = cv2.Canny(thresh, 0, 255)
            #cv2.imshow("canny", edges)
                # find contours from the edges and sort it 
            cnt = sorted(cv2.findContours(edges, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)[-2], key=cv2.contourArea)[-1]
                # create empty mask
            mask = np.zeros((1024, 1280), np.uint8)
                # draw contours on empty mask 
            masked = cv2.drawContours(mask, [cnt], -1, 255, -1)
            #cv2.imshow('masked', masked)
                # segment the videos of IC
            segmented = cv2.bitwise_and(gray, masked)
            #cv2.imshow('segmented', segmented)
            blurred = cv2.GaussianBlur(segmented, (3,3), cv2.BORDER_CONSTANT)
            #cv2.imshow('blurred', blurred)
            # threshold the segmented video
            _,thresh = cv2.threshold(blurred, 95, 255, cv2.THRESH_BINARY)
            # cv2.imshow("thresh", thresh)
                # apply morphology
            morph = cv2.dilate(thresh, np.ones((65,65), np.uint8))
            #cv2.imshow('dilate', morph)
                # find contours from dilated frames
            contours, _ = cv2.findContours(morph,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
            scratches = 0
            if contours:
                for c in contours:
                    x,y,w,h = cv2.boundingRect(c)
                    cv2.rectangle(result,(x,y),(x+w,y+h),(106,97,191),2)
                    scratches += 1
                    label = "%s%s" % ("Scratch ", scratches)
                    cv2.putText(result, label, (x, y-10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (112,135,208), 2)
                    detected = "%s%s" % (scratches, " Scratches Detected")
                cv2.putText(result, detected, (30, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, (106, 97, 191), 2, cv2.LINE_AA)
            else:
                cv2.putText(result, 'No Scratches Detected',(30, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, (106, 97, 191), 2, cv2.LINE_AA)
            return (ret, cv2.cvtColor(result, cv2.COLOR_BGR2RGB))
    except:
        #messagebox.showerror(title='Video Error', message='No Scratches in this video, try another video.')
        self.pause = True
        self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
        pass