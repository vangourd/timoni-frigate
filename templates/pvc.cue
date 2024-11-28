package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#PersistentVolumeClaimDatadir: corev1.#PersistentVolumeClaim & {
	#config:	#Config
    kind: "PersistentVolumeClaim"
    apiVersion: "v1"
    metadata: {
		name:      "frigate-data"
        namespace: string | *"frigate"
    }
    spec: {
        accessModes: ["ReadWriteOnce"]
        resources: requests: storage: #config.persistence.dataDirSize
    }
}

#PersistentVolumeClaimModels: corev1.#PersistentVolumeClaim &  {
	#config:	#Config
    kind: "PersistentVolumeClaim"
    apiVersion: "v1"
    metadata: {
        name:      "frigate-models"
        namespace: string | *"frigate"
    }
    spec: {
        accessModes: ["ReadWriteOnce"]
        resources: requests: storage: #config.persistence.modelDirSize
    }
}