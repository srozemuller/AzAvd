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
        var responseBody = ApiClient.GetAsync(url);
        if (responseBody != null)
        {
            return JsonConvert.DeserializeObject<List<Hostpool>?>(responseBody);
        }
        return null;
    }
}
