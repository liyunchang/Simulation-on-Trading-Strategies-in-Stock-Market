# Simulation-on-Trading-Strategies-in-Stock-Market

# Abstract

This paper uses behavioral finance theory and computational experimental financial methods to build artificial stock market based on Netlogo. The artificial stock market is driven by events, and the market clearing mechanism and price formation mechanism are determined by the supply and demand relationship. There are two trading assets in the market, and there are several traders who randomly choose the four investment strategies.

The simulation analysis results show that the trend of the number of momentum traders is opposite to the change of the number of reverse traders, and the number of noise traders and rational traders is relatively stable. Herd behavior has a major impact on the number of noise traders. One of the reverse traders and the momentum trader can obtain significant excess returns, but at the same time it exhibits considerable volatility of returns, which means that investors are also exposed to a much greater risk.

# An artificial stock market
# 1.1 Entities:
Multiple agents which are both prospective buyers and prospective sellers.
There are two separate stocks on the market, whose prices are driven by events.
# 1.2 Basic theory
Each agent will make a choice to buy or sell in each transaction and determines the number of stocks traded. A t the beginning, each agent randomly selects their trading strategy and then adjusts the strategy based on their earnings over time.

The trading price of a stock is determined by the supply and demand relationship
between the buyer s and the seller s in the market. If the supply exceeds the demand, the
corresponding stock price decreases; if the supply is less than demand, the price rises.
## 1.3 Model hypothesis
Assume that neither stock produces dividends
Assume that trading stocks do not incur transaction costs;
Assuming no deposit system, so there is no linked mark to market system
Assume that each stock can be short selling with restrictions
Assume that all agents in the market are divided into four categories
## 1.4 Trading S trategy
1) Contrary Strategy:
Those who choose
c ontrary strategy believe that the market will overreact, sorting stock
returns over the past period , then buying stocks that have performed poorly in the past and
selling stocks that performed well in the past.
2
) Momentum Strategy
Contrary to the c ontrary strategy, t hey believe that the price trend will continue, so they
tend to buy stocks that perform well and sell stocks that perform poorly.
3
) Rational Strategy
Rational traders will independently evaluate two stocks based on the rel
ationship
between price and intrinsic value. They think that when the asset price is seriously overvalued,
they will sell the assets. On the contrary, if the assets are undervalued, they will buy the assets.
4
) Noise Traders
Noise traders' judgments on the two stocks are also independent, but their judgment on
the market is based on irrationality, and their investment decisions are determined by
individual psychological bias, environmental forces (herd behavior), and random fa ctors.
5
) U pdate S trategy
Each agent has a certain amount of cash and stock at the beginning of the simulation. In
th e beginning , the cash and stock holdings for each trader are both zero.
The trader's wealth is cash + stock holdings 1 * current price of stock 1
+ stock holdings 2 * current price of stock 2.
