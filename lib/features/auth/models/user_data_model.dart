class UserDataModel {
  final String id;
  final String userName;
  final String email;
  final String createdAt;

  UserDataModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.createdAt,
  });

  UserDataModel copyWith({
    String? id,
    String? userName,
    String? email,
    String? createdAt,
  }) {
    return UserDataModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
      'createdAt': createdAt,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      id: map['id'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}
