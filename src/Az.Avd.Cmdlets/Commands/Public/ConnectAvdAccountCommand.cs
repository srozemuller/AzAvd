using Az.Avd.Core.Helpers;

namespace Az.Avd.Cmdlets.Commands.Public;
using System.Management.Automation;

public class ConnectAvdAccountCommand
{
    [Cmdlet(VerbsCommunications.Connect, "AvdAccount")]
    public class ConnectAvdAccountDeviceCodeCommand : PSCmdlet
    {
        [Parameter(Position = 1, Mandatory = true)]
        [ValidateSet("Interactive","Device","ClientSecret")]
        public string Mode { get; set; }

        protected override void ProcessRecord()
        {
            switch (Mode)
            {
                case "Device":
                {
                    var token = MsalHelper.GetATokenForGraph();
                    Console.WriteLine("DeviceFlow");
                    break;
                }
                case "Interactive":
                {
                    var token = MsalHelper.GetTokenFromInteractiveFlow();
                    break;
                }
            }
        }
    }
}
