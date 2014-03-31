.MODEL SMALL
.CODE
START: ;见补充1
;调用10H号中断的9号功能在光标处输出5个红底白字的“Z”
MOV BH,0H ;见补充2
MOV AL,'Z'   ;要显示字符的ASCII码，同C语法一样可以用’Z’表示
MOV BL,47H ;属性，47H表示红底白字
MOV CX,5H   ;重复输出次数
MOV AH,9    ;第9号功能
INT   10H      ;10H号中断
JMP   $        ;见补充3
ORG 510       ;见补充4
DW   0AA55H ;见补充4
END START