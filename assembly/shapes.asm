.model small
.stack 100h
.data
      msg1 db "**********",10,"Main Menu",10,"**********",10,"Select the shapes to print:",10,"1.Tree",10,"2.Apple",10,"3.Star",10,"4.Creeper",10,"5.Crown",10,"6.Exit",10,"$"
      msg2 db 10,"Please key in valid inputs (1 to 6) as shown in the menu!",10,"$"
      msg3 db 10,"Exiting...$"
      input db ?
.code
full MACRO length,type
    local L1
    mov dl,type
    mov cx,length
    L1:
        int 21h
    loop L1
    crlf
endm

middlespacing MACRO num,block,space,type
    local L1,L2,L3,L4
    mov bh,num
    L1:
    mov cx,block
    mov dl,type
    L2:
        int 21h
    loop L2
    cmp bh,0
    je L4
    mov cx,space
    mov dl,32
    L3:
        int 21h
    loop L3
    dec bh
    jmp L1
    L4:
        crlf 
endm 

twospacing MACRO outer,spacing,inner,type
    local L1,L2,L3,L4,L5,L6,L7
    mov bh,1
    mov bl,1
    L1:
        mov cx,outer
        mov dl,type
    L2:    
        int 21h
    loop L2
    cmp bl,0
    je L7
    L3:
    mov cx,spacing
    mov dl,32
    L4:
       int 21h
    loop L4
    cmp bh,0
    je L6
    mov cx,inner
    mov dl,type
    L5:
        int 21h
    loop L5
    dec bh
    jmp L3
    L6:
        dec bl
        jmp L1
    L7:
        crlf 
endm

crlf MACRO 
        mov ah,2
        mov dl,10
        int 21h
endm

MAIN PROC

    mov ax,@data
    mov ds,ax
start:
      crlf 
      mov ah,9
      lea dx,msg1
      int 21h
      mov ah,01h
      int 21h
      mov input,al
      mov ax,3
      int 10h
      mov ah,2
      mov dl,input
      int 21h
      crlf 
      cmp input,'1'
      je tree
      cmp input,'2'
      je apple
      cmp input,'3'
      je star
      cmp input,'4'
      je creeper
      cmp input,'5'
      je crown
      cmp input,'6'
      jne error
      je ending
      tree:
            call shape1
            jmp start
      apple:
            call shape2
            jmp start
      star:
            call shape3
            jmp start
      creeper:
            call shape4
            jmp start
      crown:
            call shape5
            jmp start
      error:
            call invalid
            jmp start
      ending:
            mov ah,9
            lea dx,msg3
            int 21h
            mov ah,4ch
            int 21h
MAIN endp

shape1 PROC
        mov ah,2
        full 7,219
        middlespacing 1,3,1,177
        mov cx,2    ; number of leaves to print
    leaves:
    push cx     ; save counter value
        middlespacing 1,2,3,177
        middlespacing 1,1,5,177
        pop cx
    loop leaves     ; loop macro for 2 times
    middlespacing 1,3,1,177
    full 7,219
    ret
shape1 endp

shape2 PROC
    mov ah,2
    middlespacing 1,14,1,254
    middlespacing 1,12,2,254
    middlespacing 1,11,2,254
    twospacing 5,4,3,254
    mov cx,3
    mid:
        push cx
        middlespacing 1,4,10,254
        pop cx
    loop mid
    middlespacing 1,5,11,254
    middlespacing 1,7,7,254
    full 19,254
    ret 
shape2 endp

shape3 PROC
    mov ah,2
    full 19,42
    middlespacing 1,9,1,42
    middlespacing 1,8,3,42
    middlespacing 1,7,5,42
    middlespacing 1,1,17,42
    middlespacing 1,3,13,42
    middlespacing 1,5,9,42
    middlespacing 1,4,11,42
    twospacing 3,5,3,42
    twospacing 2,3,9,42
    full 19,42
    ret
shape3 endp

shape4 PROC
    mov ah,2
    full 14,177
    mov cx,2
    eyes:
        push cx
        twospacing 1,4,4,177
        pop cx
    loop eyes
    middlespacing 1,5,4,177
    mov cx,2
    mouth:
        push cx
        middlespacing 1,3,8,177
        pop cx
    loop mouth
    twospacing 3,2,4,177
    ret
shape4 endp

shape5 PROC
    mov ah,2
    twospacing 1,6,1,42
    twospacing 2,4,3,42
    twospacing 3,2,5,42
    mov cx,2
    base:
        push cx
        full 15,177
        pop cx
    loop base
    ret
shape5 endp

invalid PROC
    mov ah,9
    lea dx,msg2
    int 21h
    ret
invalid endp

end main