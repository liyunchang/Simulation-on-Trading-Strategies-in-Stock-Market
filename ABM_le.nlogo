globals[news-qualitative-meaning-one
  intrinsic-value-one
  price-one
  price-%-variation-one
  continuity-one
  return-one
  indicator-volatility-one
  news-qualitative-meaning-two
  intrinsic-value-two
  price-two
  price-%-variation-two
  continuity-two
  return-two
  indicator-volatility-two
  initial-price-adjustment-Contrarian
  initial-price-adjustment-Momentum
  initial-price-one-Contrarian
  initial-price-two-Contrarian
  initial-price-one-Momentum
  initial-price-two-Momentum]

patches-own[cash
  private-message-one
  private-message-one-record
  stock-trade-one
  stock-hold-one
  trade-direction-one
  private-message-two
  private-message-two-record
  stock-trade-two
  stock-hold-two
  trade-direction-two]

to setup
  clear-all
  ca
  ask patches
  [set cash 0
    set stock-hold-one 0
    set stock-hold-two 0
    set private-message-one-record 0
    set private-message-two-record 0
    set pcolor blue
    if random scale-of-foundamentalists = 0
    [set pcolor yellow]
    if random scale-of-foundamentalists = 1
    [set pcolor green]
    if random scale-of-foundamentalists = 2
    [set pcolor red]
  ]

  set intrinsic-value-one 0
  set intrinsic-value-two 0
  set price-one 0
  set price-two 0
  set initial-price-one-Contrarian 0
  set initial-price-two-Contrarian 0
  set initial-price-one-Momentum 0
  set initial-price-two-Momentum 0
  set continuity-one 0
  set continuity-two 0
  set initial-price-adjustment-Contrarian 0
  set initial-price-adjustment-Momentum 0
end

to go
  news-arrival-one
  news-arrival-two
  patches-decision
  market-clearing
  update-strategy
  compute-indicator-volatility
  do-plot
end

to news-arrival-one
  ifelse((random-normal 0 1 ) > 0)
    [ set news-qualitative-meaning-one 1
      set intrinsic-value-one intrinsic-value-one + random-float 1.00
      ask patches
      [ ifelse(random-float 1.00 < correct-rate1)
        [ set private-message-one 1]
        [ set private-message-one -1]
      ]
    ]
    [set news-qualitative-meaning-one -1
      set intrinsic-value-one intrinsic-value-one - random-float 1.00
      ask patches
      [ifelse(random-float 1.00 < correct-rate1)
        [set private-message-one -1]
        [set private-message-one 1]
      ]
    ]
end

to news-arrival-two

  ifelse((random-normal 0 1) > 0)
  [set news-qualitative-meaning-two 1
    set intrinsic-value-two intrinsic-value-two + random-float 1.00
    ask patches
    [ifelse random-float 1.00 < correct-rate2
      [set private-message-two 1]
      [set private-message-two -1]
    ]
  ]
  [set news-qualitative-meaning-two -1
    set intrinsic-value-two intrinsic-value-two - random-float 1.00
    ask patches
    [ifelse random-float 1.00 < correct-rate2
      [set private-message-two -1]
      [set private-message-two 1]
    ]
  ]
end

to patches-decision
ask patches
[set stock-trade-one 0
  set trade-direction-one 0
  set stock-trade-two 0
  set trade-direction-two 0]

ask patches
[if pcolor = yellow
  [if initial-price-one-Contrarian != 0 and initial-price-two-Contrarian != 0 and (price-one - initial-price-one-Contrarian)
    / initial-price-one-Contrarian >= ((price-two - initial-price-two-Contrarian) / initial-price-two-Contrarian)
    [set stock-trade-one stock-trade-one - 1
      set trade-direction-one -1
      set stock-trade-two stock-trade-two + 1
      set trade-direction-two 1]

    if initial-price-one-Contrarian != 0 and initial-price-two-Contrarian != 0 and (price-one - initial-price-one-Contrarian)
    / initial-price-one-Contrarian < ((price-two - initial-price-two-Contrarian) / initial-price-two-Contrarian)
    [set stock-trade-two stock-trade-two - 1
      set trade-direction-two -1
      set stock-trade-one stock-trade-one + 1
      set trade-direction-one 1]
  ]

  if pcolor = green
  [if initial-price-one-Momentum != 0 and initial-price-two-Momentum != 0 and (price-one - initial-price-one-Momentum)
    / initial-price-one-Momentum  >= ((price-two - initial-price-two-Momentum) / initial-price-two-Momentum)
    [set stock-trade-one stock-trade-one + 1
      set trade-direction-one 1
      set stock-trade-two stock-trade-two - 1
      set trade-direction-two -1]

    if initial-price-one-Momentum != 0 and initial-price-two-Momentum != 0 and (price-one - initial-price-one-Momentum)
    / initial-price-one-Momentum  < ((price-two - initial-price-two-Momentum) / initial-price-two-Momentum)
    [set stock-trade-two stock-trade-two + 1
      set trade-direction-two 1
      set stock-trade-one stock-trade-one - 1
      set trade-direction-one -1]
  ]

  if pcolor = red
  [if continuity-one * private-message-one-record > 0 and affect-rate < 0.8
    [set affect-rate affect-rate + 0.05]
    ifelse(affect-rate * sum[trade-direction-one]of neighbors + (1 - affect-rate) * private-message-one +
      (random-normal 0 1)) > 0
    [set stock-trade-one stock-trade-one + 1
      set trade-direction-one 1]
    [if stock-hold-one > (-1) * limitation-of-short-selling
      [set stock-trade-one stock-trade-one - 1
        set trade-direction-one -1]
    ]

      if continuity-two * private-message-two-record > 0 and affect-rate < 0.8
    [set affect-rate affect-rate + 0.05]
    ifelse(affect-rate * sum[trade-direction-two]of neighbors + (1 - affect-rate) * private-message-two +
      (random-normal 0 1)) > 0
    [set stock-trade-two stock-trade-two + 1
      set trade-direction-two 1]
    [if stock-hold-two > (-1) * limitation-of-short-selling
      [set stock-trade-two stock-trade-two - 1
        set trade-direction-two -1]
    ]
  ]

  if pcolor = blue
  [ifelse(intrinsic-value-one > price-one)
    [set stock-trade-one stock-trade-one + 1
      set trade-direction-one 1]
    [if stock-hold-one > (-1) * limitation-of-short-selling
      [set stock-trade-one stock-trade-one - 1
        set trade-direction-one -1]
    ]

    ifelse(intrinsic-value-two > price-two)
    [set stock-trade-two stock-trade-two + 1
      set trade-direction-two 1]
    [if stock-hold-two > (-1) * limitation-of-short-selling
      [set stock-trade-two stock-trade-two - 1
        set trade-direction-two -1]
    ]
  ]
]

ask patches
[set stock-hold-one stock-hold-one + stock-trade-one
  set stock-hold-two stock-hold-two + stock-trade-two]
end

to market-clearing
  set return-one 0
  set return-two 0
  if sum[abs(stock-trade-one)]of patches != 0
  [set return-one (sum[stock-trade-one]of patches)/(sum[abs(stock-trade-one)] of patches)]
  ifelse price-one != 0
  [set price-%-variation-one return-one / price-one]
  [set price-%-variation-one 0]
  set price-one price-one + return-one
  if return-one != 0
  [ifelse continuity-one * return-one < 0
    [set continuity-one return-one / abs(return-one)]
    [set continuity-one return-one * (abs(continuity-one) + 1) / abs(return-one)]
  ]

  if sum[abs(stock-trade-two)]of patches != 0
  [set return-two (sum[stock-trade-two]of patches)/(sum[abs(stock-trade-two)] of patches)]
  ifelse price-two != 0
  [set price-%-variation-two return-two / price-two]
  [set price-%-variation-two 0]
  set price-two price-two + return-two
  if return-two != 0
  [ifelse continuity-two * return-two < 0
    [set continuity-two return-two / abs(return-two)]
    [set continuity-two return-two * (abs(continuity-two) + 1) / abs(return-two)]
  ]

  ask patches
  [set cash cash - price-one * stock-trade-one - price-two * stock-trade-two
    set private-message-one-record private-message-one
    set private-message-two-record private-message-two
    set initial-price-adjustment-Contrarian initial-price-adjustment-Contrarian + 1
    if initial-price-adjustment-Contrarian = base-term-Contrarian
    [set initial-price-one-Contrarian price-one
      set initial-price-two-Contrarian price-two]
    set initial-price-adjustment-Momentum initial-price-adjustment-Momentum + 1
    if initial-price-adjustment-Momentum = base-term-Momentum
    [set initial-price-one-Momentum price-one
      set initial-price-two-Momentum price-two]
  ]
end

to update-strategy
  ask patches
  [if(cash + price-one * stock-hold-one + price-two * stock-hold-two) < 0 and random-float 1.00
     < convert-rate
    [set pcolor blue
      if random scale-of-foundamentalists = 0
      [set pcolor yellow]
     if random scale-of-foundamentalists = 1
      [set pcolor green]
      if random scale-of-foundamentalists = 2
      [set pcolor red]
    ]
  ]
end

to compute-indicator-volatility
  set indicator-volatility-one abs(return-one)
  set indicator-volatility-two abs(return-two)
end

to do-plot
  set-current-plot "Total"
  set-current-plot-pen"number-of-ContrarianTraders"
  plot count patches with [pcolor = yellow]
  set-current-plot-pen "number-of-MomentumTraders"
  plot count patches with [pcolor = green]
  set-current-plot-pen "number-of-NoiseTraders"
  plot count patches with [pcolor = red]


  set-current-plot "number-of-ContrarianTraders"
  set-current-plot-pen"number-of-ContrarianTraders"
  plot count patches with [pcolor = yellow]

  set-current-plot "number-of-MomentumTraders"
  set-current-plot-pen "number-of-MomentumTraders"
  plot count patches with [pcolor = green]

  set-current-plot "number-of-NoiseTraders"
  set-current-plot-pen "number-of-NoiseTraders"
  plot count patches with [pcolor = red]

  set-current-plot "number-of-others"
  set-current-plot-pen "number-of-others"
  plot count patches with [pcolor = blue]




  set-current-plot "intrinsic-value-one"
  set-current-plot-pen "intrinsic-value-one"

  plot intrinsic-value-one
  set-current-plot "price-one"
  set-current-plot-pen "price-one"
  plot price-one

  set-current-plot "intrinsic-value-two"
  set-current-plot-pen "intrinsic-value-two"
  plot intrinsic-value-two

  set-current-plot "price-two"
  set-current-plot-pen "price-two"
  plot price-two

  set-current-plot "stock-trade-one"
  set-current-plot-pen "trade-of-contrariantraders"
  plot sum [stock-trade-one] of patches with [pcolor = yellow] / count patches with [pcolor = yellow]
  set-current-plot-pen "trade-of-momentumtraders"
  plot sum[stock-trade-one] of patches with [pcolor = green] / count patches with [pcolor = green]
  set-current-plot-pen "trade-of-noisetraders"
  plot sum[stock-trade-one] of patches with [pcolor = red] / count patches with [pcolor = red]

  set-current-plot "stock-trade-two"
  set-current-plot-pen "trade-of-contrariantraders"
  plot sum [stock-trade-two] of patches with [pcolor = yellow] / count patches with [pcolor = yellow]
  set-current-plot-pen "trade-of-momentumtraders"
  plot sum[stock-trade-two] of patches with [pcolor = green] / count patches with [pcolor = green]
  set-current-plot-pen "trade-of-noisetraders"
  plot sum[stock-trade-two] of patches with [pcolor = red] / count patches with [pcolor = red]

  set-current-plot "stock-hold-one"
  set-current-plot-pen "hold-of-constrariantraders"
  plot sum[stock-hold-one] of patches with [pcolor = yellow] / count patches with [pcolor = yellow]
  set-current-plot-pen "hold-of-momentumtraders"
  plot sum[stock-hold-one] of patches with [pcolor = green] / count patches with [pcolor = green]
  set-current-plot-pen "hold-of-noisetraders"
  plot sum[stock-hold-one] of patches with [pcolor = red] / count patches with [pcolor = red]

  set-current-plot "stock-hold-two"
  set-current-plot-pen "hold-of-contrariantraders"
  plot sum[stock-hold-two] of patches with [pcolor = yellow] / count patches with [pcolor = yellow]
  set-current-plot-pen "hold-of-momentumtraders"
  plot sum[stock-hold-one] of patches with [pcolor = green] / count patches with [pcolor = green]
  set-current-plot-pen "hold-of-noisetraders"
  plot sum[stock-hold-one] of patches with [pcolor = red] / count patches with [pcolor = red]

  set-current-plot "return"
  set-current-plot-pen "return-one"
  plot return-one
  set-current-plot-pen "return-two"
  plot return-two
  set-current-plot "Volatility"
  set-current-plot-pen "indicator-volatility-one"
  plot indicator-volatility-one
  set-current-plot-pen "indicator-volatility-two"
  plot indicator-volatility-two
  set-current-plot "wealth-of-constrariantraders"
  set-current-plot-pen "wealth-of-constrariantraders"
  plot sum[ cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = yellow] / count patches with [pcolor = yellow]
  set-current-plot-pen "wealth-of-rationaltraders"
  plot sum[ cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = blue] / count patches with [pcolor = blue]
  set-current-plot "wealth-of-momentumtraders"
  set-current-plot-pen "wealth-of-momentumtraders"
  plot sum[ cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = green] / count patches with [pcolor = green]
  set-current-plot-pen "wealth-of-rationaltraders"
  plot sum[ cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = blue] / count patches with [pcolor = blue]
  set-current-plot"wealth-of-noisetraders"
  set-current-plot-pen "wealth-of-noisetraders"
  plot sum[ cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = red] / count patches with [pcolor = red]
  set-current-plot-pen "wealth-of-rationaltraders"
  plot sum [cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = blue] / count patches with [pcolor = blue]
end
@#$#@#$#@
GRAPHICS-WINDOW
245
10
601
367
-1
-1
10.55
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

SLIDER
-6
10
212
43
scale-of-foundamentalists
scale-of-foundamentalists
6
60
27.0
1
1
NIL
HORIZONTAL

SLIDER
2
127
174
160
correct-rate1
correct-rate1
0
1
0.3
0.01
1
NIL
HORIZONTAL

SLIDER
1
204
173
237
correct-rate2
correct-rate2
0
1
0.78
0.01
1
NIL
HORIZONTAL

SLIDER
2
49
174
82
convert-rate
convert-rate
0
1
0.52
0.01
1
NIL
HORIZONTAL

SLIDER
0
242
172
275
affect-rate
affect-rate
0
1
0.8000000000000002
0.01
1
NIL
HORIZONTAL

SLIDER
-2
284
236
317
limitation-of-short-selling
limitation-of-short-selling
100
200
100.0
1
1
NIL
HORIZONTAL

SLIDER
2
88
194
121
base-term-Contrarian
base-term-Contrarian
1
500
50.0
1
1
NIL
HORIZONTAL

SLIDER
1
165
195
198
base-term-Momentum
base-term-Momentum
1
500
43.0
1
1
NIL
HORIZONTAL

BUTTON
657
31
760
86
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
657
100
763
149
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
62
440
267
597
total
time
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"number-of-ContrarianTraders" 1.0 0 -1184463 true "set-current-plot \"Total\"" " set-current-plot-pen\"number-of-ContrarianTraders\"\n  plot count patches with [pcolor = yellow]"
"number-of-MomentumTraders" 1.0 0 -13840069 true "" "set-current-plot-pen \"number-of-MomentumTraders\"\n  plot count patches with [pcolor = green]"
"number-of-NoiseTraders" 1.0 0 -2674135 true "" "set-current-plot-pen \"number-of-NoiseTraders\"\n  plot count patches with [pcolor = red]"

BUTTON
657
166
771
214
do-plot
do-plot
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
63
612
263
762
intrinsic-value-one
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"intrinsic-value-one" 1.0 0 -16777216 true "" "plot intrinsic-value-one"

PLOT
491
612
691
762
price-one
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"price-one" 1.0 0 -16777216 true "" "set-current-plot \"price-one\"\n  set-current-plot-pen \"price-one\"\n  plot price-one"

PLOT
278
613
478
763
intrinsic-value-two
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"intrinsic-value-two" 1.0 0 -16777216 true "" "set-current-plot \"intrinsic-value-two\"\n  set-current-plot-pen \"intrinsic-value-two\"\n  plot intrinsic-value-two"

PLOT
708
613
908
763
price-two
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"price-two" 1.0 0 -16777216 true "" "set-current-plot \"price-two\"\n  set-current-plot-pen \"price-two\"\n  plot price-two"

PLOT
66
786
266
936
stock-trade-one
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"trade-of-contrariantraders" 1.0 0 -1184463 true "" "\n  plot sum [stock-trade-one] of patches with [pcolor = yellow] / count patches with [pcolor = yellow]\n"
"trade-of-momentumtraders" 1.0 0 -13840069 true "" "\n  plot sum[stock-trade-one] of patches with [pcolor = green] / count patches with [pcolor = green]"
"trade-of-noisetraders" 1.0 0 -2674135 true "" "\n  plot sum[stock-trade-one] of patches with [pcolor = red] / count patches with [pcolor = red]"
"stock-trade-two" 1.0 0 -16777216 true "" "set-current-plot-pen \"stock-trade-one\"\n"

PLOT
496
782
696
932
stock-hold-one
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"hold-of-constrariantraders" 1.0 0 -1184463 true "" "plot sum[stock-hold-one] of patches with [pcolor = yellow] / count patches with [pcolor = yellow]\n"
"hold-of-momentumtraders" 1.0 0 -13840069 true "" "plot sum[stock-hold-one] of patches with [pcolor = green] / count patches with [pcolor = green]"
"hold-of-noisetraders" 1.0 0 -2674135 true "" "plot sum[stock-hold-one] of patches with [pcolor = red] / count patches with [pcolor = red]"

PLOT
714
785
914
935
stock-hold-two
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"hold-of-contrariantraders" 1.0 0 -1184463 true "" "plot sum[stock-hold-two] of patches with [pcolor = yellow] / count patches with [pcolor = yellow]"
"hold-of-momentumtraders" 1.0 0 -13840069 true "" "plot sum[stock-hold-two] of patches with [pcolor = green] / count patches with [pcolor = green]\n"
"hold-of-noisetraders" 1.0 0 -2674135 true "" "plot sum[stock-hold-two] of patches with [pcolor = red] / count patches with [pcolor = red]"

PLOT
66
954
266
1104
return
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"return-one" 1.0 0 -16777216 true "" "plot return-one"
"return-two" 1.0 0 -7500403 true "" "plot return-two"

PLOT
285
956
485
1106
Volatility
NIL
NIL
0.0
10.0
0.0
1.5
true
false
"" ""
PENS
"indicator-volatility-one" 1.0 0 -16777216 true "" "plot indicator-volatility-one"
"indicator-volatility-two" 1.0 0 -7500403 true "" "plot indicator-volatility-two"

PLOT
710
955
910
1105
wealth-of-constrariantraders
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"wealth-of-constrariantraders" 1.0 0 -1184463 true "" "plot sum[ cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = yellow] / count patches with [pcolor = yellow]"
"wealth-of-rationaltraders" 1.0 0 -14070903 true "" "plot sum[ cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = blue] / count patches with [pcolor = blue]"

PLOT
921
955
1121
1105
wealth-of-momentumtraders
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"wealth-of-momentumtraders" 1.0 0 -13840069 true "" "plot sum[ cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = green] / count patches with [pcolor = green]"
"wealth-of-rationaltraders" 1.0 0 -14070903 true "" "plot sum[ cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = blue] / count patches with [pcolor = blue]"

PLOT
498
955
698
1105
wealth-of-noisetraders
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"wealth-of-noisetraders" 1.0 0 -5298144 true "" "plot sum[ cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = red] / count patches with [pcolor = red]"
"wealth-of-rationaltraders" 1.0 0 -14070903 true "" "plot sum [cash + price-one * stock-hold-one + price-two * stock-hold-two] of patches with [pcolor = blue] / count patches with [pcolor = blue]"

PLOT
286
783
486
933
stock-trade-two
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"trade-of-contrariantraders" 1.0 0 -1184463 true "" "plot sum [stock-trade-two] of patches with [pcolor = yellow] / count patches with [pcolor = yellow]\n"
"trade-of-momentumtraders" 1.0 0 -10899396 true "" "plot sum [stock-trade-two] of patches with [pcolor = green] / count patches with [pcolor = green]"
"stock-trade-two" 1.0 0 -7500403 true "" "set-current-plot-pen \"stock-trade-two\""
"trade-of-noisetraders" 1.0 0 -2674135 true "" "plot sum[stock-trade-two] of patches with [pcolor = red] / count patches with [pcolor = red]"

PLOT
284
438
484
588
number-of-ContrarianTraders
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"number-of-ContrarianTraders" 1.0 0 -1184463 true "" " set-current-plot-pen\"number-of-ContrarianTraders\"\n  plot count patches with [pcolor = yellow]"

PLOT
516
440
716
590
number-of-MomentumTraders
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"number-of-MomentumTraders" 1.0 0 -10899396 true "" "set-current-plot-pen \"number-of-MomentumTraders\"\n  plot count patches with [pcolor = green]"

PLOT
745
440
945
590
number-of-NoiseTraders
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"number-of-NoiseTraders" 1.0 0 -2674135 true "" "set-current-plot-pen \"number-of-NoiseTraders\"\n  plot count patches with [pcolor = red]"

PLOT
961
440
1161
590
number-of-others
NIL
NIL
0.0
10.0
900.0
1000.0
true
false
"" ""
PENS
"number-of-others" 1.0 0 -13345367 true "" " plot count patches with [pcolor = blue]"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
