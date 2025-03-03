extends Node

#this is a singleton

enum oracles {MEXC, BYBIT, BITGET, BINANCE}
var oracle : int = oracles.MEXC
enum intervals {m1, m5, m15, m30, m60, h4, d1, W1, M1}
var interval : int = intervals.m1
var interpolation_speed : float = 16
var scroll_intertia : float = 8
var camera_snap : float = 4
var chart_scroll : float = 6
