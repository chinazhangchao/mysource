.MODEL SMALL
.CODE
START: ;������1
;����10H���жϵ�9�Ź����ڹ�괦���5����װ��ֵġ�Z��
MOV BH,0H ;������2
MOV AL,'Z'   ;Ҫ��ʾ�ַ���ASCII�룬ͬC�﷨һ�������á�Z����ʾ
MOV BL,47H ;���ԣ�47H��ʾ��װ���
MOV CX,5H   ;�ظ��������
MOV AH,9    ;��9�Ź���
INT   10H      ;10H���ж�
JMP   $        ;������3
ORG 510       ;������4
DW   0AA55H ;������4
END START