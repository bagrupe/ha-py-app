// Enable only when the device already has a local German recognition model.
const button = document.getElementById("diktieren");
const description = document.getElementById("beschreibung");
const status = document.getElementById("diktat-status");
const Recognition = window.SpeechRecognition;

async function prepareDictation() {
  if (!button || !description || !Recognition?.available ||
      !("processLocally" in Recognition.prototype)) return;

  const lang = "de-DE";
  if (await Recognition.available({ langs: [lang], processLocally: true }) !== "available") return;
  const recognition = new Recognition();
  recognition.lang = lang;
  recognition.processLocally = true;
  recognition.onresult = event => {
    const text = event.results[event.resultIndex][0].transcript.trim();
    if (text) {
      description.value = [description.value.trimEnd(), text].filter(Boolean).join(" ");
      description.dispatchEvent(new Event("input", { bubbles: true }));
      status.textContent = "Bitte prüfen Sie den erkannten Text.";
    }
  };
  recognition.onerror = () => {
    status.textContent = "Die Spracheingabe ist fehlgeschlagen. Sie können die Beschreibung eintippen.";
  };
  recognition.onend = () => { button.disabled = false; };
  button.addEventListener("click", () => {
    try {
      recognition.start();
      button.disabled = true;
      status.textContent = "Bitte sprechen Sie.";
    } catch {
      recognition.onerror();
    }
  });
  window.addEventListener("pagehide", () => recognition.abort());
  button.hidden = false;
}

// Unsupported or restricted WebViews retain the ordinary text field.
prepareDictation().catch(() => {});
