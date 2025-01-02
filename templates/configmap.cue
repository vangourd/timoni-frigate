package templates

import (
    timoniv1 "timoni.sh/core/v1alpha1"
    yaml "encoding/yaml"
)

#ConfigMap: timoniv1.#ImmutableConfig & {
    #config: #Config
    #Kind:   timoniv1.#ConfigMapKind
    #Meta:   #config.metadata
    #Data: {
        "config.yaml": yaml.Marshal(#config.frigate)
    }
}


// Define the schema for the Frigate configuration.
#FrigateConfig: {
    mqtt: {
        enabled: bool | *true
        host: string | *"mqtt.server.com"
        port: int | *1883
        topic_prefix: string | *"frigate"
        client_id: string | *"frigate"
        user: string | *"mqtt_user"
        password: string | *"password"
        tls_ca_certs: string | *"/path/to/ca.crt"
        tls_client_cert: string | *"/path/to/client.crt"
        tls_client_key: string | *"/path/to/client.key"
        tls_insecure: bool | *false
        stats_interval: int | *60
    }

    detectors: [string]: {
        type: string | *"cpu"
    }

    database: {
        path: string | *"/config/frigate.db"
    }

    tls: {
        enabled: bool | *true
    }

    proxy: {
        header_map: [string]: string | *{}
        logout_url: string | *"/api/logout"
        auth_secret: *"None" | string
    }

    auth: {
        enabled: bool | *true
        reset_admin_password: bool | *false
        // cookie_name: string | *"frigate_token"
        // cookie_secure: bool | *false
        session_length: int | *86400
        refresh_time: int | *43200
        failed_login_rate_limit: *"None" | string
        trusted_proxies: [...string] | *[]
        hash_iterations: int | *600000
    }

    model: {
        path: string | *"/edgetpu_model.tflite"
        labelmap_path: string | *"/labelmap.txt"
        width: int | *320
        height: int | *320
        input_pixel_format: string | *"rgb"
        input_tensor: string | *"nhwc"
        model_type: string | *"ssd"
        labelmap: [int]: string | *{}
    }

    audio: {
        enabled: bool | *false
        // max_not_heard: int | *30
        min_volume: int | *500
        listen: [...string] | *["bark", "fire_alarm", "scream", "speech", "yell"]
        filters: [string]: {
            threshold: float | *0.8
        }
    }

    logger: {
        default: string | *"info"
        logs: [string]: string | *{}
    }

    environment_vars: [string]: string | *{}

    birdseye: {
        enabled: bool | *true
        restream: bool | *false
        width: int | *1280
        height: int | *720
        quality: int | *8
        mode: string | *"objects"
        inactivity_threshold: int | *30
        layout: {
            scaling_factor: float | *2.0
            max_cameras: int | *1
        }
    }

    ffmpeg: {
        global_args: string | *"-hide_banner -loglevel warning -threads 2"
        hwaccel_args: string | *"auto"
        input_args: string | *"preset-rtsp-generic"
        output_args: {
            detect: string | *"-threads 2 -f rawvideo -pix_fmt yuv420p"
            record: string | *"preset-record-generic"
        }
        retry_interval: int | *10
    }

    detect: {
        width: int | *1280
        height: int | *720
        fps: int | *5
        enabled: bool | *true
        min_initialized: int | *2
        max_disappeared: int | *25
    }

    cameras: [string]: {
        enabled: bool | *true
        ffmpeg: {
            inputs: [...{
                path: string
                roles: [...string]
            }]
        }
        detect: {
            enabled: bool | *true
            width: int | *1280
            height: int | *720
        }
        birdseye: {
            mode: string | *"continuous"
        }
    }
}