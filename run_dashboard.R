# ==================================
# Quarto Auto Renderer (Robust)
# ==================================

# -------------------------
# Project Setup
# -------------------------
PROJECT_DIR <- "C:/Users/HP/OneDrive/Documents/quarto-auth0-dashboard"
setwd(PROJECT_DIR)

# Correct Quarto path
QUARTO <- '"C:/Users/HP/AppData/Local/Programs/Quarto/bin/quarto.exe"'  # update this to your Quarto path
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
  
  # ---- Check if Quarto exists ----
  if (!file.exists(gsub('"','',QUARTO))) {
    log_msg(paste0("❌ Quarto executable not found at: ", gsub('"','',QUARTO)))
    Sys.sleep(120)
    next
  }
  
  # ---- Render Quarto Dashboard ----
  render_output <- tryCatch({
    system(paste(QUARTO, "render index.qmd 2>&1"), intern = TRUE)
  }, error = function(e) e$message)
  
  # Log Quarto output
  log_msg("---- Quarto Output Start ----")
  log_msg(paste(render_output, collapse = "\n"))
  log_msg("---- Quarto Output End ----")
  
  # ---- Check for errors ----
  if (any(grepl("error|failed|not found", render_output, ignore.case = TRUE))) {
    log_msg("❌ Quarto render FAILED. Skipping Git push for this cycle.")
    Sys.sleep(120)
    next
  }
  
  log_msg("✅ Quarto render SUCCESS")
  
  # ---- Check for Git changes ----
  git_status <- system("git status --porcelain 2>&1", intern = TRUE)
  
  if (length(git_status) == 0) {
    log_msg("ℹ️ No changes detected. Nothing to commit.")
    Sys.sleep(120)
    next
  }
  
  # ---- Git Add ----
  git_add <- system("git add . 2>&1", intern = TRUE)
  log_msg(paste("Git Add Output:", paste(git_add, collapse = "\n")))
  
  # ---- Git Commit ----
  git_commit <- tryCatch({
    system('git commit -m "Auto update dashboard" 2>&1', intern = TRUE)
  }, error = function(e) e$message)
  log_msg(paste("Git Commit Output:", paste(git_commit, collapse = "\n")))
  
  # ---- Git Push ----
  git_push <- tryCatch({
    system("git push origin main 2>&1", intern = TRUE)
  }, error = function(e) e$message)
  log_msg(paste("Git Push Output:", paste(git_push, collapse = "\n")))
  
  log_msg("🚀 Git push cycle completed")
  
  # ---- Sleep for 2 minutes ----
  log_msg("Sleeping for 2 minutes\n")
  Sys.sleep(120)
}
