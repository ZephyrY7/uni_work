from tkinter import *
from tkinter import filedialog
from tkinter import messagebox
import tkinter.font as font
import cv2
import PIL.Image, PIL.ImageTk
import time

class App:
    def __init__(self, window, title):
        # configure main app window
        self.window = window
        self.window.title(title)
        self.window.config(bg = '#2e3340')
        # create video player window
        top_frame = Frame(self.window, bg = '#2e3340')
        top_frame.pack(side = 'top')
        # create bottom panels for buttons z
        bottom_frame = Frame(self.window, bg = '#2e3340')
        bottom_frame.pack(side = 'bottom')
        #create window canvas
        self.canvas = Canvas(top_frame)
        self.canvas.config(bg = '#2E3340', highlightthickness = 5, highlightbackground = '#4C566A')
        self.canvas.pack()
        # create default font
        dfont = font.Font(family = 'Jetbrains Mono Semibold')
        # create UI get file button
        self.btn_UIget = Button(bottom_frame, text = "Upload Video", width = 15, height = 2, font = dfont, command = self.UIgetfile, bg = '#3B4252', fg = '#E5E9F0', activebackground = '#D8DEE9')
        # create pause button
        self.btn_pausevid = Button(bottom_frame, text = "Play", width = 15, height = 2, font = dfont, command = self.pausevid, bg = '#A3BE8C', fg = '#E5E9F0', activebackground = '#D8DEE9')
        # create snapshot button
        self.btn_snapshot = Button(bottom_frame, text = "Screenshot", width = 15, height = 2, font = dfont, command = self.snapshot, bg = '#3B4252', fg = '#E5E9F0', activebackground = '#D8DEE9')
        # create exit button
        self.btn_exit = Button(bottom_frame, text = "Exit", width = 15, height = 2, font = dfont, command = exit, bg = '#BF616A', fg = '#E5E9F0', activebackground = '#D8DEE9')
        # create toggle button for AI toggling
        self.btn_togAI = Button(bottom_frame, text = "AI Disabled", command = self.chg_AIstate, width = 15, height = 1, font = dfont, bg = '#434C5E', fg = '#E5E9F0', activebackground = '#88C0D0', state = DISABLED)
        # create dropdown menu to select which defects to detect
        options = ["Original", "Missing Leg", "Bending Leg", "Scratches", "Measurement"]
        self.opt = StringVar(value = "Original")
        self.opt.set(options[0])
        self.drop_menu = OptionMenu(bottom_frame,  self.opt, *options, command = self.option)
        self.drop_menu.config(width = 12, height = 1, font = dfont, bg = '#3B4252', fg = '#E5E9F0', activebackground = '#D8DEE9', highlightthickness = 0)
        menu = self.window.nametowidget(self.drop_menu.menuname)
        menu.config(font = dfont, bg = '#434C5E', fg = '#E5E9F0', activebackground = '#D8DEE9')

        # Arrage position of UI
        self.btn_UIget.grid(column = 0, row = 2)
        self.btn_pausevid.grid(column = 1, row = 2)
        self.btn_snapshot.grid(column = 2, row = 2)
        self.btn_exit.grid(column = 3, row = 2)
        self.drop_menu.grid(column = 3, row = 0)
        self.btn_togAI.grid(column = 3, row = 1)

        # create flags
        self.pause = False
        self.AI = False
        # refresh every 1ms
        self.delay = 1
        # infinite loop of this application
        self.window.mainloop()
        
    def option(self, _):
        if self.opt.get() == "Original":
            self.btn_togAI.config(state = DISABLED, bg = '#434C5E', text = "AI Disabled")
            self.AI = False
        else:
            self.btn_togAI.config(state = NORMAL)

    def chg_AIstate(self):
        # toggle AI state
        if self.btn_togAI['text'] == "AI Disabled":
            self.btn_togAI.config(text = "AI Enabled", bg = '#81A1C1')
            self.AI = True
        elif self.btn_togAI['text'] == "AI Enabled":
            self.btn_togAI.config(text = "AI Disabled", bg = '#434C5E')
            self.AI = False

    def UIgetfile(self):
        # initialize pause flag
        self.pause = True
        self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
        # create file explorer dialogue to upload videos file from local
        self.vidname = filedialog.askopenfilename(initialdir = "./", title="Select video file", filetypes=(("AVI files", "*.avi"), ("MP4 files", "*.mp4"), ("WMV files", "*.wmv"), ("All files", "*.*")))
        if len(self.vidname) == 0:
            pass
        else:
            # capture videos
            self.vid = cv2.VideoCapture(self.vidname)
            # get video width and height
            self.vid_width = self.vid.get(cv2.CAP_PROP_FRAME_WIDTH)
            self.vid_height = self.vid.get(cv2.CAP_PROP_FRAME_HEIGHT)
            # resize canvas to fit video frames
            self.canvas.config(width = self.vid_width/2, height = self.vid_height/2)
        
    def ori_frame(self):
        # get original video without processing
        try:
            if self.vid.isOpened():
                ret, frame = self.vid.read()
                return (ret, cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
        except:
            messagebox.showerror(title='Video file not found', message='No video source.')
            self.pausevid()

    # import from tasks 1 & 2
    from scratch_detection import sc_detection          # surface scratches task 1
    from scratch_yolo import sc_yolo                    # surface scratches task 2
    from missingleg_detection import msleg_detection    # missing leg task 1
    from missingleg_yolo import msleg_yolo              # missing leg task 2
    from bendleg_detection import bdleg_detection       # bend leg task 1
    from bendleg_yolo import bd_yolo                    # bend leg task 2
    from measurement import ms                          # measurement task 1
    from fuzz_measurement import ms_fuzz                # measurement task 2

    def playvid(self):
        # run detection based on options
        if (self.opt.get() == "Scratches") & (str(self.AI) == "False"):
            ret, frame = self.sc_detection()
        elif ((self.opt.get() == "Scratches") & (str(self.AI) == "True")):
            ret, frame = self.sc_yolo()
        elif ((self.opt.get() == "Missing Leg") & (str(self.AI) == "False")):
            ret, frame = self.msleg_detection()
        elif ((self.opt.get() == "Missing Leg") & (str(self.AI) == "True")):
            ret, frame = self.msleg_yolo()
        elif ((self.opt.get() == "Bending Leg") & (str(self.AI) == "False")):
            ret, frame = self.bdleg_detection()
        elif ((self.opt.get() == "Bending Leg") & (str(self.AI) == "True")):
            ret, frame = self.bd_yolo()
        elif ((self.opt.get() == "Measurement") & (str(self.AI) == "False")):
            ret, frame = self.ms()
        elif ((self.opt.get() == "Measurement") & (str(self.AI) == "True")):
            ret, frame = self.ms_fuzz()
        else:
            # show original video if no options 
            ret, frame = self.ori_frame()
        if ret:
            # resize frame to 50%
            self.frame = cv2.resize(frame, (int(frame.shape[1]/2), int(frame.shape[0]/2)), interpolation = cv2.INTER_AREA)
            # convert cv2 to tk format images
            self.img = PIL.ImageTk.PhotoImage(image = PIL.Image.fromarray(self.frame))
            self.canvas.create_image(0, 0, image = self.img, anchor = NW)
            # only play video continuously if pause flag is False
        if not self.pause:
            self.window.after(self.delay, self.playvid)

    # pause video by changing pause flag
    def pausevid(self):
        # toggle pause/resume button
        if self.btn_pausevid['text'] == "Pause":
            self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
            self.pause = True
        elif self.btn_pausevid['text'] == "Play":
            self.btn_pausevid.config(text = "Pause", bg = '#BF616A')
            self.pause = False
            self.playvid()

    # create snapshot and save picture
    def snapshot(self):
        self.pause = True
        self.btn_pausevid.config(text = "Play", bg = '#A3BE8C')
        savepath = filedialog.asksaveasfilename(initialdir = "./", initialfile = self.opt.get() + "-" + time.strftime("%d-%m-%Y-%H-%M-%S"), defaultextension = ".jpg")
        cv2.imwrite(str(savepath), cv2.cvtColor(self.frame, cv2.COLOR_BGR2RGB))

    # release video when exiting
    def __del__(self):
        if self.vid.isOpened():
            self.vid.release()

App(Tk(), "Detection of IC Defects")