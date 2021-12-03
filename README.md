# Nodo Gateway BFA para Kubernetes

El propósito de este proyecto consiste en generar los objetos kubernetes en base a la imagen del nodo en la red de testnet del repositorio oficial [nodo bfa](https://gitlab.bfa.ar/docker/bfanodo) para el despliegue en las plataformas de contenedores.  


<img src="https://img.shields.io/badge/redhat-CC0000?style=for-the-badge&logo=redhat&logoColor=white" alt="Redhat">

Verificado en [Sandbox RedHat OpenShift Dedicated](https://developers.redhat.com/developer-sandbox) (Openshift 4.9) sincronizando con la red de pruebas testnet. 

<p align="left">
  <img src="https://drive.google.com/u/0/uc?id=1sq9GXlpG-Q_73pFrb-u35EIZYfrft_GV&export=download" width="800" title="hover text">
</p>  

## Instalación

Autenticacar con el cliente del cluster, clonar el repositorio e importar todos los objetos k8s en el namespace.

```bash
kubectl apply -f k8s/ . -n $NAMESPACE
```
## Dockerfile y BuildConfig

Existen dos tipos de dockerfile en el repositorio, el que toma de base la imagen del nodo en testnet y el que toma de base el cliente Ethereum clona el núcleo bfa y genera la instalación. 

```bash
# local
docker build -t nodo-bfa .
```

También existe una configuración por medio de la clave dockerfile desde el objeto BuildConfig.

```bash
# k8s/buildconfig.yaml
kind: BuildConfig
apiVersion: build.openshift.io/v1
metadata:
  name: nodo-bfa-core-fork
spec:
  nodeSelector: null
  output:
    to:
      kind: ImageStreamTag
      name: 'nodo-bfa-core-fork:test'
  resources: {}
  successfulBuildsHistoryLimit: 5
  failedBuildsHistoryLimit: 5
  strategy:
    type: Docker
    dockerStrategy: {}
  postCommit: {}
  source:
    type: Git
    git:
      uri: 'https://gitlab.bfa.ar/docker/bfanodo.git'
      ref: master
    contextDir: "bfatoolbase"  
    dockerfile: "FROM bfaar/nodo:test \nUSER root \nRUN chown 30303:0 ${BFAHOME} && chgrp -R 0 ${BFAHOME} && chmod -R g=u ${BFAHOME} \nUSER bfa"
  runPolicy: Serial 
```

## Secret y WebHook (opcional)

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

Las imagenes se agregan en el paso de *kubectl appy*, se recomienda hacer un pull
a registry internal por el limite de descargas de dockerhub a fines de pruebas.

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

## Volumen Persistente

Es necesario persistir la cadena de blockchain sin importar la red a la que se sincronize por medio de un volumen persistente, el pvc se genera en el import de /k8s, tengan en cuenta el storage segun los requerimientos del tipo de nodo gateway a desplegar es de 300Gi minimo y en crecimiento continuo.

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

Con kubectl apply se crearán los configmap docker-config y env y se montarán como volumen.
```python
# k8s/deploymentconfig.yaml

volumeMounts:
  - name: docker-config
    mountPath: /home/bfa/bfa/test2network/docker-config.toml
    subPath: docker-config.toml
  - name: env
    mountPath: /home/bfa/bfa/bin/env
    subPath: env                                               

```

## Security Context Contraint (opcional - solo si toma la imagen de dockerhub)

El user por defecto de la imagen base del nodo corresponde al 30303 (bfa), para generar un contexto de id arbitrario se agrego el paso para poder asignarlo en el Dockerfile del repo segun las mejores prácticas de creación de contenedores de la [documentación oficial de redhat](https://docs.openshift.com/container-platform/4.7/openshift_images/create-images.html). En caso de querer generar el pull directo con dockerhub será requisito aplicar el SCC con el siguiente comando.

```python
# requiere permisos cluster-admin (no disponibles en el cluster sandbox)

 oc adm policy add-scc-to-user 30303 system:serviceaccount:$NAMESPACE:default

```

## Contribucion


| 🔭 Más info bfa.ar     	| <a href="https://bfa.ar/" target="_blank" alt="Blockchain Federal Argentina"><img src="https://bfa.ar/themes/bfa/logo.svg?style=for-the-badge" alt="Blockchain Federal Argentina" width="200" height="90"></a>                     	|
|---------------------------------	|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| 📫 contacto:   	| <a href="https://www.linkedin.com/in/maximiliano-gregorio-pizarro-consultor-it"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="linkedin">  	|
|            	|       	|

