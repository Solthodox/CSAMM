# Constant Sum Automated Market Maker

This is just a theorical application of what a Constant Sum Automated Market Maker would look like. In reality, this is not a good aproach to run a secure , and sustainable dex. 

## Math behind

The equation is as simple as : number of tokens(x) + number of tokens(y) equals a constant c : 

```shell
x + y = c
```

Let's assume that the exchange has 200x and 900y. The result of (c) is then 200+900 = 1100. what would we get for 40 y tokens?

```shell
(200 + 10) + y = 1100
y = 1100 - 210
y = 890
```
We get a (y) of 890 which means we want the amount of (y) tokens to be 890. We currently have 900 so the user will get the differnce : 

```shell
dy = 900 - 890
dy = 10
```

So, as expected the user gets the same amount as given : 10.

## Problems

This algorithm wouldn't be a very good solution for an AMM. There are several reasons behind: First, the reserves of one of the assets could easily be drained . While in a constant product market maker like Uniswap, it would be exponentially more and more expensive to let one of the reserves in 0(the slippage would be houge), in a constant sum market maker it would take as many tokens as you want to get out to do it, doe to the inexistance of slippage. 

## How build a Stablecoin dex

This could be seen as a good solution to the big problem of stable-coins : they should be worth the same but in a CPAMM slippage significantly reduces the amount you get back. So, why don't we create a 
