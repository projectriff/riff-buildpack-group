apiVersion: build.pivotal.io/v1alpha1
kind: ClusterBuilder
metadata:
  name: riff-application
spec:
  image: cloudfoundry/cnb:`curl https://hub.docker.com/v2/repositories/cloudfoundry/cnb/tags | jq -r '.results[].name' | grep '\-bionic' | head -1`
