import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Aura'**
  String get appTitle;

  /// No description provided for @tabLibrary.
  ///
  /// In es, this message translates to:
  /// **'Biblioteca'**
  String get tabLibrary;

  /// No description provided for @tabSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get tabSearch;

  /// No description provided for @tabSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get tabSettings;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Entra en tu música'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu biblioteca, tus portadas y tus letras. En cualquier lugar.'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get email;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get signIn;

  /// No description provided for @signingIn.
  ///
  /// In es, this message translates to:
  /// **'Entrando…'**
  String get signingIn;

  /// No description provided for @invalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos.'**
  String get invalidCredentials;

  /// No description provided for @connectionError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo conectar. Revisa tu red e inténtalo de nuevo.'**
  String get connectionError;

  /// No description provided for @libraryTitle.
  ///
  /// In es, this message translates to:
  /// **'Biblioteca'**
  String get libraryTitle;

  /// No description provided for @songs.
  ///
  /// In es, this message translates to:
  /// **'Canciones'**
  String get songs;

  /// No description provided for @albums.
  ///
  /// In es, this message translates to:
  /// **'Álbumes'**
  String get albums;

  /// No description provided for @artists.
  ///
  /// In es, this message translates to:
  /// **'Artistas'**
  String get artists;

  /// No description provided for @searchHint.
  ///
  /// In es, this message translates to:
  /// **'Busca canciones, álbumes o artistas'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In es, this message translates to:
  /// **'Busca en tu biblioteca'**
  String get searchEmpty;

  /// No description provided for @searchNoResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados para «{query}»'**
  String searchNoResults(String query);

  /// No description provided for @favorites.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get favorites;

  /// No description provided for @recentlyAdded.
  ///
  /// In es, this message translates to:
  /// **'Añadidas recientemente'**
  String get recentlyAdded;

  /// No description provided for @play.
  ///
  /// In es, this message translates to:
  /// **'Reproducir'**
  String get play;

  /// No description provided for @shuffle.
  ///
  /// In es, this message translates to:
  /// **'Aleatorio'**
  String get shuffle;

  /// No description provided for @pause.
  ///
  /// In es, this message translates to:
  /// **'Pausar'**
  String get pause;

  /// No description provided for @next.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In es, this message translates to:
  /// **'Anterior'**
  String get previous;

  /// No description provided for @queue.
  ///
  /// In es, this message translates to:
  /// **'Cola'**
  String get queue;

  /// No description provided for @nowPlaying.
  ///
  /// In es, this message translates to:
  /// **'Reproduciendo'**
  String get nowPlaying;

  /// No description provided for @lyrics.
  ///
  /// In es, this message translates to:
  /// **'Letra'**
  String get lyrics;

  /// No description provided for @noLyrics.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay letra para esta canción.'**
  String get noLyrics;

  /// No description provided for @lyricsOffset.
  ///
  /// In es, this message translates to:
  /// **'Ajuste de letra'**
  String get lyricsOffset;

  /// No description provided for @syncLyrics.
  ///
  /// In es, this message translates to:
  /// **'Sincronizar'**
  String get syncLyrics;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @account.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get account;

  /// No description provided for @theme.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @audio.
  ///
  /// In es, this message translates to:
  /// **'Reproducción'**
  String get audio;

  /// No description provided for @normalizeVolume.
  ///
  /// In es, this message translates to:
  /// **'Normalizar volumen'**
  String get normalizeVolume;

  /// No description provided for @downloadsOnlyWifi.
  ///
  /// In es, this message translates to:
  /// **'Descargar solo con Wi-Fi'**
  String get downloadsOnlyWifi;

  /// No description provided for @storage.
  ///
  /// In es, this message translates to:
  /// **'Almacenamiento'**
  String get storage;

  /// No description provided for @clearCache.
  ///
  /// In es, this message translates to:
  /// **'Borrar caché'**
  String get clearCache;

  /// No description provided for @signOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get signOut;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión'**
  String get version;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In es, this message translates to:
  /// **'Hecho'**
  String get done;

  /// No description provided for @addToQueue.
  ///
  /// In es, this message translates to:
  /// **'Añadir a la cola'**
  String get addToQueue;

  /// No description provided for @addToFavorites.
  ///
  /// In es, this message translates to:
  /// **'Añadir a favoritos'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In es, this message translates to:
  /// **'Quitar de favoritos'**
  String get removeFromFavorites;

  /// No description provided for @emptyLibrary.
  ///
  /// In es, this message translates to:
  /// **'Tu biblioteca está vacía'**
  String get emptyLibrary;

  /// No description provided for @emptyLibraryHint.
  ///
  /// In es, this message translates to:
  /// **'Añade música desde el panel de ingesta.'**
  String get emptyLibraryHint;

  /// No description provided for @offline.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión'**
  String get offline;

  /// No description provided for @refresh.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get refresh;

  /// No description provided for @tracksCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 canción} other{{count} canciones}}'**
  String tracksCount(int count);

  /// No description provided for @thisWeek.
  ///
  /// In es, this message translates to:
  /// **'Esta semana'**
  String get thisWeek;

  /// No description provided for @topTracks.
  ///
  /// In es, this message translates to:
  /// **'Más escuchadas'**
  String get topTracks;

  /// No description provided for @topArtists.
  ///
  /// In es, this message translates to:
  /// **'Artistas favoritos'**
  String get topArtists;

  /// No description provided for @streak.
  ///
  /// In es, this message translates to:
  /// **'{days} días seguidos'**
  String streak(int days);

  /// No description provided for @gallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get gallery;

  /// No description provided for @designSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema de diseño'**
  String get designSystem;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando…'**
  String get loading;

  /// No description provided for @unknownArtist.
  ///
  /// In es, this message translates to:
  /// **'Artista desconocido'**
  String get unknownArtist;

  /// No description provided for @unknownAlbum.
  ///
  /// In es, this message translates to:
  /// **'Álbum desconocido'**
  String get unknownAlbum;

  /// No description provided for @trackNumber.
  ///
  /// In es, this message translates to:
  /// **'Pista {number}'**
  String trackNumber(int number);

  /// No description provided for @queueEmpty.
  ///
  /// In es, this message translates to:
  /// **'La cola está vacía'**
  String get queueEmpty;

  /// No description provided for @searching.
  ///
  /// In es, this message translates to:
  /// **'Buscando…'**
  String get searching;

  /// No description provided for @syncDone.
  ///
  /// In es, this message translates to:
  /// **'Biblioteca actualizada'**
  String get syncDone;

  /// No description provided for @download.
  ///
  /// In es, this message translates to:
  /// **'Descargar'**
  String get download;

  /// No description provided for @downloaded.
  ///
  /// In es, this message translates to:
  /// **'Descargada'**
  String get downloaded;

  /// No description provided for @removeDownload.
  ///
  /// In es, this message translates to:
  /// **'Quitar descarga'**
  String get removeDownload;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @sleepTimer.
  ///
  /// In es, this message translates to:
  /// **'Temporizador'**
  String get sleepTimer;

  /// No description provided for @speed.
  ///
  /// In es, this message translates to:
  /// **'Velocidad'**
  String get speed;

  /// No description provided for @replayGain.
  ///
  /// In es, this message translates to:
  /// **'Volumen'**
  String get replayGain;

  /// No description provided for @statsTitle.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get statsTitle;

  /// No description provided for @plays.
  ///
  /// In es, this message translates to:
  /// **'Reproducciones'**
  String get plays;

  /// No description provided for @minutes.
  ///
  /// In es, this message translates to:
  /// **'Minutos escuchados'**
  String get minutes;

  /// No description provided for @uniqueTracks.
  ///
  /// In es, this message translates to:
  /// **'Canciones distintas'**
  String get uniqueTracks;

  /// No description provided for @streakLabel.
  ///
  /// In es, this message translates to:
  /// **'Racha'**
  String get streakLabel;

  /// No description provided for @range7d.
  ///
  /// In es, this message translates to:
  /// **'7 días'**
  String get range7d;

  /// No description provided for @range30d.
  ///
  /// In es, this message translates to:
  /// **'30 días'**
  String get range30d;

  /// No description provided for @range90d.
  ///
  /// In es, this message translates to:
  /// **'90 días'**
  String get range90d;

  /// No description provided for @rangeAll.
  ///
  /// In es, this message translates to:
  /// **'Todo'**
  String get rangeAll;

  /// No description provided for @statsEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay reproducciones en este periodo.'**
  String get statsEmpty;

  /// No description provided for @statsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tus hábitos de escucha'**
  String get statsSubtitle;

  /// No description provided for @downloading.
  ///
  /// In es, this message translates to:
  /// **'Descargando…'**
  String get downloading;

  /// No description provided for @downloadFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo descargar.'**
  String get downloadFailed;

  /// No description provided for @downloads.
  ///
  /// In es, this message translates to:
  /// **'Descargas'**
  String get downloads;

  /// No description provided for @downloadFavorites.
  ///
  /// In es, this message translates to:
  /// **'Descargar favoritos'**
  String get downloadFavorites;

  /// No description provided for @downloadedCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Ninguna descargada} =1{1 descargada} other{{count} descargadas}}'**
  String downloadedCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
