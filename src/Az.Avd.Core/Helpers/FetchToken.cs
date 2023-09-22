using System.Diagnostics;
using Az.Avd.Core.Constants;
using Microsoft.Identity.Client;

namespace Az.Avd.Core.Helpers;

public class FetchToken
{
    public static async Task FromCache()
    {
        var pca = PublicClientApplicationBuilder
            .Create(AppInfo.AzurePowerShellApp)
            .WithAuthority(ApiUrls.AzureApiUrl)
            .WithDefaultRedirectUri()
            .Build();

        var accounts = await pca.GetAccountsAsync();
        try
        {
            var token = await pca.AcquireTokenSilent(new[] { ApiUrls.AzureApiScope }, accounts.FirstOrDefault())
                .ExecuteAsync();
            Console.WriteLine($"{token}");
        }
        catch (MsalUiRequiredException ex)
        {
            Console.WriteLine($"Error Acquiring Token:{System.Environment.NewLine}{ex.Message}");
        }
    }
}