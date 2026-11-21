// Nur Browser-APIs, die serverseitig nicht gehen: Karte, Standort und Foto-Vorschau.
// Formular, Validierung und Versand laufen in Melden.cshtml.cs.
(() => {
  if (!document.getElementById("map")) return;

  const HAMELN = [51.1037, 9.3597];
  const NOMINATIM = "https://nominatim.openstreetmap.org";

  const addressInput = document.getElementById("adresse");
  const latInput = document.getElementById("lat");
  const lngInput = document.getElementById("lng");
  const sourceInput = document.getElementById("standortQuelle");
  const mapStatus = document.getElementById("mapStatus");
  const setStatus = text => { mapStatus.textContent = text; };

  let map, marker, addressDirty = false, reverseSeq = 0;

  function placeAt(latlng, source, address) {
    marker.setLatLng(latlng);
    map.panTo(latlng);
    latInput.value = latlng.lat.toFixed(6);
    lngInput.value = latlng.lng.toFixed(6);
    sourceInput.value = source;
    if (source === "pin") addressDirty = false;
    if (address) setAddress(address); else reverseGeocode(latlng);
  }

  function setAddress(text) {
    addressInput.value = text;
    addressDirty = false;
  }

  function locate() {
    if (!navigator.geolocation) return setStatus("Standort nicht unterstützt. Gib eine Adresse ein.");
    setStatus("Standort wird ermittelt …");
    navigator.geolocation.getCurrentPosition(
      position => {
        const latlng = L.latLng(position.coords.latitude, position.coords.longitude);
        map.setView(latlng, 16);
        placeAt(latlng, "gps");
        setStatus("Dein aktueller Standort. Du kannst den Pin verschieben.");
      },
      () => setStatus("Standort nicht verfügbar. Gib eine Adresse ein oder tippe auf die Karte."),
      { enableHighAccuracy: true, timeout: 10000 });
  }

  async function searchAddress() {
    const query = addressInput.value.trim();
    if (!query) return;
    setStatus("Suche …");
    try {
      const response = await fetch(`${NOMINATIM}/search?format=jsonv2&limit=1&countrycodes=de&accept-language=de&q=${encodeURIComponent(query)}`);
      const results = await response.json();
      if (!results.length) return setStatus("Adresse nicht gefunden.");
      const latlng = L.latLng(+results[0].lat, +results[0].lon);
      map.setView(latlng, 17);
      placeAt(latlng, "adresse", results[0].display_name);
      setStatus("Adresse gefunden. Du kannst den Pin verschieben.");
    } catch {
      setStatus("Suche fehlgeschlagen. Prüfe deine Verbindung.");
    }
  }

  async function reverseGeocode(latlng) {
    const mine = ++reverseSeq;
    try {
      const response = await fetch(`${NOMINATIM}/reverse?format=jsonv2&accept-language=de&lat=${latlng.lat}&lon=${latlng.lng}`);
      const result = await response.json();
      if (result.display_name && mine === reverseSeq && !addressDirty) setAddress(result.display_name);
    } catch { /* keep whatever is in the field */ }
  }

  function initMap() {
    if (typeof L === "undefined") return setStatus("Karte konnte nicht geladen werden.");

    const hasPin = latInput.value !== "" && lngInput.value !== "";
    const start = hasPin ? [Number(latInput.value), Number(lngInput.value)] : HAMELN;
    map = L.map("map").setView(start, hasPin ? 16 : 13);
    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      { maxZoom: 19, attribution: "&copy; OpenStreetMap-Mitwirkende" }).addTo(map);
    marker = L.marker(start, { draggable: true }).addTo(map);
    marker.on("dragend", () => placeAt(marker.getLatLng(), "pin"));
    map.on("click", event => placeAt(event.latlng, "pin"));

    document.getElementById("searchBtn").addEventListener("click", searchAddress);
    document.getElementById("locateBtn").addEventListener("click", () => { addressDirty = false; locate(); });
    addressInput.addEventListener("keydown", event => {
      if (event.key === "Enter") { event.preventDefault(); searchAddress(); }
    });
    addressInput.addEventListener("input", () => {
      addressDirty = true;
      setStatus("Drücke „Suchen“, um den Pin auf diese Adresse zu setzen.");
    });

    if (!hasPin) locate();
  }

  const photoInput = document.getElementById("foto");
  const photoButton = document.getElementById("fotoBtn");
  const photoPreview = document.getElementById("fotoPreview");
  const photoRemove = document.getElementById("fotoRemove");

  function clearPhoto() {
    if (photoPreview.src) URL.revokeObjectURL(photoPreview.src);
    photoInput.value = "";
    photoPreview.hidden = photoRemove.hidden = true;
    photoPreview.removeAttribute("src");
    photoButton.textContent = "📷 Foto aufnehmen";
  }

  photoButton.addEventListener("click", () => photoInput.click());
  photoRemove.addEventListener("click", clearPhoto);
  photoInput.addEventListener("change", () => {
    const file = photoInput.files[0];
    if (!file) return clearPhoto();
    if (photoPreview.src) URL.revokeObjectURL(photoPreview.src);
    photoPreview.src = URL.createObjectURL(file);
    photoPreview.hidden = photoRemove.hidden = false;
    photoButton.textContent = "📷 Anderes Foto aufnehmen";
  });

  initMap();
})();
