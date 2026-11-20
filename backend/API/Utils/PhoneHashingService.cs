/// <summary>
/// wird benutzt zum Hashen der Telefonnummer (DVGO-konformes siehe User.cs, Buerger-Entity)
/// </summary>
public static class PhoneHashingService {
    private static string? _salt;

    public static void Initialize(string salt) => _salt = salt;

    public static string? ComputeHash(string? phone) {
        if (string.IsNullOrEmpty(phone)) return null;
        if (string.IsNullOrEmpty(_salt)) throw new InvalidOperationException("Phone-Salt wurde nicht initialisiert!");
        phone = new string(phone.Where(c => char.IsDigit(c) || c == '+').ToArray());
        using var hmac = new System.Security.Cryptography.HMACSHA256(System.Text.Encoding.UTF8.GetBytes(_salt));
        var hashBytes = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(phone));
        return Convert.ToHexString(hashBytes).ToLower();
    }
}
