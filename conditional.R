df <- readRDS('CapeFLU.rds')

# Remove rows with missing race or doctor name
valid <- !is.na(df$RACE) & !is.na(df$`Medical.man's.name`)

# Indicators
white <- toupper(trimws(df$RACE[valid])) == "WHITE"

not_signed <- nchar(df$`Medical.man's.name`[valid]) == 1 |
  toupper(trimws(df$`Medical.man's.name`[valid])) %in%
  c("NA", "NIL", "NONE", "(INQUEST)", "[BLANK]")

# Conditional probabilities
c(
  "P(not signed | not white)" = mean(not_signed[!white]),
  "P(signed | not white)"     = mean(!not_signed[!white]),
  "P(not signed | white)"     = mean(not_signed[white]),
  "P(signed | white)"         = mean(!not_signed[white])
)
