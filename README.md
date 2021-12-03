# Nodo BFA para Kubernetes

El propósito del proyecto es extender la el proyecto nodo del siguiente repositorio base [bfa](https://gitlab.bfa.ar/docker/bfanodo) a las plataformas de contenedores, verificado en el Sandbox Openshift Dedicado 4.9.

## Installation

Logear con el cliente de la plataforma del cluster, clonar el repositorio e importar todos los objetos k8s en el namespace.

```bash
kubectl apply -f k8s/ .
```
## Dockerfile

Existen dos tipos de dockerfile en el repositorio, el que toma de base la imagen del nodo en testnet y el que toma de base el cliente Ethereum clona el núcleo bfa y genera el build.

```bash
docker build -t nodo-bfa .
```

## BuildConfig

Se deberán generar secret y webhook(opcional) para clonar el repositorio en caso de necesitar hacer un fork.

```bash
kind: Secret
apiVersion: v1
metadata:
  name: gittoken
data:
  password: maximilianoPizarro
  username: token
type: kubernetes.io/basic-auth

kind: Secret
apiVersion: v1
metadata:
  name: hookbfa
data:
  WebHookSecretKey: hooksecret
type: Opaque

```

## ImageStream

Por lo menos debe existir la imagen nodo-bfa, recomiendo descargar a registry internal por el limite de descargas de dockerhub.

```bash
kind: ImageStream
apiVersion: image.openshift.io/v1
metadata:
  name: nodo-bfa
  labels:
    app: nodo-bfa
    app.kubernetes.io/component: nodo-bfa
    app.kubernetes.io/instance: nodo-bfa
    app.kubernetes.io/name: nodo-bfa
    app.kubernetes.io/part-of: nodo-bfa
spec:
  lookupPolicy:
    local: false
  tags:
    - name: test
      annotations:
        openshift.io/imported-from: 'bfaar/nodo:test'
      from:
        kind: DockerImage
        name: 'bfaar/nodo:test'
      generation: 2
      importPolicy: {}
      referencePolicy:
        type: Local

```

## Crear Volumen Persistente

```python
# el pvc se genero en el paso anterior, tengan en cuenta el storage segun los requerimientos del tipo de nodo a desplegar

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-bfa
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 15Gi

```

## ConfigMap

```python
# se creará el configmap docker-config  y se montará como volumen, principal atención a esta sección del DeploymentConfig, existe tambien un .env en donde se pueden sobreescribir las variables de entorno y cambiar de testnet a produccion por ejemplo.

volumeMounts:
  - name: nodo-bfa-1
    mountPath: /home/bfa/bfa/test2network/node
  - name: docker-config
    mountPath: /home/bfa/bfa/test2network/docker-config.toml
    subPath: docker-config.toml                      
                   

```

## Generar SCC usuario (solo si no buildea el Dockerfile)

```python
# requiere permisos cluster-admin

 oc adm policy add-scc-to-user 30303 system:serviceaccount:namespace:default

```

## Contribucion

[bfa](https://bfa.ar/)