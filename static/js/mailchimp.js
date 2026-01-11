(function () {
  const form = document.getElementById("mc-form");
  const emailInput = document.getElementById("mc-email");
  const message = document.getElementById("mc-message");

  if (!form) return;

  form.addEventListener("submit", function (e) {
    e.preventDefault();

    message.textContent = "";
    message.className = "mc-message";

    const email = emailInput.value.trim();

    if (!email || !email.includes("@")) {
      message.textContent = "Please enter a valid email address.";
      message.classList.add("error");
      return;
    }

    const url =
      "https://amitashukla.us16.list-manage.com/subscribe/post-json" +
      "?u=9618da8096ab249006808edd2" +
      "&id=a6e4c110bf" +
      "&c=?";

    const data = new FormData(form);

    const params = new URLSearchParams(data);
    params.set("EMAIL", email);

    fetch(url + "&" + params.toString(), {
      method: "GET",
      mode: "no-cors",
    });

    message.textContent =
      "Almost there! Check your inbox to confirm subscription.";
    message.classList.add("success");

    emailInput.value = "";
  });
})();
