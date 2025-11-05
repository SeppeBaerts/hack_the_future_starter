class ChatMessageModel {
  const ChatMessageModel({
    this.text,
    this.surfaceId,
    this.isUser = false,
    this.isError = false,
  }) : assert((text == null) != (surfaceId == null));

  final String? text;
  final String? surfaceId;
  final bool isUser;
  final bool isError;
}


