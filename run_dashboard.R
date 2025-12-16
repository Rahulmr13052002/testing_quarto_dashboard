# ==================================
# Quarto Auto Renderer (Windows Safe)
# ==================================

PROJECT_DIR <- "C:/Users/HP/OneDrive/Documents/quarto-auth0-dashboard"
setwd(PROJECT_DIR)

QUARTO <- "C:/Users/HP/AppData/Local/Programs/Quarto/bin/quarto.exe"
LOG_FILE <- file.path(PROJECT_DIR, "dashboard_service.log")

log_msg <- function(msg) {
  cat(sprintf("[%s] %s\n", Sys.time(), msg),
      file = LOG_FILE,
      append = TRUE)
}

# Git identity
system('git config user.name "Rahulmr13052002"')
system('git config user.email "rahulmrrahulmr27@gmail.com"')

repeat {

  log_msg("==== Cycle Started ====")

  # ---- Render Quarto (NO 2>&1) ----
  render_output <- tryCatch({
    system2(QUARTO, c("render", "index.qmd"), stdout = TRUE, stderr = TRUE)
  }, error = function(e) e$message)

  log_msg("---- Quarto Output Start ----")
  log_msg(paste(render_output, collapse = "\n"))
  log_msg("---- Quarto Output End ----")

  # ---- Detect failure ----
  if (any(grepl("error|failed", render_output, ignore.case = TRUE))) {
    log_msg("❌ Render failed. Skipping git push.")
    Sys.sleep(120)
    next
  }

  log_msg("✅ Quarto render SUCCESS")

  # ---- Git status ----
  git_status <- system("git status --porcelain", intern = TRUE)

  if (length(git_status) == 0) {
    log_msg("ℹ️ No changes detected.")
    Sys.sleep(120)
    next
  }

  system("git add .")
  system('git commit -m "Auto update dashboard"')
  system("git push origin main")

  log_msg("🚀 Git push completed")
  log_msg("Sleeping for 2 minutes\n")

  Sys.sleep(120)
}
