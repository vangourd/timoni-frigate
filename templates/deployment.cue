package templates

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	#config:		#Config
	#cmName:		string
	#secretName:	string
	apiVersion: 	"apps/v1"
	kind:			"Deployment"
	metadata: 		#config.metadata
	spec: appsv1.#DeploymentSpec & {
		replicas: #config.replicas
		strategy: type: #config.strategy.type
		selector: matchLabels: #config.selector.labels
		template: {
			metadata: {
				labels: #config.selector.labels
				if #config.podAnnotations != _|_ {
					annotations: #config.podAnnotations
				}
				if #config.hardwareAcceleration == "nvidia" {
					annotations: #config.podAnnotations & 
					{
						"nvidia.com/gpu": "1"
					}
				}
			}
			spec: corev1.#PodSpec & {

				hostNetwork:true
				// TODO: This is bad. Privileged containers are bad mmkay.
				volumes: [{
					name: "frigate-config"
					configMap: name: #cmName
				}, {
					name: "frigate-datadir"
					persistentVolumeClaim: claimName: "frigate-datadir"
				}, {
					name: "frigate-models"
					persistentVolumeClaim: claimName: "frigate-models"
				}]
				
				if #config.hardwareAcceleration == "disabled" {
					containers: [{
						name:  "frigate"
						image: #config.image.reference
						ports: [{
							name:          "http"
							containerPort: 5000
						}]
						volumeMounts: [{
							name:      "frigate-datadir"
							mountPath: "/media"
						}, {
							name:      "frigate-config"
							mountPath: "/config/config.yaml"
							subPath: "config.yaml"
						}, {
							name:      "frigate-models"
							mountPath: "/trt-models"
						}]
						envFrom: [{
							secretRef: { 
								name: #secretName
							}
						}]
						securityContext: #config.securityContext
					}]
				}
				if #config.hardwareAcceleration == "nvidia" {
					runtimeClassName: "nvidia"
					nodeSelector: gpu: "true"
					tolerations: [{
						key:      "nvidia.com/gpu"
						operator: "Exists"
						effect:   "NoSchedule"
					}]
					initContainers: [{
						name:  "trt-models-job"
						image: "nvcr.io/nvidia/tensorrt:22.07-py3"
						command: ["bash", "-c"]
						volumeMounts: [{
							name:      "frigate-models"
							mountPath: "/trt-models"
						}]
						args: [
							"""
							if [ -f /trt-models/libyolo_layer.so ]; then
							echo \"Models already created, skipping\"
							exit 0
							fi

							wget https://github.com/blakeblackshear/frigate/raw/master/docker/tensorrt_models.sh
							chmod +x ./tensorrt_models.sh
							./tensorrt_models.sh
							mkdir -p /trt-models/
							mv /tensorrt_models/* /trt-models/

							""",
						]
					}]
					containers: [{
					name:  "frigate"
					image: "ghcr.io/blakeblackshear/frigate:stable-tensorrt"
					ports: [{
						name:          "http"
						containerPort: 5000
					}]
					volumeMounts: [{
						name:      "frigate-datadir"
						mountPath: "/media"
					}, {
						name:      "frigate-config"
						mountPath: "/config"
					}, {
						name:      "frigate-models"
						mountPath: "/trt-models"
					}]
					securityContext: #config.securityContext
					resources: limits: "nvidia.com/gpu": 1
				}]
				}
				
			}
		}
	}
}
