using System.Diagnostics;
using System.Runtime.InteropServices;

public static class DockerTestUtility {
    public static void ResetTestDBForLocalTests() {
        // Skip if in CI or not on a Mac/Linux
        if (Environment.GetEnvironmentVariable("CI") == "true" ||
            !RuntimeInformation.IsOSPlatform(OSPlatform.OSX)) return;

        var root = FindMonorepoRoot();

        var command = $"task backend:reset-test-db";

        var psi = new ProcessStartInfo {
            FileName = "/bin/zsh",
            Arguments = $"-c \"{command}\"",
            WorkingDirectory = root,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        Process.Start(psi)?.WaitForExit();
    }

    private static string FindMonorepoRoot() {
        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        while (dir != null && !File.Exists(Path.Combine(dir.FullName, "Taskfile.yml"))) {
            dir = dir.Parent;
        }
        return dir?.FullName ?? throw new Exception("Could not find monorepo root.");
    }
}
