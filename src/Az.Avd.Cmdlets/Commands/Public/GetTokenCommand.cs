using Az.Avd.Core.Helpers;
using System.Management.Automation;

namespace Az.Avd.Cmdlets.Commands.Public;

public class GetTokenCommand
{
    [Cmdlet(VerbsCommon.Get, "Token")]
    public class GetToken : PSCmdlet
    {
        
        protected override void ProcessRecord()
        {
            var authClient = new AuthClient();
            var token = Environment.GetEnvironmentVariable("token");
            Console.WriteLine($"Token is: {token}");
        }
    }
}