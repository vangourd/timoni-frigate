// Code generated by timoni.
// Note that this file must have no imports and all values must be concrete.

@if(!debug)

package main

// Defaults
values: {
	rtsp: {
		username: string @timoni(runtime:string:FRIGATE_RTSP_USER)
		password: string @timoni(runtime:string:FRIGATE_RTSP_PASSWORD)
	}
	image: {
		repository: "ghcr.io/blakeblackshear/frigate"
		digest:		"sha256:22e3d0b486df52c3d669682254c2b1bf4205fa6ad8bd8f8c9f7fe76b1517005d"
		tag:		"0.14.1"
	}
	frigate: {
		mqtt: {
			enabled: false
		}
		cameras: {
			driveway: {
				enabled: true
				ffmpeg: {
					inputs: [{
						path: "rtsp://{FRIGATE_RTSP_USER}:{FRIGATE_RTSP_PASSWORD}@192.168.1.1/cam/realmonitor?channel=1&subtype=0"
                        roles: ["detect", "record"]
					}]
				}
			}
		}
	}
}
