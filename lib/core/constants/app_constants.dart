// Constantes globais do app.

// --- GPS / Rastreamento ---
const Duration gpsInterval = Duration(seconds: 30);
const double gpsMinDistance = 100.0; // metros
const double gpsMinAccuracy = 50.0; // ignorar pontos com precisão > 50m

// --- Sync ---
const int syncMaxRetries = 5;
const Duration syncInitialBackoff = Duration(seconds: 1);
const Duration syncMaxBackoff = Duration(seconds: 60);

// --- HTTP ---
const Duration httpConnectTimeout = Duration(seconds: 30);
const Duration httpReceiveTimeout = Duration(seconds: 30);
