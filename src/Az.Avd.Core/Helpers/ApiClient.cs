

namespace Az.Avd.Core.Helpers;

using System;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;

public class ApiClient
{
    public static async Task<List<string[]>?> GetAsync(string url)
    {
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
                    Console.WriteLine(responseBody);
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
