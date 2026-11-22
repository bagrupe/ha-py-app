(() => {
  const form = document.querySelector("[data-report-form]");
  if (!form) return;

  const location = form.querySelector("[data-report-location]");
  const details = form.querySelector("[data-report-details]");
  const next = document.querySelector("[data-report-next]");
  const send = document.querySelector("[data-report-send]");
  const error = form.querySelector("[data-report-location-error]");
  const address = form.querySelector("#adresse");
  const back = document.querySelector(".lagehelfer-footer__back");

  function showDetails(show, focus = true) {
    location.hidden = show;
    details.hidden = !show;
    next.hidden = show;
    send.hidden = !show;
    if (focus) {
      const heading = (show ? details : location).querySelector("h2");
      heading.focus({ preventScroll: true });
      heading.scrollIntoView({ block: "start" });
    }
  }

  function advance() {
    if (form.hasAttribute("data-require-location") &&
        (!form.querySelector("#lat").value || !form.querySelector("#lng").value)) {
      error.hidden = false;
      address.setAttribute("aria-invalid", "true");
      address.setAttribute("aria-describedby", form.querySelector("#address-error") ? "address-error location-error" : "location-error");
      address.focus();
      return;
    }
    error.hidden = true;
    if (form.querySelector("#address-error")) {
      address.setAttribute("aria-describedby", "address-error");
    } else {
      address.removeAttribute("aria-invalid");
      address.removeAttribute("aria-describedby");
    }
    showDetails(true);
  }

  showDetails(form.dataset.startDetails === "true", false);
  form.querySelector("[data-report-summary]")?.focus();
  next.addEventListener("click", advance);
  form.addEventListener("submit", event => {
    if (!details.hidden) return;
    event.preventDefault();
    advance();
  });
  back?.addEventListener("click", event => {
    if (details.hidden) return;
    event.preventDefault();
    showDetails(false);
  });
})();
