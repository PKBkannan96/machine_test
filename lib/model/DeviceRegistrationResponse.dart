import 'dart:ffi';

import 'package:equatable/equatable.dart';

class DeviceRegistrationResponse extends Equatable {
  final String response;
  final String message;
  final int guestUserId;

  DeviceRegistrationResponse({
    required this.response,
    required this.message,
    required this.guestUserId,
  });

  factory DeviceRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return DeviceRegistrationResponse(
      response: json['response'],
      message: json['message'],
      guestUserId: json['guest_user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'message': message,
      'guest_user_id': guestUserId,
    };
  }

  @override
  List<Object> get props => [response, message, guestUserId];
}