# ==================================
# Quarto Auto Renderer (Robust)
# ==================================

PROJECT_DIR <- "C:/Users/HP/OneDrive/Documents/quarto-auth0-dashboard"
setwd(PROJECT_DIR)

QUARTO <- '"C:/Program Files/Quarto/bin/quarto.exe"'
LOG_FILE <- file.path(PROJECT_DIR, "dashboard_service.log")

log_msg <- function(msg) {
  cat(
    sprintf("[%s] %s\n", Sys.time(), msg),
    file = LOG_FILE,
    append = TRUE
  )
}

repeat({

  log_msg("==== Cycle Started ====")

  # ---- Render dashboard (capture output) ----
  render_output <- tryCatch({
    system(
      paste(QUARTO, "render index.qmd"),
      intern = TRUE
    )
  }, error = function(e) {
    e$message
  })

  # ---- Check for real errors ----
  if (any(grepl("Error", render_output, ignore.case = TRUE))) {
    log_msg("❌ Quarto render ERROR detected:")
    log_msg(paste(render_output, collapse = " | "))
    Sys.sleep(120)
    next
  }

  log_msg("✅ Quarto render SUCCESS")

  # ---- Check git changes ----
  git_status <- system("git status --porcelain", intern = TRUE)

  if (length(git_status) == 0) {
    log_msg("ℹ️ No changes detected. Nothing to commit.")
    Sys.sleep(120)
    next
  }

  # ---- Commit & push ----
  system("git add .")
  system('git commit -m "Auto update dashboard"')

  push_status <- system("git push origin main", intern = FALSE)

  if (push_status == 0) {
    log_msg("🚀 Git push SUCCESS")
  } else {
    log_msg("❌ Git push FAILED")
  }

  log_msg("Sleeping for 2 minutes")
  Sys.sleep(120)
})
