.MODEL SMALL 
                org 100h
.DATA
    msg1        db 13,10,"Enter Player 1 Name: $"      
    msg2        db 13,10,"Enter Player 2 Name: $"
    msg3        db 13,10,"player 1 :Enter choice (H=Rock, P=Paper, S=Scissors): $"
    msg4        db 13,10,"player 2 :Enter choice (H=Rock, P=Paper, S=Scissors): $"
    winner_msg  db 13,10,"Winner is: $"
    msg_tie     db 13,10,"It's a TIE!$"
    pname1      db 21 dup(0)
    pname2      db 21 dup(0)
    choice1     db 0
    choice2     db 0
    welcome_msg db 13,10,"Welcome to Rock, Paper, Scissors!$"
    rps_pic     db 13,10
                db "    ROCK              PAPER           SCISSORS               ",13,10
                db "    ***              ********          *     *               ",13,10
                db "  *     *            *      *           *   *                ",13,10
                db " *       *           *      *            * *                 ",13,10
                db "  *     *            *      *           _ * _                ",13,10
                db "    ***              ********          (_) (_)               $",13,10
    menu1       db 13,10,"1. Start Game$"
    menu2       db 13,10,"2. Exit$"
    menu3       db 13,10,"3. Reset Scores$"
    invalid_choice_msg db 13,10,"Invalid choice! Please enter H, P, or S.$"
    invalid_menu_msg db 13,10,"Invalid option! Please enter 1, 2, or 3.$"
    score_msg   db 13,10,"Player1 Score: $"
    score_msg2  db "  Player2 Score: $"
    rounds_msg  db "  Rounds: $"
    auto_win_msg db 13,10,"Automatic Winner after 5 rounds: $"
    reset_msg   db 13,10,"Scores Reset!$"
    rock_art    db 13,10,"   ***   ",13,10," *     * ",13,10,"*       *",13,10," *     * ",13,10,"   ***   $"
    paper_art   db 13,10," ****** ",13,10,"*      *",13,10,"*      *",13,10,"*      *",13,10," ****** $"
    scissors_art db 13,10," *     * ",13,10,"  *   *  ",13,10,"   * *   ",13,10,"  _ * _  ",13,10," (_) (_) $"
    score1      dw 0
    score2      dw 0
    rounds      dw 0
       
.CODE
 

start:     
    mov  ax, @data
    mov  ds, ax
    
    lea  dx, welcome_msg
    mov  ah, 09h
    int  21h

    lea  dx, rps_pic
    mov  ah, 09h
    int  21h

Menu:
    lea  dx, menu1
    mov  ah, 09h
    int  21h

    lea  dx, menu2
    mov  ah, 09h
    int  21h

    lea  dx, menu3
    mov  ah, 09h
    int  21h

    mov  ah, 08h
    int  21h
    mov  dl, al
    mov  ah, 02h
    int  21h
    mov  al, dl

    cmp  al, '1'
    je   StartGame
    cmp  al, '2'
    je   Exit
    cmp  al, '3'
    je   ResetScores
    lea  dx, invalid_menu_msg
    mov  ah, 09h
    int  21h
    jmp  Menu

ResetScores:
    mov  score1, 0
    mov  score2, 0
    mov  rounds, 0
    lea  dx, reset_msg
    mov  ah, 09h
    int  21h
    jmp  Menu
   
StartGame: 
    lea  dx, msg1
    mov  ah, 09h
    int  21h
    lea  dx, pname1
    mov  cx, 20
    call ReadString

    lea  dx, msg2
    mov  ah, 09h
    int  21h
    lea  dx, pname2
    mov  cx, 20
    call ReadString

GetChoice1:
    lea  dx, msg3
    mov  ah, 09h
    int  21h
    call GetChar
    cmp  al, 'H'
    je   ValidChoice1
    cmp  al, 'P'
    je   ValidChoice1
    cmp  al, 'S'
    je   ValidChoice1
    lea  dx, invalid_choice_msg
    mov  ah, 09h
    int  21h
    jmp  GetChoice1
ValidChoice1:
    mov  choice1, al
    call DisplayArt

GetChoice2:
    lea  dx, msg4
    mov  ah, 09h
    int  21h
    call GetChar
    cmp  al, 'H'
    je   ValidChoice2
    cmp  al, 'P'
    je   ValidChoice2
    cmp  al, 'S'
    je   ValidChoice2
    lea  dx, invalid_choice_msg
    mov  ah, 09h
    int  21h
    jmp  GetChoice2
ValidChoice2:
    mov  choice2, al
    call DisplayArt

    mov  al, choice1
    mov  bl, choice2
    cmp  al, bl
    je   Tie

    cmp  al, 'H'
    jne  chk1
    cmp  bl, 'S'
    je   P1Wins
chk1:      
    cmp  al, 'S'
    jne  chk2
    cmp  bl, 'P'
    je   P1Wins
chk2:      
    cmp  al, 'P'
    jne  chk3
    cmp  bl, 'H'
    je   P1Wins
chk3:      
    jmp  P2Wins

P1Wins:    
    inc  score1
    lea  si, pname1
    jmp  ShowWinner
P2Wins:    
    inc  score2
    lea  si, pname2
    jmp  ShowWinner
Tie:       
    lea  dx, msg_tie
    mov  ah, 09h
    int  21h
    jmp  AfterRound

ShowWinner:
    inc  rounds
    call DisplayScores
    call AnimateWinner
    cmp  rounds, 5
    jne  AfterRound
    lea  dx, auto_win_msg                                                                                                            
    
    mov  ah, 09h
    int  21h
    mov  ax, score1
    cmp  ax, score2
    jg   P1AutoWin
    jl   P2AutoWin
    lea  dx, msg_tie
    mov  ah, 09h
    int  21h
    jmp  ResetAfterAuto
P1AutoWin:
    lea  si, pname1
    call AnimateWinner
    jmp  ResetAfterAuto
P2AutoWin:
    lea  si, pname2
    call AnimateWinner
ResetAfterAuto:
    mov  score1, 0
    mov  score2, 0
    mov  rounds, 0

AfterRound:
    jmp  Menu

Exit:      
    mov  ah, 4Ch
    int  21h

DisplayArt proc
    cmp  al, 'H'
    je   ShowRock
    cmp  al, 'P'
    je   ShowPaper
    cmp  al, 'S'
    je   ShowScissors
    ret
ShowRock:
    lea  dx, rock_art
    jmp  PrintArt
ShowPaper:
    lea  dx, paper_art
    jmp  PrintArt
ShowScissors:
    lea  dx, scissors_art
PrintArt:
    mov  ah, 09h
    int  21h
    ret
DisplayArt endp

DisplayScores proc
    lea  dx, score_msg
    mov  ah, 09h
    int  21h
    mov  ax, score1
    call PrintNumber
    lea  dx, score_msg2
    mov  ah, 09h
    int  21h
    mov  ax, score2
    call PrintNumber
    lea  dx, rounds_msg
    mov  ah, 09h
    int  21h
    mov  ax, rounds
    call PrintNumber
    ret
DisplayScores endp

PrintNumber proc
    push ax
    mov  bx, 10
    xor  cx, cx
    cmp  ax, 0
    jne  Convert
    mov  dl, '0'
    mov  ah, 02h
    int  21h
    pop  ax
    ret
Convert:
    xor  dx, dx
    div  bx
    push dx
    inc  cx
    test ax, ax
    jnz  Convert
PrintLoop:
    pop  dx
    add  dl, '0'
    mov  ah, 02h
    int  21h
    loop PrintLoop
    pop  ax
    ret
PrintNumber endp

AnimateWinner proc
   
    ; Print "Winner is:"
    lea dx, winner_msg
    mov ah, 09h
    int 21h

    ;------------------------------------
    ; Write winner name directly to video RAM
    ;------------------------------------

    mov ax, 0B800h
    mov es, ax
    mov di, (23* 160) + (35 * 2)  
    
print_loop:
    mov al, [si]
    cmp al, '$'
    je  DonePrinting
    mov ah, 02h
    mov es:[di], ax
    add di, 2
    inc si
    jmp print_loop

DonePrinting:
    ret   ; <-- ???? ????? ??? ShowWinner
AnimateWinner endp

ReadString proc
    push ax
    push cx
    push si
    mov  si, dx
    mov  bx, 0
read_loop: 
    mov  ah, 01h
    int  21h
    cmp  al, 13
    je   end_read
    cmp  bx, 20
    je   read_loop
    mov  [si + bx], al
    inc  bx
    loop read_loop
end_read:  
    mov  byte ptr [si + bx], '$'
    pop  si
    pop  cx
    pop  ax
    ret
ReadString endp

GetChar proc
    mov  ah, 08h
    int  21h
    ret
GetChar endp

end start