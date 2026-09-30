# Respuestas — Participación Semana 6

Completa los datos entre corchetes después de crear tu proyecto; no compartas aquí ni subas claves privadas.

**1.** Los datos están en la base PostgreSQL alojada en Supabase, no en el almacenamiento local del teléfono. Al iniciar sesión desde otro teléfono, la aplicación consulta la misma base y puede mostrar los perfiles permitidos por RLS. La sesión de autenticación se inicia en ese dispositivo.

**2.** Aunque ambas claves sean texto, tienen permisos distintos. La clave publicable identifica al cliente y queda limitada por las políticas RLS y los permisos concedidos. La clave secreta puede saltarse RLS y administrar usuarios; por eso debe permanecer en un servidor y guardarse como secreto.

**3.** A quien clone el repositorio le faltan las variables `.env` con la URL y la clave publicable del proyecto. Está bien que no estén en Git: cada desarrollador debe configurarlas localmente y así no se filtran datos de configuración. El archivo `.env` excluido de Git evita subirlo en el futuro, pero borrarlo en un commit posterior no borra el secreto de la historia previa; hay que revocar/rotar cualquier clave expuesta y revisar el historial.

**4.** Con las políticas dadas, una solicitud autenticada con la clave publicable no puede borrar perfiles: no existe una política `DELETE` que autorice esa operación. RLS rechaza el borrado. La clave secreta sí podría saltarse RLS, por eso no se incluye en Flutter.

**5.** Separar sesión y perfiles mantiene cada estado enfocado: autenticación y lista se pueden cambiar o actualizar sin mezclar responsabilidades. Nombrar las implementaciones concretas solo en `main.dart` concentra la elección de infraestructura en el punto de composición; los providers y pantallas dependen de contratos, así que sustituir el repositorio requiere menos cambios.

**6.** La contraseña se entrega a Supabase Auth por HTTPS y Supabase la gestiona como credencial protegida; no se guarda en la tabla `perfiles` ni se devuelve en las consultas de la app. En Authentication → Users aparece la cuenta (correo e identificador, con estado de confirmación); en `perfiles` aparece el identificador relacionado y el nombre público. Separarlas reduce la exposición de credenciales y permite aplicar permisos distintos a los datos de perfil.

**7.** FastAPI puede usar una clave de servidor con privilegios administrativos para invocar `auth.admin.create_user`; Flutter solo debe llevar la clave publicable sujeta a RLS, que no concede esa operación administrativa. Poner la secreta en Flutter expondría toda la base a quien extraiga el paquete. Llamar a un endpoint del servidor mantiene la clave allí y permite validar y limitar solicitudes, aunque añade infraestructura, latencia y la obligación de proteger el endpoint contra abuso.

## Configuración pendiente de la cuenta Supabase

- Crear el proyecto `usuarios-usfq`, desactivar temporalmente la confirmación de correo y copiar la URL y la clave publicable en el `.env` local.
- Ejecutar `supabase/schema.sql` en SQL Editor.
- Copiar la URL y la clave secreta a `api_usuarios/.env`; nunca usar esa clave en Flutter ni subirla al repositorio.
- Probar registro, ingreso, listado y el endpoint con el proyecto real.
