<!--
Este archivo README esta generado automaticamente<https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
No se debe editar a mano.
-->

# Veloren server para Yunohost

[![Nivel de integración](https://dash.yunohost.org/integration/veloren.svg)](https://dash.yunohost.org/appci/app/veloren) ![Estado funcional](https://ci-apps.yunohost.org/ci/badges/veloren.status.svg) ![Estado En Mantención](https://ci-apps.yunohost.org/ci/badges/veloren.maintain.svg)

[![Instalar Veloren server con Yunhost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=veloren)

*[Leer este README en otros idiomas.](./ALL_README.md)*

> *Este paquete le permite instalarVeloren server rapidamente y simplement en un servidor YunoHost.*  
> *Si no tiene YunoHost, visita [the guide](https://yunohost.org/install) para aprender como instalarla.*

## Descripción general



**Versión actual:** 0.10.0~ynh1

**Demo:** <server.veloren.net:14004>

## Capturas

![Captura de Veloren server](./doc/screenshots/veloren.png)

## informaciones importantes

Veloren is in pre-alpha, il y aura des bugs.

This package provides the last "release" version of Veloren, which is older than that of the official server. You will need to download the corresponding version of the client:
 * [Windows x64](https://gitlab.com/veloren/veloren/-/jobs/artifacts/v0.10.0/download?job=windows)
 * [Linux x64](https://gitlab.com/veloren/veloren/-/jobs/artifacts/v0.10.0/download?job=linux)
 * [MacOS x64](https://gitlab.com/veloren/veloren/-/jobs/artifacts/v0.10.0/download?job=macos)

## Documentaciones y recursos

- Sitio web oficial: <https://veloren.net/>
- Documentación usuario oficial: <https://book.veloren.net/players/>
- Documentación administrador oficial: <https://book.veloren.net/players/hosting-a-server.html>
- Repositorio del código fuente oficial de la aplicación : <https://gitlab.com/veloren/veloren>
- Catálogo YunoHost: <https://apps.yunohost.org/app/veloren>
- Reportar un error: <https://github.com/YunoHost-Apps/veloren_ynh/issues>

## Información para desarrolladores

Por favor enviar sus correcciones a la [`branch testing`](https://github.com/YunoHost-Apps/veloren_ynh/tree/testing

Para probar la rama `testing`, sigue asÍ:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/veloren_ynh/tree/testing --debug
o
sudo yunohost app upgrade veloren -u https://github.com/YunoHost-Apps/veloren_ynh/tree/testing --debug
```

**Mas informaciones sobre el empaquetado de aplicaciones:** <https://yunohost.org/packaging_apps>
