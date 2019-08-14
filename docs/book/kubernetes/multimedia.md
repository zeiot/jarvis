# Multimedia

## Films

![Radarr](radarr.png)

Automatically downloading movies via Usenet and BitTorrent.

```bash
$ make kubernetes-apply SERVICE=multimedia/radarr ENV=xxx
```

## TV

![Sonarr](sonarr.png)

A PVR for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them

```bash
$ make kubernetes-apply SERVICE=multimedia/sonarr ENV=xxx
```