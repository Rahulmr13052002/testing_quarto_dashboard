document.addEventListener("DOMContentLoaded", async () => {

  // Initialize Auth0
  const auth0Client = await auth0.createAuth0Client({
    domain: "dev-tbjltoa0gj3q6ken.us.auth0.com",
    clientId: "YZSOeNcMnGvmG07LjZFwB3yL6j3qZy9x",
    authorizationParams: {
      redirect_uri: window.location.origin
    }
  });

  // Handle redirect after login
  if (location.search.includes("code=") && location.search.includes("state=")) {
    await auth0Client.handleRedirectCallback();
    window.history.replaceState({}, document.title, window.location.pathname);
  }

  // Check login status
  const isAuthenticated = await auth0Client.isAuthenticated();

  if (!isAuthenticated) {
    await auth0Client.loginWithRedirect();
    return;
  }

  // Show dashboard
  document.getElementById("content").style.display = "block";

  // Get user details
  const user = await auth0Client.getUser();

  // Display username
  if (document.getElementById("username")) {
    console.log(user.name,user.email)
    document.getElementById("username").textContent = user.name || user.email;
  }

  // Logout
  if (document.getElementById("logoutBtn")) {
    document.getElementById("logoutBtn").addEventListener("click", () => {
      auth0Client.logout({
        logoutParams: { returnTo: window.location.origin }
      });
    });
  }
});
