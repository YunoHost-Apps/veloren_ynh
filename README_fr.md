<!--
Nota bene : ce README est automatiquement généré par <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Il NE doit PAS être modifié à la main.
-->

# Veloren server pour YunoHost

[![Niveau d’intégration](https://dash.yunohost.org/integration/veloren.svg)](https://dash.yunohost.org/appci/app/veloren) ![Statut du fonctionnement](https://ci-apps.yunohost.org/ci/badges/veloren.status.svg) ![Statut de maintenance](https://ci-apps.yunohost.org/ci/badges/veloren.maintain.svg)

[![Installer Veloren server avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=veloren)

*[Lire le README dans d'autres langues.](./ALL_README.md)*

> *Ce package vous permet d’installer Veloren server rapidement et simplement sur un serveur YunoHost.*  
> *Si vous n’avez pas YunoHost, consultez [ce guide](https://yunohost.org/install) pour savoir comment l’installer et en profiter.*

## Vue d’ensemble

RPG voxel multijoueur inspiré de jeux tels que Cube World, Legend of Zelda : Breath of the Wild, Dwarf Fortress et Minecraft

**Version incluse :** 0.10.0~ynh1

**Démo :** <server.veloren.net:14004>

## Captures d’écran

![Capture d’écran de Veloren server](./doc/screenshots/veloren.png)

## Avertissements / informations importantes

Veloren est en pre-alpha, il y aura des bugs.

Ce paquet fournit la dernière version "release" de Veloren, qui est plus ancienne que celle du serveur officiel. Il vous faudra télécharger la version correspondante du client:
 * [Windows x64](https://gitlab.com/veloren/veloren/-/jobs/artifacts/v0.10.0/download?job=windows)
 * [Linux x64](https://gitlab.com/veloren/veloren/-/jobs/artifacts/v0.10.0/download?job=linux)
 * [MacOS x64](https://gitlab.com/veloren/veloren/-/jobs/artifacts/v0.10.0/download?job=macos)

## Documentations et ressources

- Site officiel de l’app : <https://veloren.net/>
- Documentation officielle utilisateur : <https://book.veloren.net/players/>
- Documentation officielle de l’admin : <https://book.veloren.net/players/hosting-a-server.html>
- Dépôt de code officiel de l’app : <https://gitlab.com/veloren/veloren>
- YunoHost Store : <https://apps.yunohost.org/app/veloren>
- Signaler un bug : <https://github.com/YunoHost-Apps/veloren_ynh/issues>

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche `testing`](https://github.com/YunoHost-Apps/veloren_ynh/tree/testing).

Pour essayer la branche `testing`, procédez comme suit :

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/veloren_ynh/tree/testing --debug
ou
sudo yunohost app upgrade veloren -u https://github.com/YunoHost-Apps/veloren_ynh/tree/testing --debug
```

**Plus d’infos sur le packaging d’applications :** <https://yunohost.org/packaging_apps>
