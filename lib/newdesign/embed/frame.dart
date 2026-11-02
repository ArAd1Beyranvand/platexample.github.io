/// What the host widget hands the platform iframe.
class EmbedFrameConfig {
  EmbedFrameConfig({
    required this.url,
    required this.title,
    required this.onMessage,
  });

  final Uri url;
  final String title;

  /// Called with `message.data` for messages from this iframe's window and
  /// origin only. Set [send] on creation.
  final void Function(Object? data) onMessage;

  /// Posts to the iframe at its own origin; set by the platform view.
  void Function(Object message)? send;
}
