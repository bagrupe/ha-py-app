using Moq;
using Quartz;

namespace IntegrationTests;

internal static class JobExecutionContextTestHelper {
    public static IJobExecutionContext Create(string jobName, TimeSpan? jobRunTime = null) {
        var context = new Mock<IJobExecutionContext>();
        object? result = null;

        context.Setup(c => c.JobDetail.Key).Returns(new JobKey(jobName));
        context.Setup(c => c.JobRunTime).Returns(jobRunTime ?? TimeSpan.Zero);
        context.SetupSet(c => c.Result = It.IsAny<object>()).Callback<object>(value => result = value);
        context.SetupGet(c => c.Result).Returns(() => result);

        return context.Object;
    }
}
