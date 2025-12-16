document.addEventListener("DOMContentLoaded", async () => {
  try {
    console.log("🚀 Auth script loaded");

    // ✅ Dynamic redirect URI (works everywhere)
    const redirectUri =
      window.location.origin + window.location.pathname;

    // ✅ Create Auth0 client (SPA safe config)
    const auth0Client = await auth0.createAuth0Client({
      domain: "dev-tbjltoa0gj3q6ken.us.auth0.com",
      clientId: "YZSOeNcMnGvmG07LjZFwB3yL6j3qZy9x",
      authorizationParams: {
        redirect_uri: redirectUri
      },
      cacheLocation: "localstorage", // REQUIRED for GitHub Pages
      useRefreshTokens: true
    });

    console.log("✅ Auth0 client initialized");

    // 🔁 Handle Auth0 redirect callback
    if (
      window.location.search.includes("code=") &&
      window.location.search.includes("state=")
    ) {
      console.log("🔁 Handling Auth0 redirect callback...");
      await auth0Client.handleRedirectCallback();
      window.history.replaceState({}, document.title, window.location.pathname);
      console.log("✅ Redirect handled successfully");
    }

    // 🔐 Check authentication
    const isAuthenticated = await auth0Client.isAuthenticated();
    console.log("🔐 isAuthenticated:", isAuthenticated);

    // 🚪 Not authenticated → redirect to login
    if (!isAuthenticated) {
      console.log("➡️ Redirecting to Auth0 login...");
      await auth0Client.loginWithRedirect();
      return;
    }

    // 🎉 Authenticated
    console.log("🎉 Login successful");

    // ✅ UNLOCK PAGE AFTER LOGIN
    document.body.classList.add("authenticated");

    // 🧱 Safe DOM access
    const content = document.getElementById("content");
    const topbar = document.getElementById("topbar");
    const usernameEl = document.getElementById("username");
    const logoutBtn = document.getElementById("logoutBtn");

    if (content) {
      content.style.display = "block";
    } else {
      console.warn("⚠️ #content element not found");
    }

    if (topbar) {
      topbar.style.display = "flex";
    } else {
      console.warn("⚠️ #topbar element not found");
    }

    // 👤 Get user info
    const user = await auth0Client.getUser();
    console.log("👤 Auth0 User Info:", user);

    if (user && usernameEl) {
      usernameEl.textContent = user.name || user.email || "User";
    }

    // 🚪 Logout handler
    if (logoutBtn) {
      logoutBtn.onclick = () => {
        console.log("🚪 Logging out...");
        auth0Client.logout({
          logoutParams: {
            returnTo: redirectUri
          }
        });
      };
    } else {
      console.warn("⚠️ #logoutBtn not found");
    }

  } catch (err) {
    console.error("❌ Auth0 fatal error:", err);
  }
});
