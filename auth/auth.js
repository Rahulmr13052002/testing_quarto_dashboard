document.addEventListener("DOMContentLoaded", async () => {

  const auth0Client = await auth0.createAuth0Client({
    domain: "dev-tbjltoa0gj3q6ken.us.auth0.com",
    clientId: "YZSOeNcMnGvmG07LjZFwB3yL6j3qZy9x",
    authorizationParams: {
      //redirect_uri: "https://rahulmr13052002.github.io/testing_quarto_dashboard/"
      redirect_uri: window.location.origin
    }
  });

  // Handle login redirect
  if (location.search.includes("code=") && location.search.includes("state=")) {
    await auth0Client.handleRedirectCallback();
    window.history.replaceState({}, document.title, window.location.pathname);
  }

  const isAuthenticated = await auth0Client.isAuthenticated();

  if (!isAuthenticated) {
    await auth0Client.loginWithRedirect();
    return;
  }

  // ✅ Show dashboard content
  document.getElementById("content").style.display = "block";
  document.getElementById("topbar").style.display = "flex";

  // ✅ Get user info
  const user = await auth0Client.getUser();

  if (document.getElementById("username")) {
    document.getElementById("username").textContent =
      user.name || user.email || "User";
  }

  // Logout
  document.getElementById("logoutBtn").onclick = () => {
    auth0Client.logout({
      logoutParams: {
        returnTo: window.location.origin
      }
    });
  };

});
