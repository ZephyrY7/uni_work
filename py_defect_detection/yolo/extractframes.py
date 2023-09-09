import cv2
import os

# set video file path of input video with name and extension
vid = cv2.VideoCapture(<PATH>)
path = "<PATH>"

if not os.path.exists(path):
    os.makedirs(path)

#for frame identity
index = 0
frames = 0
while(True):
    # Extract images
    ret, frame = vid.read()
    # end of frames
    if not ret: 
        break
    # Saves images
    name = path + 'image' + str(index) + '.jpg'
    
    if frames % 30 == 0:         # skip frames
        print ('Creating...' + name)
        cv2.imwrite(name, frame)
        index += 1

    # next frame
    frames +=1