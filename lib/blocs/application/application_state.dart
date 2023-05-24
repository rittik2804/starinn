import 'package:video_player/video_player.dart';

enum ApplicationStatus { loading, completed, intro }

abstract class ApplicationState {}

class ApploddingState extends ApplicationState {}

class AppSuccessStat extends ApplicationState {
  VideoPlayerController videoPlayerController;
  AppSuccessStat({required this.videoPlayerController});
}
