# Foundation Stack — shared ggplot styling
# Colors align with tools/_shared/hrmax-bands.json and styles.css (.badge-pillar-methods, .fs-scenario-card)

FS_COL_CONSERVATIVE <- "#3b6ea8"
FS_COL_MODERATE     <- "#3d8c40"
FS_COL_PROGRESSIVE  <- "#d97b2b"
FS_COL_RTP          <- "#084298"  # sport track
FS_COL_RTL          <- "#0f5132"  # school / learn track
FS_COL_ALERT        <- "#c92a2a"
FS_COL_MUTED        <- "#495057"
FS_COL_GRID         <- "#e9ecef"
FS_COL_INK          <- "#212529"

theme_fs <- function(base_size = 11) {
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(
        face = "bold", size = base_size + 1, color = FS_COL_INK, margin = ggplot2::margin(b = 4)
      ),
      plot.subtitle = ggplot2::element_text(
        size = base_size, color = FS_COL_MUTED, margin = ggplot2::margin(b = 10)
      ),
      plot.caption = ggplot2::element_text(
        size = base_size - 2.5, color = FS_COL_MUTED, hjust = 0, lineheight = 1.25
      ),
      panel.grid.major.y = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_line(color = FS_COL_GRID, linewidth = 0.35),
      strip.text = ggplot2::element_text(face = "bold", color = FS_COL_INK),
      strip.background = ggplot2::element_rect(fill = "#f8f9fa", color = NA),
      legend.position = "bottom",
      legend.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_text(color = FS_COL_INK),
      axis.title.x = ggplot2::element_text(color = FS_COL_MUTED)
    )
}

fs_source_theme <- function() {
  candidates <- c(
    file.path(dirname(knitr::current_input(dir = TRUE)), "..", "_shared", "fs-ggplot-theme.R"),
    file.path(dirname(knitr::current_input(dir = TRUE)), "..", "..", "_shared", "fs-ggplot-theme.R"),
    "~/Documents/guanglab-foundation-stack/posts/_shared/fs-ggplot-theme.R"
  )
  path <- candidates[file.exists(candidates)][1]
  if (!is.na(path)) source(path, local = parent.frame())
}
