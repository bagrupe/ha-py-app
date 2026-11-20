// Prints fresh development seed secrets as dotenv lines. Keep the output stable:
// data seeded with one key set cannot be decrypted with another.
open System
open System.Security.Cryptography

let rsaXml () = (RSA.Create 4096).ToXmlString true

printfn "SEED_KOMMUNE_RSA_XML='%s'" (rsaXml ())
printfn "SEED_BUERGER_RSA_XML='%s'" (rsaXml ())
printfn "SEED_KOMMUNE_ENCRYPTION_KEY='%s'" (Convert.ToBase64String(RandomNumberGenerator.GetBytes 32))
