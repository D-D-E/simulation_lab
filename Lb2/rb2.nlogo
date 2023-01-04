breed [rabbits rabbit]
rabbits-own [ energy ]

breed [wolves wolf]
wolves-own [ feed-level ]

globals [score]

to setup
  clear-all
  set score 0
  grow-grass-and-weeds

  set-default-shape rabbits "rabbit"
  set-default-shape wolves "wolf"

  create-rabbits number [
    set color white
    setxy random-xcor random-ycor
    set energy random 10  ;start with a random amt. of energy
  ]

  create-wolves wolves-number [
    set color red
    setxy random-xcor random-ycor
    set feed-level random 5 
  ]

  reset-ticks
end

to go
  if not any? rabbits [ stop ]
  if not any? wolves [ stop ]
  grow-grass-and-weeds

  ask rabbits [ 
    move
    eat-grass
    eat-weeds
    reproduce
    death 
  ]

  ask wolves [
    wolf-move
    eat-rabbit
    wolf-death
  ]

  tick
end

to grow-grass-and-weeds
  ask patches [
    if pcolor = black [
      if random-float 1000 < weeds-grow-rate
        [ set pcolor violet ]
      if random-float 1000 < grass-grow-rate
        [ set pcolor green ]
  ] ]
end

to move  ;; rabbit procedure
  rt random 50
  lt random 50
  if (count wolves-on patch-ahead 1 > 0) or (count wolves-on patch-right-and-ahead 50 1 > 0) or (count wolves-on patch-left-and-ahead 50 1 > 0) [
    rt 90 + random 90
  ]

  fd 1 
  ;; moving takes some energy
  set energy energy - 0.5
end

to eat-grass  ;; rabbit procedure
  ;; gain "grass-energy" by eating grass
  if pcolor = green
  [ set pcolor black
    set energy energy + grass-energy ]
end

to eat-weeds  ;; rabbit procedure
  ;; gain "weed-energy" by eating weeds
  if pcolor = violet
  [ set pcolor black
    set energy energy + weed-energy ]
end

to reproduce     ;; rabbit procedure
  ;; give birth to a new rabbit, but it takes lots of energy
  if energy > birth-threshold
    [ set energy energy / 2
      hatch 1 [ fd 1 ] ]
end

to death     ;; rabbit procedure
  ;; die if you run out of energy
  if energy < 0 [ die ]
end

to wolf-move
  if feed-level < wolf-well-fed-th [
    rt random 50
    lt random 50
    fd 1
  ]
  ;; moving takes some energy
  set feed-level feed-level - wolf-digestion
end

to eat-rabbit
  let rb one-of rabbits-here                  
  if rb != nobody  [ 
    ask rb [ die ]
    set score score + 1
    set feed-level feed-level + rabbit-delicious
  ]
end

to wolf-death
  if feed-level < 0 [ die ]
end

; Copyright 2001 Uri Wilensky.
; See Info tab for full copyright and license.