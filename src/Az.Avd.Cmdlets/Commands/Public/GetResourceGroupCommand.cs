using Az.Avd.Constants;

namespace Az.Avd.Commands.Public;
using Az.Avd.Helpers;

public class GetResourceGroupCommand
{
    public async Task<string> GetResourceGroupsAsync()
    {
        try
        {
            var response =
                await HttpClient.GetAsync(
                    $"{ApiUrls.AzureApiUrl}/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups?api-version=2021-04-01");

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadAsStringAsync();
            }
            else
            {
                throw new Exception($"Error: ");
            }
        }
        catch (Exception ex)
        {
            throw new Exception($"Exception: {ex.Message}");
        }
    }
}