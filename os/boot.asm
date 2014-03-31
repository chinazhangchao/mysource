assume cs:code
code segment
img:
	;ǿ�ƽ�cs:ip��Ϊ7c00:bootstart
	; mov ax,0
	; mov ds,ax
	; jmp dword ptr ds:[offset correctAddr+7c00h]
	;��ʾ��ʾ��Ϣ
; bootstart:
	mov ah,13h
	mov bh,0
	mov bl,1100b
	mov al,0
	mov si,cs
	mov es,si
	mov dh,6
	mov dl,6
	mov cx,offset tipend-offset tip	
	mov bp,offset tip+7c00h
	int 10h
	mov dh,7
	mov dl,6
	mov cx,offset c1end-offset tipend	
	mov bp,offset tipend+7c00h
	int 10h
	mov dh,8
	mov dl,6
	mov cx,offset c2end-offset c1end	
	mov bp,offset c1end+7c00h
	int 10h
;��ȡ��������
waitinput:
	mov ah,0
	int 16h
	call processinput
;�����������µȴ�����	
	jmp waitinput

table dw restartsub+7c00h,diskstartsub+7c00h,shutdownsub+7c00h
processinput:
	push bx
	cmp al,'1'
	jb proret
	cmp al,'3'
	ja proret
	mov bx,0
	mov bl,al
	sub bx,'1'
	add bx,bx
	call word ptr cs:[table[bx]+7c00h]
proret:
	pop bx
	ret
biosAddr:dw 0,0ffffh
restartsub:
	;��ʾ������ʾ��Ϣ
	mov ah,13h
	mov bh,0
	mov bl,1100b
	mov al,0
	mov si,cs
	mov es,si
	mov dh,12
	mov dl,6
	mov cx,offset restarttipend-offset restarttip	
	mov bp,offset restarttip+7c00h
	int 10h
	mov cx,0ff00h
s1: loop s1
	jmp dword ptr cs:[biosAddr+7c00h]
diskstartsub:
;����������ƶ���0:500h������������ִ��
	ret
;��ȡӲ�̵�һ�����������ݵ�0:7c00��������ת������ִ��
	; mov ah,2h
	; mov al,1
	; mov ch,0
	; mov cl,1
	; mov dh,0
	; mov dl,80h
	; mov si,0h
	; mov es,si
	; mov bx,7c00h
	; int 13h
	; jmp dword ptr initaddr
initaddr:dw 7c00h,0
diskstartsubend:
shutdownsub:
	MOV  AX,5301H
    MOV  BX,0
    INT  15H

tip: db 'Enter the number to continue'
tipend:
	db '1) restart pc'
c1end:	
	db '2) start system'
c2end:
restarttip:
	db 'Now restart system....'
restarttipend:	
; correctAddr: dw offset bootstart,7c00h
org 510
	dw 0aa55h
imgend:nop	

start:
	mov ah,3h
	mov al,1
	mov ch,0
	mov cl,1
	mov dh,0
	mov dl,0
	mov si,cs
	mov es,si
	mov bx,offset img
	int 13h
	mov ax,4c00h
	int 21h
code ends
end start