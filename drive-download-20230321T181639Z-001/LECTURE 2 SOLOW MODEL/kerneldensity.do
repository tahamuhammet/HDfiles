kdensity y1960, addplot(kdensity y1980 || kdensity y2021)

generate log1960=ln(y1960)
generate log1980=ln(y1980)
generate log2021=ln(y2021)

kdensity log1960, addplot(kdensity log1980 || kdensity log2021)
