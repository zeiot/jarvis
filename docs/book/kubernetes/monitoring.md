# Monitoring

## Prometheus Operator

The [Prometheus Operator](https://github.com/coreos/prometheus-operator) is used to manager Prometheus instances and monitoring services

```bash
$ make kubernetes-apply SERVICE=monitoring/prometheus-operator ENV=xxx
```

## Prometheus

![Prometheus](prometheus.png)

Prometheus is used as the time series database for monitoring system

```bash
$ make kubernetes-apply SERVICE=monitoring/prometheus ENV=xxx
```

## Alertmanager

![Alertmanager](alertmanager.png)

Our alerting component comes from Prometheus stack

```bash
$ make kubernetes-apply SERVICE=monitoring/alertmanager ENV=xxx
```

## Kube Prometheus

We create monitors for Kubernetes components:

```bash
$ make kubernetes-apply SERVICE=monitoring/kube-controller-manager-monitor ENV=xxx
$ make kubernetes-apply SERVICE=monitoring/kube-dns-monitor ENV=xxx
$ make kubernetes-apply SERVICE=monitoring/kube-etcd-monitor ENV=xxx
$ make kubernetes-apply SERVICE=monitoring/kube-scheduler-monitor ENV=xxx
$ make kubernetes-apply SERVICE=monitoring/kube-state-monitor ENV=xxx
$ make kubernetes-apply SERVICE=monitoring/kubelet-monitor ENV=xxx
$ make kubernetes-apply SERVICE=monitoring/kubernetes-apiserver-monitor ENV=xxx
```

A monitor for the Prometheus Operator component :

```bash
$ make kubernetes-apply SERVICE=monitoring/prometheus-operator-monitor ENV=xxx
```

The `node-exporter` for machine metrics:

```bash
$ make kubernetes-apply SERVICE=monitoring/node-exporter ENV=xxx
```

## Grafana

![Grafana](grafana.png)

Grafana is the UI of monitoring.

```bash
$ make kubernetes-apply SERVICE=monitoring/grafana ENV=prod
```
