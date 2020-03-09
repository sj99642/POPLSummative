#lang racket

; Below are the definitions for the procedures requested.
; Unlike in sections 1 and 3, these questions build on top of each other,
; so they cannot be separated out as easily.

(define (a-game number)
  ; the-game-number returns one of four procedures depending on its input.
  ; the-game-number will itself be returned, and will work as the player object. 
  (define (the-game-number request)
    ; I found the instructions unclear for `randomnum`. Just evaluating `random` gives
    ; an in-built procedure #<procedure:random>. Running that, (random), gives a random
    ; decimal between 0 and 1, which I have used here to create the number between 0 and 50.
    ; However, there is no need to pass it in as an argument.
    ; It also appears from the examples that the actual incrementing/decrementing of money is
    ; to be done separately, not automatically. 
    (define (randomnum)
      (define rand (round (+ (* (random) 48) 2)))
      (begin
        (printf "The random number is: ~a\n" rand)
        (printf "Game Player, your number is: ~a\n" number)
        (display "If your number is less than or equal the random number, you lose, otherwise you win.\n")
        (if (<= number rand)
            (display "Unfortunately, you have lost, Game Machine will deduct 2 pounds from your account\n")
            (display "Great, you have won, Game Machine will add one pound to in your account\n")
        )
      )
    )

    ; Increases the balance by 1
    (define (increasemoney)
      (begin
        (printf "Game Player, previously you had: ~a pounds\n" number)
        (set! number (+ number 1))
        (display "You have scored 1 point, and been awarded 1 pound by the Game Machine!\n")
        (printf "You now have: ~a pounds\n" number)
      )
    )

    ; Decreases the money in the player's account by 2. 
    (define (decreasemoney)
      (begin
        (printf "Game Player, previously you had: ~a pounds\n" number)
        (set! number (- number 2))
        (display "You have lost, Game Machine is deducating 2 pounds from your account\n")
        (printf "You now have: ~a pounds\n" number)
        (if (> number 1)
            (display "You still have enough credit to play.")
            (display "Sorry, you are out of credit, so you can't continue to play. To continue playing, you need to top-up.\nSee you soon!!!\n")
        )
      )
    )

    ; This tops up the account balance by the specified amount. Note that the question initially literally
    ; says to ake this argument the new balance, but later says that the argument is the amount the player wants
    ; to top-up by. I have taken the first interpretation, and the balance takes the value of the argument,
    ; since this seems to be the implication of the last example of Q5. 
    (define (topup t)
      (begin
        (set! number t)
        (printf "Game Player, you just topped up: ~a pound(s)\n" t)
        (if (or (> number 30) (< number 2))
            (display "Wrong, number/amount should be a minimum of 2 pounds and a maximum of 30 pounds\n")
            (printf "Great, you can play now\n")
        )
      )
    )
    ; Using a case statement to return the right procedure, or return an error if it is not recognised
    (case request
      ('randomnum randomnum)
      ('increasemoney increasemoney)
      ('decreasemoney decreasemoney)
      ('topup topup)
      (else (string-append "Unknown request " (symbol->string request)))
    ))
  ; Evaluated when a-game is run. If `number` is not between 2 and 30, this prints a message
  ; and returns nothing. Otherwise, it returns the-game-number so that the player object can be interacted with. 
  (if (or (> number 30) (< number 2))
      (display "Error: number is out of bounds (must be between 2 and 30)")
      (begin
        (printf "Game Player, you decide to go with number: ~a" number)
        the-game-number
        )
    )
  )

; Give a start value to the game machine
(define game_machine_amount 2)

(define (game_machine_decrement)
  (begin
    (printf "Game machine, before you has ~a pounds\n" game_machine_amount)
    (set! game_machine_amount (- game_machine_amount 2))
    (printf "You now have: ~a pounds\n" game_machine_amount)
    (if (> game_machine_amount 1)
        (display "Game Machine, there is still enough money in the machine for a game to be played\n")
        (display "Game Machine, there isn't any credit in the machine for a game to be played, needs to top up.\n")
    )
  )
)

; Increments the game machine amount, printing the values as it goes
(define (game_machine_increment)
  (begin
    (printf "Game Machine, before you had: ~a pounds\n" game_machine_amount)
    (set! game_machine_amount (+ game_machine_amount 1))
    (printf "You now have: ~a pounds" game_machine_amount)
  )
)

; Sample execution:

; > (define P1 (a-game 35))
; Error: number is out of bounds (must be between 2 and 30)
; > (define P1 (a-game 4))
; Game Player, you decide to go with number: 4
; > (define P2 (a-game 30))
; Game Player, you decide to go with number: 30
; > ((P1 'randomnumber))
; . . application: not a procedure;
;  expected a procedure that can be applied to arguments
;   given: "Unknown request randomnumber"
;   arguments...: [none]
; > ((P1 'randomnum))
; The random number is: 39.0Game Player, your number is: 4
; If your number is less than or equal the random number, you lose, otherwise you win.
; Unfortunately, you have lost, Game Machine will deduct 2 pounds from your account
; > ((P1 'decreasemoney))
; Game Player, previously you had: 4 pounds
; You have lost, Game Machine is deducating 2 pounds from your account
; You now have: 2 pounds
; You still have enough credit to play.
; > (define game_machine_amount 2)
; > game_machine_amount
; 2
; > (game_machine_increment)
; Game Machine, before you had: 2 pounds
; You now have: 3 pounds
; > ((P2 'randomnum))
; The random number is: 12.0Game Player, your number is: 30
; If your number is less than or equal the random number, you lose, otherwise you win.
; Great, you have won, Game Machine will add one pound to in your account
; > ((P2 'increasemoney))
; Game Player, previously you had: 30 pounds
; You have scored 1 point, and been awarded 1 pound by the Game Machine!
; You now have: 31 pounds
; > (game_machine_decrement)
; Game machine, before you has 3 pounds
; You now have: 1 pounds
; Game Machine, there isn't any credit in the machine for a game to be played, needs to top up.
; > (define game_machine_amount 15)
; > game_machine_amount
; 15
; > ((P1 'randomnum))
; The random number is: 22.0Game Player, your number is: 2
; If your number is less than or equal the random number, you lose, otherwise you win.
; Unfortunately, you have lost, Game Machine will deduct 2 pounds from your account
; > (game_machine_increment)
; Game Machine, before you had: 15 pounds
; You now have: 16 pounds
; > ((P1 'decreasemoney))
; Game Player, previously you had: 2 pounds
; You have lost, Game Machine is deducating 2 pounds from your account
; You now have: 0 pounds
; Sorry, you are out of credit, so you can't continue to play. To continue playing, you need to top-up.
; See you soon!!!
; > ((P1 'topup) 20)
; Game Player, you just topped up: 20 pound(s)
; Great, you can play now