using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;

namespace BotDetection
{
   // [HubName("updateHub")]
    public class UpdateHub : Hub
    {
        public void Send(string name, string message)
        {
        }
    }
}