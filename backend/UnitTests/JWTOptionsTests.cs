using System.ComponentModel.DataAnnotations;
using System.IdentityModel.Tokens.Jwt;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Options;

namespace UnitTests;

public class JWTOptionsTests {
    [Fact]
    public void ValidateRejectsKeyShorterThan256Bits() {
        var options = new JWTOptions {
            Key = "DiesIstEinTestSchluessel",
            Issuer = "Kommunal App"
        };

        var exception = Assert.Throws<ValidationException>(options.Validate);

        Assert.Equal("JWT:Key must contain at least 32 UTF-8 bytes for HS256.", exception.Message);
    }

    [Fact]
    public void ValidateAcceptsKeyWith256Bits() {
        var options = new JWTOptions {
            Key = "DiesIstEinTestSchluessel12345678",
            Issuer = "Kommunal App"
        };

        options.Validate();
    }

    [Fact]
    public void WriteTokenAcceptsConfiguredKey() {
        var options = new JWTOptions {
            Key = "DiesIstEinTestSchluessel12345678",
            Issuer = "Kommunal App"
        };
        var user = new Buerger {
            Id = Guid.NewGuid(),
            PersonalDataKeyEncryptedForBuerger = "test"
        };

        var token = new JwtSecurityTokenHandler().WriteToken(user.GetToken(options));

        Assert.NotEmpty(token);
    }
}
