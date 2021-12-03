# Nucleo BFA para Kubernetes

El propósito del proyecto es extender la el proyecto nodo del siguiente repositorio base [bfa](https://gitlab.bfa.ar/docker/bfanodo) a las plataformas de contenedores. 

Verificado en Sandbox RedHat OpenShift Dedicated (Openshift 4.9) sincronizando con la red de pruebas testnet. <img src="https://img.shields.io/badge/redhat-CC0000?style=for-the-badge&logo=redhat&logoColor=white" alt="Redhat">


<p align="left">
  <img src="https://raw.githubusercontent.com/maximilianoPizarro/bfa/main/RedHatOpenShiftDedicated.PNG?token=ADJYHOJXSJHR5SOHJW4AQSLBVIW2Y" width="800" title="hover text">
</p>  


## Installation

Logear con el cliente del cluster, clonar el repositorio e importar todos los objetos k8s en el namespace.

```bash
kubectl apply -f k8s/ .
```
## Dockerfile

Existen dos tipos de dockerfile en el repositorio, el que toma de base la imagen del nodo en testnet y el que toma de base el cliente Ethereum clona el núcleo bfa y genera el build.

```bash
docker build -t nodo-bfa .
```

## BuildConfig

Para la implementacion de CI/CD a partir de este repositorio se deberán generar secret y webhook(opcional) para clonar el repositorio en caso de necesitar hacer un fork.

```bash

# k8s/secret.yaml

kind: Secret
apiVersion: v1
metadata:
  name: gittoken
data:
  password: maximilianoPizarro
  username: token
type: kubernetes.io/basic-auth

# k8s/secret.yaml

kind: Secret
apiVersion: v1
metadata:
  name: hookbfa
data:
  WebHookSecretKey: hooksecret
type: Opaque

```

## ImageStream

Por lo menos debe existir la imagen nodo-bfa, recomiendo descargar 
a registry internal por el limite de descargas de dockerhub.

```bash
# k8s/imagestream.yaml

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

el pvc se genera en el import de /k8s, tengan en cuenta el storage segun 
los requerimientos del tipo de nodo gateway a desplegar 300Gi minimo.

```python

# k8s/pvc.yaml

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
se creará el configmap docker-config  y se montará como volumen, principal atención a esta sección del DeploymentConfig, existe tambien un .env en donde se pueden sobreescribir las variables de entorno y cambiar de testnet a produccion por ejemplo
```python
# k8s/deploymentconfig.yaml

volumeMounts:
  - name: nodo-bfa-1
    mountPath: /home/bfa/bfa/test2network/node
  - name: docker-config
    mountPath: /home/bfa/bfa/test2network/docker-config.toml
    subPath: docker-config.toml                      
                   

```

## Generar SCC usuario (solo si no buildea el Dockerfile)

El user por defecto de la imagen base del nodo corresponde al 1001, para generar un contexto de id arbitrario
se agrego el paso para poder asignarlo en el Dockerfile del repo segun las mejores prácticas de creación de contenedores
de la [documentación oficial de redhat](https://docs.openshift.com/container-platform/4.7/openshift_images/create-images.html)

```python
# requiere permisos cluster-admin

 oc adm policy add-scc-to-user 30303 system:serviceaccount:$NAMESPACE:default

```

## Contribucion

[bfa](https://bfa.ar/)