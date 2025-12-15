# ==================================
# Quarto Auto Renderer (Robust)
# ==================================

# -------------------------
# Project Setup
# -------------------------
PROJECT_DIR <- "C:/Users/HP/OneDrive/Documents/quarto-auth0-dashboard"
setwd(PROJECT_DIR)

QUARTO <- '"C:/Program Files/Quarto/bin/quarto.exe"'
LOG_FILE <- file.path(PROJECT_DIR, "dashboard_service.log")

# -------------------------
# Logging function
# -------------------------
log_msg <- function(msg) {
  cat(sprintf("[%s] %s\n", Sys.time(), msg),
      file = LOG_FILE,
      append = TRUE)
}

# -------------------------
# Force Git identity
# -------------------------
system('git config user.name "Rahulmr13052002"')
system('git config user.email "rahulmrrahulmr27@gmail.com"')

# -------------------------
# Main Loop
# -------------------------
repeat {
  log_msg("==== Cycle Started ====")
  
  # ---- Render Quarto Dashboard ----
  render_output <- tryCatch({
    system(paste(QUARTO, "render index.qmd"), intern = TRUE, ignore.stderr = FALSE)
  }, error = function(e) {
    e$message
  })
  
  if (any(grepl("Error", render_output, ignore.case = TRUE))) {
    log_msg("❌ Quarto render ERROR detected:")
    log_msg(paste(render_output, collapse = " | "))
    log_msg("Skipping Git push for this cycle.")
    Sys.sleep(120)
    next
  }
  
  log_msg("✅ Quarto render SUCCESS")
  log_msg(paste(render_output, collapse = " | "))
  
  # ---- Check for changes ----
  git_status <- system("git status --porcelain", intern = TRUE)
  
  if (length(git_status) == 0) {
    log_msg("ℹ️ No changes detected. Nothing to commit.")
    Sys.sleep(120)
    next
  }
  
  # ---- Commit & Push ----
  git_add <- system("git add .", intern = TRUE)
  log_msg(paste(git_add, collapse = " | "))
  
  git_commit <- tryCatch({
    system('git commit -m "Auto update dashboard"', intern = TRUE)
  }, error = function(e) e$message)
  log_msg(paste(git_commit, collapse = " | "))
  
  git_push <- tryCatch({
    system("git push origin main", intern = TRUE)
  }, error = function(e) e$message)
  log_msg(paste(git_push, collapse = " | "))
  
  log_msg("🚀 Git push completed")
  
  # ---- Sleep for 2 minutes ----
  log_msg("Sleeping for 2 minutes\n")
  Sys.sleep(120)
}
