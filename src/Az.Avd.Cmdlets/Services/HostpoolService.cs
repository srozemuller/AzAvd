using System.Globalization;
using Az.Avd.Cmdlets.Commands.Public;
using Az.Avd.Cmdlets.Models;
using Az.Avd.Core.Constants;
using Az.Avd.Core.Helpers;
using Azure.ResourceManager.DesktopVirtualization;
using Newtonsoft.Json;

namespace Az.Avd.Cmdlets.Services;

public interface IHostpoolService
{
    Task<List<Hostpool>?> GetBySubscription(Guid subscriptionId);
}


public sealed class HostpoolService : IHostpoolService
{
    public async Task<List<Hostpool>?> GetBySubscription(Guid subscriptionId)
    {
        
        var url = $"{ApiUrls.AzureApiUrl}/subscriptions/{subscriptionId}/providers/Microsoft.DesktopVirtualization/hostpools?api-version={ApiVersions.HostpoolApiVersion}";
        var httpClient = new HttpClient();
        var token = MsalHelper.GetTokenFromInteractiveFlow().AccessToken;
        httpClient.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}");
        {
            try
            {
                // Make a GET request to a specific endpoint
                Console.WriteLine($"Sending request to: {url}");
                HttpResponseMessage response = await httpClient.GetAsync(url);

                // Check if the request was successful
                if (response.IsSuccessStatusCode)
                {
                    // Read the response content as a string
                    string responseBody = await response.Content.ReadAsStringAsync();
                    var goodBody = JsonConvert.DeserializeObject<List<Hostpool>?>(responseBody);
                    Console.WriteLine(response);
                }
                else
                {
                    Console.WriteLine($"HTTP Request Error: {response.StatusCode} - {response.ReasonPhrase}");
                    
                }
            }
            catch (HttpRequestException e)
            {
                Console.WriteLine($"HTTP Request Exception: {e.Message}");
            }
        }
        return null;
    }
}
