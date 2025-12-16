document.addEventListener("DOMContentLoaded", async () => {
  try {
    console.log("🚀 Auth script loaded");

    const redirectUri =
      window.location.origin + window.location.pathname;

    const auth0Client = await auth0.createAuth0Client({
      domain: "dev-tbjltoa0gj3q6ken.us.auth0.com",
      clientId: "YZSOeNcMnGvmG07LjZFwB3yL6j3qZy9x",
      authorizationParams: {
        redirect_uri: redirectUri
      },
      cacheLocation: "localstorage", // IMPORTANT for GitHub Pages
      useRefreshTokens: true
    });

    console.log("✅ Auth0 client initialized");

    // 🔁 Handle redirect callback
    if (
      window.location.search.includes("code=") &&
      window.location.search.includes("state=")
    ) {
      console.log("🔁 Handling Auth0 redirect callback...");
      await auth0Client.handleRedirectCallback();
      window.history.replaceState({}, document.title, window.location.pathname);
      console.log("✅ Redirect handled successfully");
    }

    const isAuthenticated = await auth0Client.isAuthenticated();
    console.log("🔐 isAuthenticated:", isAuthenticated);

    // 🚪 Not logged in → redirect to login
    if (!isAuthenticated) {
      console.log("➡️ Redirecting to Auth0 login...");
      await auth0Client.loginWithRedirect();
      return;
    }

    // 🎉 Logged in
    console.log("🎉 Login successful");

    // Show dashboard
    document.getElementById("content").style.display = "block";
    document.getElementById("topbar").style.display = "flex";

    // 👤 User info
    const user = await auth0Client.getUser();
    console.log("👤 User info:", user);

    if (user && document.getElementById("username")) {
      document.getElementById("username").textContent =
        user.name || user.email || "User";
    }

    // 🚪 Logout
    document.getElementById("logoutBtn").onclick = () => {
      auth0Client.logout({
        logoutParams: {
          returnTo: redirectUri
        }
      });
    };

  } catch (err) {
    console.error("❌ Auth0 fatal error:", err);
  }
});
