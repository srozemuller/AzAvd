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
            var result = MsalHelper.GetTokenFromInteractiveFlow();
            Console.WriteLine($"Token is: {result.AccessToken}");
        }
    }
}
