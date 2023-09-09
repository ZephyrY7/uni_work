import cv2
import numpy as np

path = <PATH>
videos = ([path + "perfect.avi", path + "scratch.avi"])
i = 0
while True:
    while i < len(videos):
        video = cv2.VideoCapture(videos[i])
        while (video.isOpened()):
                # retreive video frames to frame1
            ret, result = video.read()
            # print(frame,ret)
            if ret:
                    # convert video to grayscale
                gray = cv2.cvtColor(result, cv2.COLOR_BGR2GRAY)
                #cv2.imshow("grayed", gray)
                    # apply gaussian 
                blurred = cv2.GaussianBlur(gray, (25,25), cv2.BORDER_DEFAULT)
                #cv2.imshow("Blurred", blurred)
                    # threshold the video to create masking of IC
                _, thresh = cv2.threshold(blurred, 45, 255, cv2.THRESH_BINARY)
                #cv2.imshow("Threshold", thresh)
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
                #cv2.imshow("thresh", thresh)
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
                cv2.imshow('results', result)
            if cv2.waitKey(1) == 27:
                break
        i += 1
    if cv2.waitKey(1) == 27:
         break
cv2.destroyAllWindows()
video.release()
