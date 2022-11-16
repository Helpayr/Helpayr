import 'package:meta/meta.dart';

@immutable
class StoryData {
  const StoryData({
    this.name,
    this.url,
  });

  final String name;
  final String url;
}
