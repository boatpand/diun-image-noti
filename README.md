## DIUN and MSTeams notification

### must add secrets before apply
* diun/secrets.yaml
* nginx/container-registry-secrets.yaml
* nginx-do/container-registry-secrets.yaml

#### diun/secrets.yaml
```sh
apiVersion: v1
kind: Secret
metadata:
  name: diun-secret
  namespace: default
type: Opaque
stringData:
  username: 
  password:
  do-username: 
  do-password:
  teamsWebhookUrl:
  teamsTemplateBody: |
    {{ .Entry.Metadata.deployment_name }} in namespace {{.Entry.Metadata.namespace}} is deploying with image {{.Entry.Metadata.image_name}} <br /><br />
    Docker tag {{ if .Entry.Image.HubLink }}[`{{ .Entry.Image }}`]({{ .Entry.Image.HubLink }}){{ else }}`{{ .Entry.Image }}`{{ end }}{{ if (eq .Entry.Status "new") }} newly added{{ else }} updated{{ end }}.

```

#### nginx/container-registry-secrets.yaml
```sh
apiVersion: v1
kind: Secret
metadata:
  name: container-registry-secret
type: kubernetes.io/dockerconfigjson
stringData:
  .dockerconfigjson: '{"auths":{"https://registry-1.docker.io":{"auth":""}}}'
```

#### nginx-do/container-registry-secrets.yaml
```sh
apiVersion: v1
kind: Secret
metadata:
  name: container-registry-secret
  namespace: do
type: kubernetes.io/dockerconfigjson
stringData:
  .dockerconfigjson: '{"auths":{"registry.digitalocean.com":{"auth":""}}}'
```

### Apply Secrets
```sh
kubectl apply -f diun/secrets.yaml
kubectl apply -f nginx/container-registry-secrets.yaml
kubectl apply -f nginx-do/container-registry-secrets.yaml
```

### Run kustomization
```sh
cd diun
kubectl kustomize . --enable-helm | kubectl apply -f -

cd nginx
kubectl kustomize . --enable-helm | kubectl apply -f -

cd nginx-do
kubectl kustomize . --enable-helm | kubectl apply -f -
```

![Alt text](./teams-noti-dockerhub.png?raw=true "teams-noti")
![Alt text](./teams-noti-docr.png?raw=true "teams-noti")