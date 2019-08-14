# Networking

## PiHole

![PiHole](pihole.png)

An advertisement and Internet tracker blocking application which acts as a DNS sinkhole.

```bash
$ make kubernetes-apply SERVICE=networking/pihole ENV=xxx
```


## ExternalDNS

![ExternalDNS](externaldns.png)

Makes Ingresses and Services available via DNS

```bash
$ make kubernetes-apply SERVICE=networking/externaldns ENV=xxx
```
