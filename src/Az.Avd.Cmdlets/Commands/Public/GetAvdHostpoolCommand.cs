using System.Management.Automation; 
using Az.Avd.Core.Helpers;
namespace Az.Avd.Cmdlets.Commands.Public;


public class GetAvdHostpoolCommand
{
    [Cmdlet(VerbsCommon.Get, "AvdHostPool")]
    public class ConnectAvdAccountDeviceCodeCommand : PSCmdlet
    {
        [Parameter(Position = 1, Mandatory = true)]
        public string subscriptionId { get; set; }
        [Parameter(Position = 2, Mandatory = true)]
        public string resourceGroupName { get; set; }
        
        [Parameter(Position = 3, Mandatory = true)]
        public string hostpoolName { get; set; }
        
        protected override void ProcessRecord()
        {
            var authClient = new AuthClient();

            var hostpool = HostPoolResource.Get(subscriptionId, resourceGroupName, hostpoolName);

        }
    }
}