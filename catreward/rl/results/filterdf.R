filterdf <- function(df, name, keep_levels){
    # Using the factor named <name> filter the df-convertable
    # object, using <keep_levels> to decide what to keep

    df <- as.data.frame(df)

    # Only act if levels is not NA...
    # Build a mask
    mask <- rep(FALSE, nrow(df))
    for(lev in keep_levels){ mask <- mask | (df[[name]] %in% lev) }

    # use it to filter df, and relevel too.
    df <- df[mask, ]
    df <- droplevels(df)
    df    
}

