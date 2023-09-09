import torch
import cv2


def labelling(image, dfResults):
    count = 0
    for index, row in dfResults.iterrows():
        #print(row)
        image = cv2.rectangle(image, (row['xmin'].astype(int), row['ymin'].astype(int)), (row['xmax'].astype(int), row['ymax'].astype(int)), (191,97,106), 2)
        perc = "%s%s%s" % ("Scratch: ", str((row['confidence']*100).astype(int)), "% CI")
        image = cv2.putText(image, perc, (row['xmin'].astype(int), row['ymin'].astype(int)-10), cv2.FONT_HERSHEY_SIMPLEX, 0.65, (208,135,112), 2)
        count += 1
    return image, count

path = <PATH>
videos = ([path + "perfect.avi", path + "blue.avi"])
model = torch.hub.load('./yolov5', 'custom', path = './Models/scratch_detection.pt', source = 'local')
#model.conf = 0.5

i = 0
while True:
    while i < len(videos):
        video = cv2.VideoCapture(videos[i])
        while (video.isOpened()):
            ret, result = video.read()
            if ret:
                #count = 0
                result = cv2.cvtColor(result, cv2.COLOR_BGR2RGB)
                predicted = model(result)
                boxregion = predicted.pandas().xyxy[0]
                #print(boxregion)
                result, count = labelling(result, boxregion[['xmin', 'ymin', 'xmax','ymax', 'confidence']].astype(float).round(4))
                result = cv2.cvtColor(result, cv2.COLOR_BGR2RGB)
                detected = "%s%s" % (count, " Scratches Detected")
                result = cv2.putText(result, detected, (30, 60), cv2.FONT_HERSHEY_SIMPLEX, 1, (106, 97, 191), 2, cv2.LINE_AA)
                cv2.imshow('prediction', result)

            if cv2.waitKey(1) == 27:
                break
        i += 1
    if cv2.waitKey(1) == 27:
        break
cv2.destroyAllWindows()
video.release()
