using Microsoft.Identity.Client;

namespace Az.Avd.Core.Helpers;

public interface IAuthClient
{
    public Task<AuthenticationResult?> GetTokenFromDeviceFlow();
    public AuthenticationResult? GetTokenFromInteractiveFlow();
    public AuthenticationResult? GetTokenFromInteractiveFlow();
}