

namespace Az.Avd.Core.Helpers;

using System;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;

public class ApiClient
{
    public static async Task Get(string url)
    {
        var httpClient = new HttpClient();
        var token = Environment.GetEnvironmentVariable("token");
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
                    var responseJson = JsonConvert.DeserializeObject(responseBody);
                    Console.WriteLine(responseJson);
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
    }
}
