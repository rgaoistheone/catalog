output: {
	type: "webservice"
	properties: {
		if parameter["repo"] == _|_ {
			image: "oamdev/velaux:" + context.metadata.version
		}

		if parameter["repo"] != _|_ {
			image: parameter["repo"] + "/" + "oamdev/velaux:" + context.metadata.version
		}

		if parameter["imagePullSecrets"] != _|_ {
			imagePullSecrets: parameter["imagePullSecrets"]
		}

		ports: [
			{
				port:     80
				protocol: "TCP"
				expose:   true
			},
		]
		if parameter["serviceType"] != _|_ {
			exposeType: parameter["serviceType"]
		}
		if parameter["dex"] == "true" {
			env: [
				{
					name:  "KUBEVELA_API_URL"
					value: "apiserver.vela-system:8000"
				},
				{
					name:  "DEX_URL"
					value: "dex.vela-system:5556"
				}
			]
		}
		if parameter["dex"] == "false" {
			env: [
				{
					name:  "KUBEVELA_API_URL"
					value: "apiserver.vela-system:8000"
				}
			]
		}
	}
	if parameter["domain"] != _|_ {
		traits: [
			{
				type: "gateway"
				properties: {
					domain: parameter["domain"]
					http: {
						"/": 80
					}
					class: "nginx"
				}
			},
		]
	}
	dependsOn: ["apiserver"]
}
