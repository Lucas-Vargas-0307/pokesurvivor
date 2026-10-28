/* ============ firebase-config.js — conexión con tu proyecto de Firebase ============
 * Pega aquí la configuración de tu app web de Firebase (Consola de Firebase >
 * Configuración del proyecto > Tus apps > SDK setup and configuration > Config).
 * Los pasos completos están en docs/CONFIGURAR_NUBE.md.
 *
 * Estos datos NO son secretos: Firebase los diseña para ir en la web. Lo que
 * protege las partidas son las reglas de Firestore (firestore.rules).
 *
 * Si se pone a null, el juego funciona en modo local (sólo en el navegador).
 */
G.FIREBASE_CONFIG = {
  apiKey: 'AIzaSyCrj4OoNoeGHPoNkekPrSQjfc_VjZxZTJQ',
  authDomain: 'pokesurvivor-amigos-aa509.firebaseapp.com',
  projectId: 'pokesurvivor-amigos-aa509',
  storageBucket: 'pokesurvivor-amigos-aa509.firebasestorage.app',
  messagingSenderId: '508754978852',
  appId: '1:508754978852:web:e793d05a98fab1a15350b1',
  databaseURL: 'https://pokesurvivor-amigos-aa509-default-rtdb.europe-west1.firebasedatabase.app'
};
