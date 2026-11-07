// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aura';

  @override
  String get tabLibrary => 'Library';

  @override
  String get tabSearch => 'Search';

  @override
  String get tabSettings => 'Settings';

  @override
  String get loginTitle => 'Sign in to your music';

  @override
  String get loginSubtitle => 'Your library, covers and lyrics. Everywhere.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get invalidCredentials => 'Wrong email or password.';

  @override
  String get connectionError =>
      'Could not connect. Check your network and try again.';

  @override
  String get libraryTitle => 'Library';

  @override
  String get songs => 'Songs';

  @override
  String get albums => 'Albums';

  @override
  String get artists => 'Artists';

  @override
  String get searchHint => 'Search songs, albums or artists';

  @override
  String get searchEmpty => 'Search your library';

  @override
  String searchNoResults(String query) {
    return 'No results for “$query”';
  }

  @override
  String get favorites => 'Favorites';

  @override
  String get recentlyAdded => 'Recently added';

  @override
  String get play => 'Play';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get pause => 'Pause';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get queue => 'Queue';

  @override
  String get nowPlaying => 'Now playing';

  @override
  String get lyrics => 'Lyrics';

  @override
  String get noLyrics => 'No lyrics for this song yet.';

  @override
  String get lyricsOffset => 'Lyrics offset';

  @override
  String get syncLyrics => 'Sync';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get audio => 'Playback';

  @override
  String get normalizeVolume => 'Normalize volume';

  @override
  String get downloadsOnlyWifi => 'Download on Wi-Fi only';

  @override
  String get storage => 'Storage';

  @override
  String get clearCache => 'Clear cache';

  @override
  String get signOut => 'Sign out';

  @override
  String get version => 'Version';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get addToQueue => 'Add to queue';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get emptyLibrary => 'Your library is empty';

  @override
  String get emptyLibraryHint => 'Add music from the ingest panel.';

  @override
  String get offline => 'Offline';

  @override
  String get refresh => 'Refresh';

  @override
  String tracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
    );
    return '$_temp0';
  }

  @override
  String get thisWeek => 'This week';

  @override
  String get topTracks => 'Most played';

  @override
  String get topArtists => 'Favorite artists';

  @override
  String streak(int days) {
    return '$days days in a row';
  }

  @override
  String get gallery => 'Gallery';

  @override
  String get designSystem => 'Design system';

  @override
  String get loading => 'Loading…';

  @override
  String get unknownArtist => 'Unknown artist';

  @override
  String get unknownAlbum => 'Unknown album';

  @override
  String trackNumber(int number) {
    return 'Track $number';
  }

  @override
  String get queueEmpty => 'The queue is empty';

  @override
  String get searching => 'Searching…';

  @override
  String get syncDone => 'Library updated';

  @override
  String get download => 'Download';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get removeDownload => 'Remove download';

  @override
  String get close => 'Close';

  @override
  String get sleepTimer => 'Sleep timer';

  @override
  String get speed => 'Speed';

  @override
  String get replayGain => 'Volume';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get plays => 'Plays';

  @override
  String get minutes => 'Minutes listened';

  @override
  String get uniqueTracks => 'Unique tracks';

  @override
  String get streakLabel => 'Streak';

  @override
  String get range7d => '7 days';

  @override
  String get range30d => '30 days';

  @override
  String get range90d => '90 days';

  @override
  String get rangeAll => 'All';

  @override
  String get statsEmpty => 'No plays in this period yet.';

  @override
  String get statsSubtitle => 'Your listening habits';

  @override
  String get downloading => 'Downloading…';

  @override
  String get downloadFailed => 'Download failed.';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloadFavorites => 'Download favorites';

  @override
  String downloadedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloaded',
      one: '1 downloaded',
      zero: 'None downloaded',
    );
    return '$_temp0';
  }
}
