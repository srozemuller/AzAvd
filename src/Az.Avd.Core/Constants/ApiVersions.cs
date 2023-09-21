namespace Az.Avd.Core.Constants;

public class ApiVersions
{
    private const string AvdApiVersion = "2022-02-10-preview";
    const string sessionHostApiVersion = "2022-02-10-preview";
    const string vmApiVersion = "2022-11-01";
    const string hostpoolApiVersion = "2022-02-10-preview";
    const string applicationGroupApiVersion = "2022-02-10-preview";
    const string workspaceApiVersion = "2022-02-10-preview";
    private const string diagnosticsApiVersion = "2020-08-01";
    private const string avdDiagnosticsApiVersion = "2021-05-01-preview";
    private const string workbookApiVersion = "2021-08-01";
    private const string virtualMachineVersion = "2023-03-01";
    private const string scalingPlanApiVersion = "2023-03-21-privatepreview";
    private const string scalingPlanScheduleApiVersion = "2022-10-14-preview";
}

public class ApiUrls
{
    public const string AzureApiUrl = "https://management.azure.com";
    public const string AzureApiScope = "https://management.azure.com//.default";
    private const string GraphApiUrl = "https://graph.microsoft.com";
    private const string GraphApiVersion = "beta";
}

public class AppInfo
{
    public const string AzurePowerShellApp = "1950a258-227b-4e31-a9cf-717495945fc2";
}