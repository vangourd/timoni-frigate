package templates

service: "frigate-service": {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:      "frigate-service"
		namespace: "frigate"
	}
	spec: {
		selector: app: "frigate"
		ports: [{
			name:       "http"
			protocol:   "TCP"
			port:       80
			targetPort: 5000
		}]
	}
}
