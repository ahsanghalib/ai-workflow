# LinkedIn visual color tokens

M Ahsan Izhar's LinkedIn visual system has one canonical palette. It is not a
set of interchangeable campaign schemes. Use these exact values for every
portrait carousel and standalone card that uses the Ahsan local system.

<!-- markdownlint-disable MD060 -->

| Role | Token | Hex |
|---|---|---|
| Page field | `paper` | `#F7F7F4` |
| Primary text | `ink` | `#16181D` |
| Focal accent | `accent-cobalt` | `#2540D9` |
| Secondary text | `gray` | `#5F6472` |
| Rules | `line` | `#D9DAD4` |
| Grouped surface | `panel` | `#ECECE8` |

<!-- markdownlint-enable MD060 -->

## Application rules

- Use `paper` as the page field, `ink` for primary text, `gray` for secondary
  text, `line` for 2 px rules, and `panel` for grouped surfaces and code
  panels.
- Use `accent-cobalt` for at most one focal idea per page: a keyword, key path,
  one bar, or one number. Do not use it as decoration or as a second body-text
  color.
- Do not add gradients, glow, neon, extra status colors, white substitutes,
  alternate campaign palettes, or arbitrary “tech” colors.
- Pair color with labels, position, rules, or shape so meaning survives
  grayscale and common color-vision differences.
- Check contrast on paper, panel, and footer/label text separately from the
  headline and cobalt focal element.

The exact typography, geometry, chrome, and one-accent rule are defined in
[ahsan-local-design-system.md](ahsan-local-design-system.md).
