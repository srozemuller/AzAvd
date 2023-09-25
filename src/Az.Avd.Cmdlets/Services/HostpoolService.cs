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
        
        var url = $"{ApiUrls.AzureApiUrl}/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.DesktopVirtualization/hostpools/{hostpoolName}?api-version={ApiVersions.HostpoolApiVersion}";
        var responseBody = ApiClient.Get(url);
        var responseJson = JsonConvert.DeserializeObject<HostPoolResource>(responseBody);
    }
}
