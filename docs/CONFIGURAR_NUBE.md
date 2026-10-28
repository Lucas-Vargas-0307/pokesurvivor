# Cómo configurar tu propia nube (Firebase gratis) en PokéSurvivor

Esta guía explica paso a paso cómo conectar tu copia de PokéSurvivor a tu propio proyecto de **Google Firebase 100 % gratuito** (Plan Spark: 0 € / $0 al mes para siempre, **sin necesidad de tarjeta de crédito**).

---

## ¿Por qué hace falta este paso?

El repositorio original de PokéSurvivor viene configurado con el proyecto Firebase del creador (`pokesurvivor-free`). Por motivos de seguridad y cuotas, Google Cloud restringe la clave de ese proyecto únicamente a los dominios oficiales (`pokesurvivor.com` y `jpter78.github.io`).

Al ejecutar el juego en tu propio GitHub Pages (`lucas-vargas-0307.github.io` o cualquier otro dominio):
1. Google Cloud bloquea las peticiones con error `403 Forbidden (API_KEY_HTTP_REFERRER_BLOCKED)`.
2. Como resultado, el juego no puede conectar con la nube y muestra el aviso:  
   *"Esto necesita la versión online del juego (con la nube)."* al intentar abrir Amigos, Salas o Multijugador.

Creando tu propio proyecto de Firebase tendrás tu propia base de datos independiente con:
- Cuentas de usuario e inicio de sesión.
- Guardado en la nube automático y sincronización entre dispositivos.
- Lista de amigos y presencia en directo.
- Salas multijugador cooperativo (hasta 8 jugadores).
- Ranking local de tus jugadores.

---

## Paso 1 · Crear el proyecto en Firebase (1 minuto)

1. Entra en la [Consola de Firebase](https://console.firebase.google.com/) con tu cuenta de Google.
2. Pulsa en **"Crear un proyecto"** (o *"Añadir proyecto"*).
3. Escribe un nombre para el proyecto (por ejemplo, `pokesurvivor-lucas`).
4. Pulsa **Continuar**.
5. En el paso de Google Analytics, puedes **desactivarlo** (no es necesario para el juego) y pulsar **Crear proyecto**.
6. Espera unos segundos a que se cree y pulsa **Continuar**.

---

## Paso 2 · Registrar la aplicación Web (1 minuto)

1. En la pantalla principal de tu nuevo proyecto, haz clic en el icono de aplicación Web **`</>`** (o ve a ⚙️ *Configuración del proyecto* → pestaña *General* → sección *Tus apps* → *Añadir app* → icono `</>`).
2. Ponle un nombre, por ejemplo: `PokéSurvivor Web`.
3. **No** marques la casilla *"Configurar también Firebase Hosting"*.
4. Pulsa **Registrar app**.
5. Te mostrará un bloque de código con un objeto `firebaseConfig` parecido a este:
   ```javascript
   const firebaseConfig = {
     apiKey: "AIzaSy...",
     authDomain: "tu-proyecto.firebaseapp.com",
     projectId: "tu-proyecto",
     storageBucket: "tu-proyecto.firebasestorage.app",
     messagingSenderId: "123456789012",
     appId: "1:123456789012:web:abcdef123456"
   };
   ```
6. Deja esta pestaña abierta o copia los datos; los pegaremos en el paso 6.

---

## Paso 3 · Activar Authentication (Cuentas de jugador)

1. En el menú lateral de la izquierda, entra en **Compilación** (Build) → **Authentication**.
2. Pulsa el botón **Comenzar** (Get started).
3. En la pestaña **Método de inicio de sesión** (Sign-in method):
   - Haz clic en **Correo electrónico y contraseña** (Email/Password).
   - Activa el primer interruptor: **Habilitar** (Correo electrónico y contraseña).
   - Mantén **desactivado** el segundo interruptor (*Vínculo del correo electrónico / sin contraseña*).
   - Pulsa **Guardar**.
   - *(Opcional)*: Si quieres que los jugadores puedan entrar con Google, puedes habilitar también **Google** (te pedirá seleccionar un correo de asistencia).
   - *(Opcional)*: Puedes activar **Anónimo** para permitir jugar como invitado.
4. **¡ATENCIÓN! Evitar costes innecesarios**:
   - En la pestaña **Configuración** de Authentication, **NUNCA pulses "Actualizar a Identity Platform"**.
   - La autenticación estándar de Firebase es **100 % gratuita e ilimitada** en el plan Spark.
5. Ve a la pestaña **Configuración** (Settings) → **Dominios autorizados** (Authorized domains):
   - Pulsa **Añadir dominio**.
   - Escribe tu dominio de GitHub Pages: `lucas-vargas-0307.github.io`
   - Pulsa **Añadir**.
   - *(Nota: `localhost` ya viene añadido por defecto para pruebas locales).*

---

## Paso 4 · Activar Cloud Firestore (Partidas y perfiles)

1. En el menú lateral: **Compilación** → **Firestore Database**.
2. Pulsa **Crear base de datos**.
3. Elige la **Ubicación** geográfica más cercana (por ejemplo `eur3` / `europe-west` si estás en Europa, o `nam5` / `us-central` si estás en América).
4. Elige **Iniciar en modo de producción** y pulsa **Crear**.
5. Ve a la pestaña **Reglas** (Rules).
6. Borra el contenido que haya y pega las reglas de seguridad oficiales del juego (están en el archivo `firestore.rules` en la raíz del proyecto):
   - O copia directamente el contenido del archivo `firestore.rules`.
7. Pulsa **Publicar** (Publish).

---

## Paso 5 · Activar Realtime Database (Cooperativo y salas)

1. En el menú lateral: **Compilación** → **Realtime Database**.
2. Pulsa **Crear base de datos**.
3. Selecciona la ubicación (por ejemplo Bélgica `europe-west1` o Estados Unidos `us-central1`).
4. Pulsa **Siguiente**, elige **Iniciar en modo bloqueado** y pulsa **Habilitar**.
5. En la pestaña **Datos** (Data), fíjate en la URL que aparece arriba del todo. Tiene un formato similar a:  
   `https://tu-proyecto-default-rtdb.europe-west1.firebasedatabase.app/`  
   Esta es tu `databaseURL`.
6. Ve a la pestaña **Reglas** (Rules) de la Realtime Database.
7. Borra lo que haya y pega las reglas que están en el archivo `database.rules.json` en la raíz del proyecto.
8. Pulsa **Publicar** (Publish).

---

## Paso 6 · Pegar tu configuración en el juego

Abre el archivo `js/core/firebase-config.js` y sustituye el contenido del objeto `G.FIREBASE_CONFIG` por el de tu nuevo proyecto:

```javascript
G.FIREBASE_CONFIG = {
  apiKey: 'AIzaSy...',
  authDomain: 'tu-proyecto.firebaseapp.com',
  projectId: 'tu-proyecto',
  storageBucket: 'tu-proyecto.firebasestorage.app',
  messagingSenderId: '123456789012',
  appId: '1:123456789012:web:abcdef123456',
  databaseURL: 'https://tu-proyecto-default-rtdb.europe-west1.firebasedatabase.app'
};
```

> **Importante**: Asegúrate de incluir la línea `databaseURL` con la URL de tu Realtime Database (obtenida en el Paso 5). Es imprescindible para las salas cooperativas.

---

## Paso 7 · Compilar y publicar los cambios

Una vez editado `js/core/firebase-config.js`, abre tu terminal en la carpeta del proyecto y ejecuta:

```bash
# 1. Empaqueta el juego con los cambios
node tools/build.js --expose

# 2. Sube los cambios a GitHub
git add -A
git commit -m "Conectar con proyecto propio de Firebase"
git push origin main
```

En 1-2 minutos GitHub Pages se actualizará automáticamente.  
¡Ya podrás entrar en tu web, crear tu cuenta con apodo, guardar partida en la nube y jugar al multijugador online sin problemas!

---

## Solución de problemas comunes

- **"Esto necesita la versión online del juego"**: Comprueba que tu dominio esté en la lista de dominios autorizados de Authentication (Paso 3) y que `G.FIREBASE_CONFIG` contenga `apiKey` y `projectId` válidos.
- **Error 403 en la consola del navegador**: Indica que la clave de API tiene restricciones de referrer en Google Cloud Console que no incluyen tu dominio. Si creaste un proyecto nuevo en Firebase Console siguiendo los pasos anteriores, por defecto no tiene restricción de referrer para apps web.
- **Las salas de multijugador no conectan**: Comprueba que hayas configurado la `databaseURL` en `firebase-config.js` y publicado las reglas en Realtime Database (Paso 5).
- **Aviso de dominio ya en uso en GitHub Pages (CNAME)**: Si GitHub (Settings > Pages) muestra un aviso de que `pokesurvivor.com` ya está asignado a otro repositorio, puedes borrar el archivo `CNAME` de la raíz de tu proyecto, ya que pertenece al dominio de la web original.
