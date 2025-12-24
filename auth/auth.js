document.addEventListener("DOMContentLoaded", async () => {
  try {
    const redirectUri = window.location.origin + window.location.pathname;

    const auth0Client = await auth0.createAuth0Client({
      domain: "dev-tbjltoa0gj3q6ken.us.auth0.com",
      clientId: "YZSOeNcMnGvmG07LjZFwB3yL6j3qZy9x",
      authorizationParams: {
        redirect_uri: redirectUri
      },
      cacheLocation: "localstorage",
      useRefreshTokens: true
    });

    if (
      window.location.search.includes("code=") &&
      window.location.search.includes("state=")
    ) {
      await auth0Client.handleRedirectCallback();
      window.history.replaceState({}, document.title, window.location.pathname);
    }

    const isAuthenticated = await auth0Client.isAuthenticated();
    if (!isAuthenticated) {
      await auth0Client.loginWithRedirect();
      return;
    }

    const user = await auth0Client.getUser();
    const username =  user?.name || user?.email ||user?.nickname || "User";

    document.body.classList.add("authenticated");

    const waitForNavbar = () =>
      new Promise((resolve) => {
        const interval = setInterval(() => {
          const navbar = document.querySelector(".navbar") || document.querySelector(".quarto-dashboard-header");
          if (navbar) {
            clearInterval(interval);
            resolve(navbar);
          }
        }, 200);
      });

    const navbar = await waitForNavbar();
    if (document.getElementById("auth-user-menu")) return;

    let rightWrapper = document.createElement("div");
    rightWrapper.id = "auth-user-menu";
    rightWrapper.style.marginLeft = "auto";
    rightWrapper.className = "d-flex align-items-center";
    
    rightWrapper.innerHTML = `
      <div class="dropdown">
        <a class="nav-link dropdown-toggle d-flex align-items-center" style="font-weight:500;color: #d1e6dcff;margin-right:15px;"
           href="#"
           role="button"
           data-bs-toggle="dropdown"
           aria-expanded="false">
           <i class="fas fa-user-circle me-1" style="font-size: 1.3rem; color: #d2d5d8ff; transition: color 0.3s;"
   onmouseover="this.style.color='#fafaf8ff';" 
   onmouseout="this.style.color='#d2d5d8ff';"></i>

           ${username}
        </a>
        <ul class="dropdown-menu dropdown-menu-end">
          <li>
            <button class="dropdown-item text-danger d-flex align-items-center" id="logoutBtn" style="font-weight:500;">
              <i class="fas fa-sign-out-alt me-2"></i> Logout
            </button>
          </li>
        </ul>
      </div>
    `;

    navbar.appendChild(rightWrapper);

    document.getElementById("logoutBtn").onclick = () => {
      auth0Client.logout({ logoutParams: { returnTo: redirectUri } });
    };

  } catch (err) {
    console.error("Auth0 error:", err);
  }
});
