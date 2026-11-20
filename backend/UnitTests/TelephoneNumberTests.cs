using API.Features.Auth;

namespace UnitTests;

public class TelephoneNumberTests {
    [Fact]
    public void ValidateTelephoneNumbers() {
        Assert.True(EhrenamtsbankAuthService.ValidatePhoneNumber("+49 170 1234567"));
        Assert.True(EhrenamtsbankAuthService.ValidatePhoneNumber("+49 1575 8174230"));
        Assert.True(EhrenamtsbankAuthService.ValidatePhoneNumber("+49157581742"));
        Assert.False(EhrenamtsbankAuthService.ValidatePhoneNumber("+1 555 123 4567"));
        Assert.False(EhrenamtsbankAuthService.ValidatePhoneNumber("+43 1 234567"));
        Assert.False(EhrenamtsbankAuthService.ValidatePhoneNumber("+33612345678"));
        Assert.False(EhrenamtsbankAuthService.ValidatePhoneNumber("0170 1234567"));
        Assert.False(EhrenamtsbankAuthService.ValidatePhoneNumber("0049 170 1234567"));
        Assert.False(EhrenamtsbankAuthService.ValidatePhoneNumber("+49 12"));
        Assert.False(EhrenamtsbankAuthService.ValidatePhoneNumber("+49157583"));
        Assert.False(EhrenamtsbankAuthService.ValidatePhoneNumber("+12345678901234567"));
    }
}
