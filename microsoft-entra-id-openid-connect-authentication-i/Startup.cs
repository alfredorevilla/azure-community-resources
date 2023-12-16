

using System;
using System.Threading.Tasks;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(microsoft_entra_id_openid_connect_authentication_i.Startup))]

namespace microsoft_entra_id_openid_connect_authentication_i
{

    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
