import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const environment = process.env.SENTRY_ENVIRONMENT ?? 'local';
const release = process.env.CI_COMMIT_REF_SLUG ?? "none";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const fileName = "generatedGitInfo.json";

const workspaces = ["bereich-a", "bereich-b", "stele"];
const gitInfo = JSON.stringify({ environment, release }, null, 2) + "\n";

for (const workspace of workspaces) {
  fs.writeFileSync(
    path.resolve(__dirname, workspace, "src", fileName),
    gitInfo,
  );
}
