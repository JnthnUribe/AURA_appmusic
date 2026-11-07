// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Aura';

  @override
  String get tabLibrary => 'Biblioteca';

  @override
  String get tabSearch => 'Buscar';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get loginTitle => 'Entra en tu música';

  @override
  String get loginSubtitle =>
      'Tu biblioteca, tus portadas y tus letras. En cualquier lugar.';

  @override
  String get email => 'Correo';

  @override
  String get password => 'Contraseña';

  @override
  String get signIn => 'Entrar';

  @override
  String get signingIn => 'Entrando…';

  @override
  String get invalidCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get connectionError =>
      'No se pudo conectar. Revisa tu red e inténtalo de nuevo.';

  @override
  String get libraryTitle => 'Biblioteca';

  @override
  String get songs => 'Canciones';

  @override
  String get albums => 'Álbumes';

  @override
  String get artists => 'Artistas';

  @override
  String get searchHint => 'Busca canciones, álbumes o artistas';

  @override
  String get searchEmpty => 'Busca en tu biblioteca';

  @override
  String searchNoResults(String query) {
    return 'Sin resultados para «$query»';
  }

  @override
  String get favorites => 'Favoritos';

  @override
  String get recentlyAdded => 'Añadidas recientemente';

  @override
  String get play => 'Reproducir';

  @override
  String get shuffle => 'Aleatorio';

  @override
  String get pause => 'Pausar';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get queue => 'Cola';

  @override
  String get nowPlaying => 'Reproduciendo';

  @override
  String get lyrics => 'Letra';

  @override
  String get noLyrics => 'Todavía no hay letra para esta canción.';

  @override
  String get lyricsOffset => 'Ajuste de letra';

  @override
  String get syncLyrics => 'Sincronizar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get account => 'Cuenta';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get audio => 'Reproducción';

  @override
  String get normalizeVolume => 'Normalizar volumen';

  @override
  String get downloadsOnlyWifi => 'Descargar solo con Wi-Fi';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get clearCache => 'Borrar caché';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get version => 'Versión';

  @override
  String get retry => 'Reintentar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get done => 'Hecho';

  @override
  String get addToQueue => 'Añadir a la cola';

  @override
  String get addToFavorites => 'Añadir a favoritos';

  @override
  String get removeFromFavorites => 'Quitar de favoritos';

  @override
  String get emptyLibrary => 'Tu biblioteca está vacía';

  @override
  String get emptyLibraryHint => 'Añade música desde el panel de ingesta.';

  @override
  String get offline => 'Sin conexión';

  @override
  String get refresh => 'Actualizar';

  @override
  String tracksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canciones',
      one: '1 canción',
    );
    return '$_temp0';
  }

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get topTracks => 'Más escuchadas';

  @override
  String get topArtists => 'Artistas favoritos';

  @override
  String streak(int days) {
    return '$days días seguidos';
  }

  @override
  String get gallery => 'Galería';

  @override
  String get designSystem => 'Sistema de diseño';

  @override
  String get loading => 'Cargando…';

  @override
  String get unknownArtist => 'Artista desconocido';

  @override
  String get unknownAlbum => 'Álbum desconocido';

  @override
  String trackNumber(int number) {
    return 'Pista $number';
  }

  @override
  String get queueEmpty => 'La cola está vacía';

  @override
  String get searching => 'Buscando…';

  @override
  String get syncDone => 'Biblioteca actualizada';

  @override
  String get download => 'Descargar';

  @override
  String get downloaded => 'Descargada';

  @override
  String get removeDownload => 'Quitar descarga';

  @override
  String get close => 'Cerrar';

  @override
  String get sleepTimer => 'Temporizador';

  @override
  String get speed => 'Velocidad';

  @override
  String get replayGain => 'Volumen';

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String get plays => 'Reproducciones';

  @override
  String get minutes => 'Minutos escuchados';

  @override
  String get uniqueTracks => 'Canciones distintas';

  @override
  String get streakLabel => 'Racha';

  @override
  String get range7d => '7 días';

  @override
  String get range30d => '30 días';

  @override
  String get range90d => '90 días';

  @override
  String get rangeAll => 'Todo';

  @override
  String get statsEmpty => 'Aún no hay reproducciones en este periodo.';

  @override
  String get statsSubtitle => 'Tus hábitos de escucha';

  @override
  String get downloading => 'Descargando…';

  @override
  String get downloadFailed => 'No se pudo descargar.';

  @override
  String get downloads => 'Descargas';

  @override
  String get downloadFavorites => 'Descargar favoritos';

  @override
  String downloadedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count descargadas',
      one: '1 descargada',
      zero: 'Ninguna descargada',
    );
    return '$_temp0';
  }
}
