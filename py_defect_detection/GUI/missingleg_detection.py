import cv2
from tkinter import messagebox

def msleg_detection(self):
    try:
        if self.vid.isOpened():
            ret, result = self.vid.read()
            #grayscale frame
            gray = cv2.cvtColor(result, cv2.COLOR_BGR2GRAY)
            #blur frame
            blur = cv2.GaussianBlur(gray, (5, 5), 1)
            # threshold frame
            ret, thresh = cv2.threshold(blur, 100, 255, cv2.THRESH_BINARY_INV)
            # Find Contours
            contours, hierarchy = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
            count = 0
            for c in contours:
                # Find area for all contours
                area = cv2.contourArea(c)
                # Set area range to show contours hull
                if 250 < area < 2000:
                    x, y, w, h = cv2.boundingRect(c)
                    cv2.rectangle(result, (x, y), (x + w, y + h), (0, 0, 255), 2)
                    count += 1
            # find missing leg
            final = 14 - count
            string = "%s%s" % ("Missing Leg : ", final)
            string2 = "%s%s" % ("Total Remaining Leg : ", count)
            #Show missing leg
            cv2.putText(result, string, (30, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2,cv2.LINE_AA)
            #show remaining leg
            cv2.putText(result, string2, (30, 120), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2, cv2.LINE_AA)
            return (ret, cv2.cvtColor(result, cv2.COLOR_BGR2RGB))

    except:
        #messagebox.showerror(title='Video Error', message='No missing leg in this video, try another video.')
        self.pause = True
        self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
        pass
