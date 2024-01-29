import com.microsoft.aad.msal4j.AuthorizationCodeParameters;
import com.microsoft.aad.msal4j.ClientCredentialFactory;
import com.microsoft.aad.msal4j.ConfidentialClientApplication;
import com.microsoft.aad.msal4j.IAuthenticationResult;
import com.microsoft.aad.msal4j.IClientCredential;

public class main {
    public static void main(String[] args) {

        String PUBLIC_CLIENT_ID = "8cdf330b-158b-4991-8872-0f6ed4739d55";
        String AUTHORITY = "https://login.microsoftonline.com/22a84c88-253a-4025-a5c4-e0dc365b8d17";
        String CLIENT_SECRET = "rr88Q~HZM-RJ2-T9-rgHSc6nJSSmGDsFbbv1ubT-";

        IClientCredential credential = ClientCredentialFactory.createFromSecret(CLIENT_SECRET);
        ConfidentialClientApplication app = ConfidentialClientApplication
                .builder(PUBLIC_CLIENT_ID, credential)
                .authority(AUTHORITY)
                .build();

        IAuthenticationResult result = app
                .acquireToken(
                        new AuthorizationCodeParameters("0.ARoAiEyoIjolJUClxODcNluNFwsz34yLFZFJiHIPbtRznVUaALc.AgABAAIAAAAmoFfGtYxvRrNriQdPKIZ-AgDs_wUA9P_f84GrVdK2KvUMDo1aWYiVeLdAQUeH6ZpJcPWZR6XhE_QbtYaQwgQ2rLJ7qwgRymceK3b9NxrFufZTo1YArhLtdzvZBrlKo8Bd-BjIyaF-GGyGNb_DrQ7xfN_U7AYxVgU2hpF8YP6vp5X_8UtD16OAd_6OKnexwM2JDyeyZlKqLFIRiD6co9eyfogrof5vgsqke0x7IWJY9G0krls1Xr5EgwXiLCNuX7owrKf6q7XOuEk-GvqIxRAXPj0s0zBjM2MGN1l-MiQJS76QH2ggP8ZYgrAJyPbrlNLDKaL_8k_lZiIawu62dfy2O3s3tIl9P5V8tZEl5bWVJDK2FHYK0HKq5msujcoO_ScxknpnMeu73mvKU9CQZU2aDy-lh8-9ZB2Jgj55EwyBr2Skw3NuBCarP2m-SRWofct4jTK9uhBpiZF5z095COG77qIaRrlQn3oU4GZyU1TCzvG2VnMOI4fi1LLoBjuYqdey6gEphoDHTjMo91A32D80gx5aXHzjNDsukKFoxQ3ZZkscCgyjUdUpfVxjirjSboaNQUNJ1bFrFbxqLfOJM7BIbNAY8LNaaYbMKbtS1BItI5sLykXJKb7gDqrp5yv3VazvsrFd97AGGwhGDjoVVe96dwnDqM0T-5AH7QN5hfQ6didyVDWGZnOFwsPSlaHnF6IaVRRHvnPLvwalFc_5bovL7t2Wur6BVr98xp0hmAFxVC4LNNXo5gxOMChY8rx7UCv80hRTqL39mZZXcazYYc-7nEnPJepkQOyz68FruxD1OdnGCc3w5G_He1zUcooO4NyXLzbfjq3q6_30uBIu_XRIcmmkNasCKR2Ftxdx1VdhNKFTArv2Ktif03GMD-8U_Nc5RN8N7SXvAtZkk20LbHXPQyVBBdF2FBC7-IGfcKZuX0VQZD8auASP3jkRgrz8fkMrptR8aziJLhK8glsgW_ysNfsuVmk5RWW8NLMkoQWdsEoIJJ1ZMbBCyH_pvIDGHu7jTB2x0OUdjMVRC8Vc1PdX9SLx2tlSUHUIn-iR5OaaGcOymEc9DVXuQUPck-j8IR5Q-Du8Jci-FA&state=12345&session_state=2bdebe3f-9fb3-4d55-8e60-6160f058c762&device_tenant_id=72f988bf-86f1-41af-91ab-2d7cd011db47", "msal8cdf330b-158b-4991-8872-0f6ed4739d55://auth"))
                .exceptionally(ex -> {
                    System.out.println("Unable to authenticate - " + ex.getMessage());
                    return null;
                });

        System.out.println(result.accessToken());

    }
}