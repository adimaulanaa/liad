import 'package:googleapis_auth/auth_io.dart';

class GetServicesKey {
  Future<String> getServicesKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "liad-apps",
          "private_key_id": "de778ef9a2a29f624ca3988167efd576179eed3c",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEugIBADANBgkqhkiG9w0BAQEFAASCBKQwggSgAgEAAoIBAQCcQhZMDtRsJoa0\nGtXNQlOkWwz3GqUcgMcb2qQ/Ch8W+tIbRjeikBE8pC21sVPrJUyrbqpbS7Jh8pk7\ngyxIsz6of6U4aYxmzszpNxuxqVPrFuH9PNXDxNSJeYMFv90XpVu857rBrqrC8p43\nRbwX5gParLMxF8URgcF8zduwtIEAtSJ7yqQbFgv+ZLEgNNom4r5m9V6/KS79zoAp\nwdLpBbUnIzkG5wJKEEz/v6RtNnRC1V3GApMSm1EXldKr7innHbjtB9hK9C6QyHzo\n0YdJ0iDosbRDjYssQYw4pgLA2Unf1/DjhuJscAIbuR8TkFi2UMXMrCbkPClmEJc+\nluxAINKTAgMBAAECgf8fo0HgecreGu7V3e5sINcj7/YwEgpcOwwVbQTUaWLiGZFw\n9EakzjFZ6zlWEGbCtZ/7Fe0S5GtkaY+c/RzPm3s+9+6mqA2aw0RknpknikvzeC6e\n7N0F8P8XgVgwpyhHdrOcYU7u6EQANMopZsqEDDkQ4ua6iercyz43MXcfJWz5N2J/\n8CoTP/RQjpP5lL/SVBr1Ls3BjweovzIoJ0AarS0hnV2jX9cKB9QxVR0FG6B2Py1T\nurF+uD2oTwK7noExG7MOuqCxAug0Xt9pUWDKm6KepdOSaT4zq5qI6YxWEraMx6/8\nQAF5mt05ahg1qhdMEBxDYtOdaVCUbEQApl9H7Q0CgYEA0pTqI58U/iHjAUm2FxFo\nDHtPg3VK78z4rMOCuCrKgTxz+PMAtppNu624EBDWoCweGXpwQhwknEhEqDhYB/Nl\n3hWy7S69Q5rqgiOruEE3RT4zn1D9fxa0wKtDUoLH73WZoVJySqB2F5N3/biKBuJg\n90cOzo0H5R0RGFL3Tw4oIccCgYEAvfW+w+q68LuGVSJDNfuTwCV94Id18L0M3pNw\n85syaLmBKxK2qSErwm4LAb7h/BQMMCzBIpTwMOOmxCz6NP6vVlGC7FOAg9K/JC5k\nlbI+NEPY5PFjsCgWZh1bsXwHO1nQe4eC8Gimv7+tCN8YlymbepiQjddDbk87hrJr\njRLdiNUCgYA5/ch9BtJBKhPZxvLeZ2zAAzVifmqkn03cRfs5vI8ICB3n8QPBRb0i\ncjS+N+TjN0MSwSUpD5cFcuF1cg7MIbtr7Y3Yw4Zbl839CNXBaDRQXVDaDvPAjAA7\nDu77SgjFaR1lz86pvobG91WUCb35J16MuoTZXP1PmzGaAT8aBkwHAQKBgG6R01dw\nkx262adGST7r0AXBDPMbhh/5urr3sYBqrr3cdH4g52es4i7LJOcAN8Ql2y5Tbpv1\ne5XJfPGliII+WMryqTVsKVsR2aZyxqOH28NKVr50b2VDAD6yCgRWQFNgpQSyTRoo\noB7usAaA7WxXkKOcmE+npB1aSzjNM+Mqvv59AoGAcOljYbSyDDaW3njGWK3NPND3\nkOFT4pSVJKoXjzk5/F6i5W9y2QEgniqSdMVra4YqK9qTVDNBf2xSDc/Zc1k+bBiv\ncFEVmmBsEsrsQa0Ztw+b0VJ8Nj+oTXXyTfpLN9a7lGRWcyC0xhrN8KRFQWJjWXJb\nUUMT3XjPBswqO8Jaznw=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-jxr1g@liad-apps.iam.gserviceaccount.com",
          "client_id": "105969392734442003130",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-jxr1g%40liad-apps.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        },
      ),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
