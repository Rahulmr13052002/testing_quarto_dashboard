document.addEventListener("DOMContentLoaded", async () => {
  try {
    console.log("🚀 Auth script loaded");

    const auth0Client = await auth0.createAuth0Client({
      domain: "dev-tbjltoa0gj3q6ken.us.auth0.com",
      clientId: "YZSOeNcMnGvmG07LjZFwB3yL6j3qZy9x",
      authorizationParams: {
        redirect_uri: "https://rahulmr13052002.github.io/testing_quarto_dashboard/"
      }
    });

    console.log("✅ Auth0 client initialized");

    if (
      window.location.search.includes("code=") &&
      window.location.search.includes("state=")
    ) {
      console.log("🔁 Handling redirect callback");
      await auth0Client.handleRedirectCallback();
      window.history.replaceState({}, document.title, window.location.pathname);
      console.log("✅ Redirect handled");
    }

    const isAuthenticated = await auth0Client.isAuthenticated();
    console.log("🔐 isAuthenticated:", isAuthenticated);

    if (!isAuthenticated) {
      console.log("➡️ Redirecting to Auth0 login");
      await auth0Client.loginWithRedirect();
      return;
    }

    console.log("🎉 Login successfulja success");

    document.getElementById("content").style.display = "block";
    document.getElementById("topbar").style.display = "flex";

    const user = await auth0Client.getUser();
    console.log("👤 User info:", user);

    document.getElementById("username").textContent =
      user.name || user.email || "User";

    document.getElementById("logoutBtn").onclick = () => {
      auth0Client.logout({
        logoutParams: {
          returnTo: "https://rahulmr13052002.github.io/testing_quarto_dashboard/"
        }
      });
    };

  } catch (err) {
    console.error("❌ Auth0 fatal error:", err);
  }
});
