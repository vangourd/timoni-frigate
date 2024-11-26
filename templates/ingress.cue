package templates

ingress: frigate: {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata: {
		name:      "frigate"
		namespace: "frigate"
	}
	spec: {
		rules: [{
			host: "<your-domain-here"
			http: paths: [{
				path:     "/"
				pathType: "Prefix"
				backend: service: {
					name: "frigate-service"
					port: number: 80
				}
			}]
		}]
		tls: [{
			secretName: "<your-secret-here>"
			hosts: ["<your-domain-here>"]
		}]
	}
}
