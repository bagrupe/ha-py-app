(() => {
  const form = document.querySelector("[data-report-form]");
  if (!form) return;

  const location = form.querySelector("[data-report-location]");
  const details = form.querySelector("[data-report-details]");
  const next = document.querySelector("[data-report-next]");
  const send = document.querySelector("[data-report-send]");
  const error = form.querySelector("[data-report-location-error]");
  const address = form.querySelector("#adresse");
  const latitude = form.querySelector("#lat");
  const longitude = form.querySelector("#lng");
  const progress = document.querySelector(".flow-progress");
  const stepLabel = document.querySelector("[data-flow-step]");
  const photos = form.querySelector("#foto");
  const previews = form.querySelectorAll("[data-photo-preview]");
  const photoPickerLabel = form.querySelector("[data-photo-picker-label]");
  const photoCount = form.querySelector("[data-photo-count]");
  let previewUrls = [];
  const back = document.querySelector(".lagehelfer-footer__back");

  function showDetails(show, focus = true) {
    location.hidden = show;
    details.hidden = !show;
    next.hidden = show;
    send.hidden = !show;
    const step = show ? 3 : 2;
    progress.value = step;
    stepLabel.textContent = `Schritt ${step} von 4`;
    if (focus) {
      const heading = (show ? details : location).querySelector("h1");
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
    const url = new URL(form.dataset.nearby, window.location.href);
    url.searchParams.set("lat", form.querySelector("#lat").value);
    url.searchParams.set("lng", form.querySelector("#lng").value);
    url.searchParams.set("adresse", address.value);
    window.location.assign(url);
  }

  function updateLocation() {
    next.disabled = !latitude.value || !longitude.value;
    next.textContent = next.disabled ? "Bitte Standort wählen" : "Weiter";
  }

  function updatePhotos() {
    previewUrls.forEach(url => URL.revokeObjectURL(url));
    const files = Array.from(photos.files);
    previews[0].hidden = files.length < 3;
    const visiblePreviews = Array.from(previews).filter(preview => !preview.hidden);
    previewUrls = [];
    visiblePreviews.forEach((preview, index) => {
      preview.replaceChildren();
      if (!files[index]) return;
      const image = document.createElement("img");
      image.alt = "";
      image.src = URL.createObjectURL(files[index]);
      previewUrls.push(image.src);
      preview.append(image);
    });
    const tooMany = files.length > 3;
    photos.setCustomValidity(tooMany ? "Wählen Sie höchstens drei Fotos aus." : "");
    photoCount.textContent = tooMany ? "Wählen Sie höchstens drei Fotos aus." : files.length ? `${files.length} von 3 Fotos ausgewählt` : "";
    send.disabled = tooMany;
    // Keep the picker available so a selection can be replaced or cleared.
    photoPickerLabel.textContent = files.length ? "Auswahl ändern" : "Fotos auswählen";
  }

  updateLocation();
  latitude.addEventListener("change", updateLocation);
  photos.addEventListener("change", updatePhotos);
  updatePhotos();
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
