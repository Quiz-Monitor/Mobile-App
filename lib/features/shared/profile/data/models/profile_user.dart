class ProfileUser {
  final String fullName;
  final String email;
  final String roleLabel;
  final String userId;
  final String phoneNumber;
  final String? avatarText;

  const ProfileUser({
    required this.fullName,
    required this.email,
    required this.roleLabel,
    required this.userId,
    required this.phoneNumber,
    this.avatarText,
  });

  String get initials {
    if (avatarText != null && avatarText!.trim().isNotEmpty) {
      return avatarText!.trim();
    }

    final parts = fullName.trim().split(RegExp(r'\s+'));
    final buffer = StringBuffer();

    for (final part in parts) {
      if (part.isEmpty) continue;
      buffer.write(part[0].toUpperCase());
      if (buffer.length == 2) break;
    }

    return buffer.isEmpty ? 'U' : buffer.toString();
  }
}
