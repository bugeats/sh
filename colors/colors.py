import hsluv
import functools
import json
import colour
import logging
import numpy

pipe = lambda *hooks: (lambda input: (
    functools.reduce(lambda accu, hook: hook(accu), hooks, input)
))

# ----

# TODO
def unit_to_hex(unit_value):
    capped_value = max(0.0, min(unit_value, 1.0))
    hex_value = int(capped_value * 255)
    return f"{hex_value:02X}"

# TODO
def hsl_to_units(c):
    return colour.models.XYZ_to_Oklab([360 / h(c), 100 / s(c), 100 / l(c)])

# ----

hsl = lambda h, s, l: {
    "h": h,
    "s": s,
    "l": l,
}

def hex(c):
    return hsluv.hpluv_to_hex([h(c), s(c), l(c)])

def rgb(c):
    rgb = hsluv.hpluv_to_rgb([h(c), s(c), l(c)])
    return {
        "r": round(rgb[0] * 255),
        "g": round(rgb[1] * 255),
        "b": round(rgb[2] * 255),
    }

# ----

hue = lambda hook: (lambda input: {
    "h": hook(input["h"]),
    "s": input["s"],
    "l": input["l"],
})

sat = lambda hook: (lambda input: {
    "h": input["h"],
    "s": hook(input["s"]),
    "l": input["l"],
})

lit = lambda hook: (lambda input: {
    "h": input["h"],
    "s": input["s"],
    "l": hook(input["l"]),
})

h = lambda input: input["h"];
s = lambda input: input["s"];
l = lambda input: input["l"];

dim = lit(lambda l: l - 23)
ansi = pipe(lit(lambda l: l - 4), sat(lambda s: s - 12), hue(lambda h: h + 8))
fgdim = lit(lambda _: l(fg) - 5)
faint = lit(lambda _: l(bg) + 9)
veryfaint = lit(lambda _: l(bg) + 5)
bright = pipe(sat(lambda _: 100), lit(lambda _: 88))
alt = hue(lambda h: h - 32)

def interp(c1, c2, ratio):
  return hsl(
    h(c1) + ((h(c2) - h(c1)) * ratio),
    s(c1) + ((s(c2) - s(c1)) * ratio),
    l(c1) + ((l(c2) - l(c1)) * ratio)
  )

# ----

bg = hsl(58, 18, 13)
fg = pipe(sat(lambda _: 23), lit(lambda _: 76))(bg)

white = fg
black = hsl(h(fg), s(fg), l(bg) + 19)

red =     hsl(14,  100,       l(fg))
yellow =  hsl(72,  72,        l(red))
orange =  hsl(((h(yellow) + h(red)) / 2), 80, l(red))
green =   hsl(138, 58,        l(red))
cyan =    hsl(186, s(yellow), l(red))
blue =    hsl(259, s(yellow), l(red))
magenta = hsl(300, s(yellow), l(red))

brown = hsl(h(bg), s(green), l(green))

err_red = hsl(19, 91, l(red))
warn_orange = hsl(35, s(err_red), l(err_red))
info_seafoam = hsl(152, 51, l(err_red))
hint_cyan = hsl(162, s(info_seafoam), l(err_red))

# ----

# TODO export json with structure like `ansi.black.dim`, `ansi.magenta.normal`

keys = {
  "COLOR_ANSI_BLACK": ansi(black),
  "COLOR_ANSI_BLACK_DIM": dim(ansi(black)),
  "COLOR_ANSI_BLACK_LIGHT": bright(ansi(black)),
  "COLOR_ANSI_BLUE": dim(ansi(blue)),
  "COLOR_ANSI_BLUE_DIM": dim(dim(ansi(blue))),
  "COLOR_ANSI_BLUE_LIGHT": bright(dim(ansi(blue))),
  "COLOR_ANSI_CYAN": ansi(cyan),
  "COLOR_ANSI_CYAN_DIM": dim(ansi(cyan)),
  "COLOR_ANSI_CYAN_LIGHT": bright(ansi(cyan)),
  "COLOR_ANSI_GREEN": ansi(green),
  "COLOR_ANSI_GREEN_DIM": dim(ansi(green)),
  "COLOR_ANSI_GREEN_LIGHT": bright(ansi(green)),
  "COLOR_ANSI_MAGENTA": ansi(magenta),
  "COLOR_ANSI_MAGENTA_DIM": dim(ansi(magenta)),
  "COLOR_ANSI_MAGENTA_LIGHT": bright(ansi(magenta)),
  "COLOR_ANSI_RED": ansi(red),
  "COLOR_ANSI_RED_DIM": dim(ansi(red)),
  "COLOR_ANSI_RED_LIGHT": bright(ansi(red)),
  "COLOR_ANSI_WHITE": ansi(white),
  "COLOR_ANSI_WHITE_DIM": dim(ansi(white)),
  "COLOR_ANSI_WHITE_LIGHT": bright(ansi(white)),
  "COLOR_ANSI_YELLOW": ansi(yellow),
  "COLOR_ANSI_YELLOW_DIM": dim(ansi(yellow)),
  "COLOR_ANSI_YELLOW_LIGHT": bright(ansi(yellow)),
  "COLOR_COMMENT_FG": dim(fg),
  "COLOR_CURSOR_BG": hsl(h(blue), 100, l(fg)),
  "COLOR_ERROR_BG": veryfaint(magenta),
  "COLOR_ERROR_FG": magenta,
  "COLOR_KEYWORD_FG_ALT": alt(green),
  "COLOR_KEYWORD_FG": green,
  "COLOR_NORMAL_BG": bg,
  "COLOR_NORMAL_BG_ALT": veryfaint(bg),
  "COLOR_NORMAL_FG_ALT": fgdim(fg),
  "COLOR_NORMAL_FG": fg,
  "COLOR_PUNCTUATION_ACTIVE_BG": interp(bg, brown, (4 / 12)),
  "COLOR_PUNCTUATION_ACTIVE_FG": red,
  "COLOR_PUNCTUATION_FAINT_BG": faint(red),
  "COLOR_PUNCTUATION_FG": dim(red),
  "COLOR_SELECTION_BG_ALT": faint(alt(blue)),
  "COLOR_SELECTION_BG": faint(blue),
  "COLOR_STRING_FG_ALT": orange,
  "COLOR_STRING_FG": yellow,
  "COLOR_TYPE_FG": interp(fg, bg, (1 / 12)),
  "COLOR_UI_LEVEL_1_BG": interp(bg, brown, (1 / 24)),
  "COLOR_UI_LEVEL_1_FG": interp(bg, brown, (4 / 12)),
  "COLOR_UI_LEVEL_2_BG": interp(bg, brown, (2 / 24)),
  "COLOR_UI_LEVEL_2_FG": interp(bg, brown, (8 / 12)),
  "COLOR_UI_LEVEL_3_BG": interp(bg, brown, (3 / 24)),
  "COLOR_UI_LEVEL_3_FG": interp(bg, brown, (12 / 12)),
  "COLOR_VISIBLE_WHITESPACE_FG": faint(brown),
  "BG_ERR": veryfaint(magenta),
  "BG_WARN": veryfaint(alt(magenta)),
  "BG_INFO": veryfaint(orange),
  "BG_HINT": veryfaint(alt(orange)),
  "FG_ERR": dim(err_red),
  "FG_WARN": dim(warn_orange),
  "FG_INFO": dim(info_seafoam),
  "FG_HINT": dim(hint_cyan),
}

export = {
    "colors": {
        "hex": { k: hex(v) for (k, v) in keys.items()},
        "rgb": { k: rgb(v) for (k, v) in keys.items()}
    }
}

print(json.dumps(export, indent=4))
