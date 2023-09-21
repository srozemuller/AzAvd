using Az.Avd.Core.Helpers;

namespace Az.Avd.Cmdlets.Commands.Public;
using System.Management.Automation;

public class ConnectAvdAccountCommand
{
    [Cmdlet(VerbsCommunications.Connect, "AvdAccount")]
    public class ConnectAvdAccountDeviceCodeCommand : PSCmdlet
    {
        [Parameter(Position=1,ParameterSetName = "DeviceCode")]
        public Guid TenantId { get; set; }
        
        

        protected override void ProcessRecord()
        {
            var authClient = new AuthClient();
            var token = authClient.GetDeviceToken(TenantId);
            var result = authClient.GetTokenFromInteractiveFlow();
        }
    }
}

