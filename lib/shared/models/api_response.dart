class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool hasError;

  ApiResponse({
    this.data,
    this.message,
    this.hasError = false,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic) fromJsonT,
      ) {
    return ApiResponse<T>(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] as String?,
      hasError: json['error'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
      'error': hasError,
    };
  }
}
