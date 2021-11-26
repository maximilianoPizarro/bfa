# Nodo BFA para Openshift 4.9

Repositorio imagen base https://gitlab.bfa.ar/docker/bfanodo.

## Installation

generar el build del dockerfile con el usuario del contexto seguro del proyecto [bfa](https://gitlab.bfa.ar/docker/bfanodo).

```bash
docker build -t default-route-openshift-image-registry.apps.sandbox.x8i5.p1.openshiftapps.com/mpizarro-dev/nodo-bfa:test .
```

## Importar objectos K8S

```python
# openshift

 oc apply -f openshift .

```
## Generar SCC usuario bfa

```python
# openshift

 oc adm policy add-scc-to-user 30303 system:serviceaccount:mpizarro-dev:default

```

## Contribucion

[bfa](https://bfa.ar/)