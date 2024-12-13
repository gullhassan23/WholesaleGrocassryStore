import 'package:googleapis_auth/auth_io.dart';

class GetServiceKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/cloud-platform"
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          //         "type": "service_account",
          // "project_id": "wholesalestore-8a534",
          // "private_key_id": "162dfc17dad7f8b5ddbae65ca4d89f854d21f5bf",
          // "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDCB36ljYLMeC21\nvGDJIvgaifEG+wUlLzaePHOfi1L/xbIRUgQxD590aKKduZdplbtQFexA8D2BKPyz\nJYsLLLohKixPQ7L57LCYXpUyszxopoiIf9/5izPKAAasdbTcQvTYKRkI2SnRlLR7\ndeA8EaNzULoRLu9lBkzQdylFy474CHhcfMP067hhaardPuxpTZL6Dr6CnVQfXaTH\ntjuaFZpWL0+J4jIEW6yYJMOh1mI7XILgIZhjS5Il/xWpMYvW4HEQ3a8M2zQ66JVH\nbSVQmTnTt1pGmJfvRmSgrL2+IRaam5amL5l6o5/aTEEY2/sgIels6lTQ4OGcci2l\nWUsBxSYFAgMBAAECggEAETqwJMxFlpl/WZlyMLohtN2V4QxOPyiLnY55p+urwZmQ\n/9e8Fo0wGBqogf/2cYJBwVFJCtUqaPs2QUQurh3ZI1PG3n0A+g9p+QXBEuD2lsZe\n7lwIi/Sv8xqAfTTwi/SIIF+54N7Dx2AAjMwBTuQ0EuvSse7shBiEnqhOKmvydJTI\nYmZDXj2m0tTStXVLrhVPPQJfi7Zk6QPvElqJBrCO3pEi2zKVH6xkNM84kQppeCdR\nTQtjmQ4FgpkFrqMpNpJDOmbsW3E0IH+EL++eysYpUYrsMb0BE315BzKGCjSs5tAv\n2o+N/cFglmAVdOh5kfyIUfJy2pNgLub9tp4KnQo8+wKBgQDf+saJC6vQFjkC2woE\n6bfVx9JyNe5GNMtQ1rOeb83bKyUmMJqaQkF2GZ0Siy3PZ+WzdWIh/Lqvcp2fvd8i\n0/b9qZNcJrPw3AqkQqOceJP3urUylNfi73M+n/hBgEdZPvIHetxiunEkqUM5C/tI\ntaR60VtbYeBS/J0RnqRaVnlwVwKBgQDdxJhOHNO7qqRZKoX4yrLHwwYZk0S5nQYm\nWulY0RY2HJa2isVpg3Ab09R1tmMihD9XPgYPbCW+tiwyyI4AU62+Psp0lE6nOBVc\nW0IURl8gMcOigeeleJjno6+R6ylsQ09ZsD62VImQ/95vOrJEM12uBSqvksGHrwX6\nMW6RYhSzAwKBgB1zErGoSDH3Cg33EO0ucc55FJGRx7+RZ348jKdzWeTMWnkYAOvx\ndDv8CCwNArv3lDsxXvLLERzKfDEpvPIOXrZhmo+OQzCTLg8E+BA1xnbXJMX+zhf3\nlfaRAApUvIzeeuJC5EFS9Fd2rfENQz//Kh4/8rwkNWOT9W8Apel+3z7HAoGAQyfz\nj0P/gkcMecv8wfhv5zpRsJD+MM8yO48wNqsqdLx3j1O6sFcTLfoZzoOqxZsSq1Km\n9yiizXvRKpe9GLA+XuwY1vDKWK0NGuivvAALcm5fdeisw1kfxJW25xM1eglwEBLl\nCsXS2swBCeHWdfywE7CQ2pYwcOw5fShW+UOgTQ0CgYAA2extH7s+KgTJ2TJ3pBwO\nHVf5A7LkCa0yRE4kSdMoKOJGvfsWd0FeYXiDqJDNqnnaGVO7WJxCIpdLNwEGaxra\nHzcS5vgRHhKuVS7QEFHAoqIV3g2vN7kluxc3dMWnMN8iB1uMhlRK2eoB+sclbOag\nVPDacIj8XTXu9A+1xaK1XQ==\n-----END PRIVATE KEY-----\n",
          // "client_email": "firebase-adminsdk-i6axa@wholesalestore-8a534.iam.gserviceaccount.com",
          // "client_id": "113322630003587111845",
          // "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          // "token_uri": "https://oauth2.googleapis.com/token",
          // "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          // "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-i6axa%40wholesalestore-8a534.iam.gserviceaccount.com",
          // "universe_domain": "googleapis.com"
        }),
        scopes);

    final accessServerKey = client.credentials.accessToken.data;
    client.close();
    print("server key ${accessServerKey}");
    return accessServerKey;
  }
}
