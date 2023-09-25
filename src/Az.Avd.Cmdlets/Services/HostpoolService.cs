using Az.Avd.Cmdlets.Models;
using Az.Avd.Core.Constants;
using Az.Avd.Core.Helpers;
using System.Text.Json;

namespace Az.Avd.Cmdlets.Services;

public interface IHostpoolService
{
    Task<List<Hostpool>?> GetBySubscription(Guid subscriptionId);
}

public sealed class HostpoolService : IHostpoolService
{
    private readonly HttpClient _http = new();

    public async Task<List<Hostpool>?> GetBySubscription(Guid subscriptionId)
    {
        var url = $"{ApiUrls.AzureApiUrl}/subscriptions/{subscriptionId}/providers/Microsoft.DesktopVirtualization/hostpools?api-version={ApiVersions.HostpoolApiVersion}";
        var token = MsalHelper.GetTokenFromInteractiveFlow().AccessToken;

        _http.DefaultRequestHeaders.Clear();
        _http.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}");

        try
        {
            // Make a GET request to a specific endpoint
            Console.WriteLine($"Sending request to: {url}");
            var response = await _http.GetAsync(url);

            // Check if the request was successful
            if (!response.IsSuccessStatusCode)
            {
                Console.WriteLine($"HTTP Request Error: {response.StatusCode} - {response.ReasonPhrase}");
            }

            // Read the response content as a string
            var responseStream = await response.Content.ReadAsStreamAsync();
            var result = await JsonSerializer.DeserializeAsync<List<Hostpool>?>(responseStream);

            Console.Write(result);

            return result; // <-- This is the result we want to return
        }
        catch (HttpRequestException e)
        {
            Console.WriteLine($"HTTP Request Exception: {e.Message}");
        }

        return null;
    }
}
