package templates

import (
	timoniv1 "timoni.sh/core/v1alpha1"
)

#Secret: timoniv1.#ImmutableConfig & {
	#config:	#Config
	#Kind:		timoniv1.#SecretKind
	#Meta:		#config.metadata
	#Data: {
		"FRIGATE_RTSP_USER": #config.rtsp.username
		"FRIGATE_RTSP_PASSWORD": #config.rtsp.password
	}
}