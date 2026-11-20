using API.Features.Ehrenamtsbank;
using API.Features.Ehrenamtsbank.Queries;

namespace UnitTests;

using Status = EhrenamtsbankTransaktionStatus;

public class EhrenamtsbankZeitkontoLogicTest {
    private const int StartCreditMinutes = 180;

    private static EhrenamtsbankTransaktion Transaktion(Status status, int minutes, Guid giverId, Guid receiverId) =>
        new() {
            Id = Guid.NewGuid(),
            Status = status,
            Minutes = minutes,
            GiverId = giverId,
            ReceiverId = receiverId
        };

    private static EhrenamtsbankZeitkonto Zeitkonto(Guid buergerId, params EhrenamtsbankTransaktion[] rows) {
        var counted = rows.AsQueryable().Where(ZeitkontoQueries.CountsTowardBalance);
        return new EhrenamtsbankZeitkonto(
            StartCreditMinutes,
            counted.Where(t => t.GiverId == buergerId).Sum(t => t.Minutes),
            counted.Where(t => t.ReceiverId == buergerId).Sum(t => t.Minutes));
    }

    [Fact]
    public void OhneBuchungen_IstDerSaldoDasStartguthaben() {
        var zeitkonto = Zeitkonto(Guid.NewGuid());

        Assert.Equal(StartCreditMinutes, zeitkonto.StartCreditMinutes);
        Assert.Equal(0, zeitkonto.CreditMinutes);
        Assert.Equal(0, zeitkonto.DebitMinutes);
        Assert.Equal(StartCreditMinutes, zeitkonto.BalanceMinutes);
    }

    [Fact]
    public void MehrBelastungAlsGuthaben_ErgibtNegativenSaldo() {
        var buergerId = Guid.NewGuid();
        var other = Guid.NewGuid();

        var zeitkonto = Zeitkonto(buergerId,
            Transaktion(Status.Confirmed, 30, buergerId, other),
            Transaktion(Status.Confirmed, 400, other, buergerId));

        Assert.Equal(-190, zeitkonto.BalanceMinutes);
    }

    [Fact]
    public void CancelledZaehltNicht_ConfirmedUndAdjustedSchon() {
        var buergerId = Guid.NewGuid();
        var other = Guid.NewGuid();

        var zeitkonto = Zeitkonto(buergerId,
            Transaktion(Status.Confirmed, 60, buergerId, other),
            Transaktion(Status.Adjusted, 30, buergerId, other),
            Transaktion(Status.Cancelled, 999, buergerId, other),
            Transaktion(Status.Confirmed, 45, other, buergerId),
            Transaktion(Status.Cancelled, 999, other, buergerId));

        Assert.Equal(90, zeitkonto.CreditMinutes);
        Assert.Equal(45, zeitkonto.DebitMinutes);
        Assert.Equal(225, zeitkonto.BalanceMinutes);
    }
}
