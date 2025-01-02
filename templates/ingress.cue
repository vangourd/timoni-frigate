
package templates

import (
	networkingv1 "k8s.io/api/networking/v1"
)

#Ingress: networkingv1.#Ingress & {
	#config:	#Config
	#cmName:	string
	apiVersion:	"networking.k8s.io/v1"
	kind:		"Ingress"
	metadata:   #config.metadata
	spec: {
		rules: [{
			host: #config.host
			http: paths: [{
				path:		"/"
				pathType: 	"Prefix"
				backend: 	service: {
					name: #config.serviceName | "frigate-service"
					port: number: #config.port | 80
				}
			}]
		}]
		tls: [{
			secretName: #config.tlsSecretName | #config.host
			hosts: [#config.host]
		}]
	}
}
