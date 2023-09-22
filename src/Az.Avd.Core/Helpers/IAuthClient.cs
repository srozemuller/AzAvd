using Microsoft.Identity.Client;

namespace Az.Avd.Core.Helpers;

public interface IAuthClient
{
    public Task<AuthenticationResult?> GetTokenFromDeviceFlow();
    public Task<AuthenticationResult?> GetTokenFromInteractiveFlow();
}
