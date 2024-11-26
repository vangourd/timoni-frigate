package templates

persistentvolumeclaim: "frigate-datadir": {
	kind:       "PersistentVolumeClaim"
	apiVersion: "v1"
	metadata: {
		name:      "frigate-datadir"
		namespace: "frigate"
	}
	spec: {
		accessModes: ["ReadWriteOnce"]
		resources: requests: storage: "500Gi"
	}
}
persistentvolumeclaim: "frigate-models": {
	kind:       "PersistentVolumeClaim"
	apiVersion: "v1"
	metadata: {
		name:      "frigate-models"
		namespace: "frigate"
	}
	spec: {
		accessModes: ["ReadWriteOnce"]
		resources: requests: storage: "20Gi"
	}
}
