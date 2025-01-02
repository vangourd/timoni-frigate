package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#Service: corev1.#Service & {
	#config:    #Config
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:      #config.serviceName | "frigate-service"
		namespace: #config.namespace | "frigate"
	}
	spec: {
		selector: "app.kubernetes.io/name": #config.appLabel | "frigate"
		ports: [{
			name:       #config.portName | "http"
			protocol:   "TCP"
			port:       #config.servicePort | 80
			targetPort: #config.targetPort | 5000
		}]
	}
}
