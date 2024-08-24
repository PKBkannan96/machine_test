class TokenResponse {
  final String response;
  final String token;

  TokenResponse({
    required this.response,
    required this.token,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      response: json['response'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'token': token,
    };
  }
}