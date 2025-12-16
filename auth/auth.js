document.addEventListener("DOMContentLoaded", async () => {
  try {
    console.log("🚀 Auth script loaded");

    const auth0Client = await auth0.createAuth0Client({
      domain: "dev-tbjltoa0gj3q6ken.us.auth0.com",
      clientId: "YZSOeNcMnGvmG07LjZFwB3yL6j3qZy9x",
      authorizationParams: {
        redirect_uri: "https://rahulmr13052002.github.io/testing_quarto_dashboard/"
        // redirect_uri: window.location.origin
      }
    });

    console.log("✅ Auth0 client initialized");

    // Handle login redirect
    if (
      window.location.search.includes("code=") &&
      window.location.search.includes("state=")
    ) {
      console.log("🔁 Handling Auth0 redirect callback...");
      await auth0Client.handleRedirectCallback();
      window.history.replaceState({}, document.title, window.location.pathname);
      console.log("✅ Redirect callback handled");
    }

    const isAuthenticated = await auth0Client.isAuthenticated();
    console.log("🔐 isAuthenticated:", isAuthenticated);

    if (!isAuthenticated) {
      console.log("➡️ User not authenticated. Redirecting to login...");
      await auth0Client.loginWithRedirect();
      return;
    }

    // ✅ USER IS LOGGED IN HERE
    console.log("🎉 User successfully logged in");

    // Show dashboard content
    document.getElementById("content").style.display = "block";
    document.getElementById("topbar").style.display = "flex";

    // Get user info
    const user = await auth0Client.getUser();
    console.log("👤 Auth0 User Info:", user);

    if (user) {
      console.log("📧 Email:", user.email);
      console.log("🆔 Sub:", user.sub);
      console.log("🖼 Picture:", user.picture);
      console.log("🕒 Updated At:", user.updated_at);
    }

    if (document.getElementById("username")) {
      document.getElementById("username").textContent =
        user.name || user.email || "User";
    }

    // Logout
    document.getElementById("logoutBtn").onclick = () => {
      console.log("🚪 Logging out user...");
      auth0Client.logout({
        logoutParams: {
          returnTo: window.location.origin
        }
      });
    };

  } catch (error) {
    console.error("❌ Auth0 Error:", error);
  }
});
