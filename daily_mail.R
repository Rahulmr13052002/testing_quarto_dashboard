library(emayili)
library(glue)

smtp_user <- "rahulmrrahulmr27@gmail.com"       # your sender email
smtp_password <- "uumx szxe nqqz umex"      # normal password / app password
smtp_host <- "smtp.gmail.com"            # SMTP server (Gmail, Office, custom)
smtp_port <- 587                            # usually 587 for TLS

recipients <- c("rahul@zukti.tech", "mrr36144@gmail.com")
daily_link <- "https://rahulmr13052002.github.io/testing_quarto_dashboard/"

email <- envelope() %>%
  from(smtp_user) %>%
  to(recipients) %>%
  subject("Daily Access Link") %>%
  text(glue("
Hello,

Please find your daily access link below:

{daily_link}

Regards,
Your Company
"))

smtp <- server(
  host = smtp_host,
  port = smtp_port,
  username = smtp_user,
  password = smtp_password,
  reuse = TRUE
)

smtp(email)
cat("✅ Daily email sent successfully\n")
