using System.Management.Automation;
using Az.Avd.Cmdlets.Services;

namespace Az.Avd.Cmdlets.Commands.Public;

public class GetAvdHostpoolCommand
{
    [Cmdlet(VerbsCommon.Get, "AvdHostPool")]
    public class GetAvdHostpool : PSCmdlet
    {
        [Parameter(Position = 1, Mandatory = true)]
        public Guid subscriptionId { get; set; }

        [Parameter(Position = 2, Mandatory = true)]
        public string resourceGroupName { get; set; }

        [Parameter(Position = 3, Mandatory = true)]
        public string hostpoolName { get; set; }

        protected override void ProcessRecord()
        {
            var hostpoolService = new HostpoolService();
            var hostpoolResponse = hostpoolService.GetBySubscriptionAsync(subscriptionId).Result;
            var hostpoolDetails = hostpoolResponse?.Value?.ToList();

            if (hostpoolDetails is null)
            {
                // Handle error or no results found
                WriteError(new ErrorRecord(new Exception("Hostpool not found"), "HostpoolNotFound", ErrorCategory.ObjectNotFound, null));
            }

            // Write the result to the output stream
            foreach (var hp in hostpoolDetails)
            {
                Console.Write(hp.Name);
            }
        }
    }
}
