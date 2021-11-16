provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}

resource "helm_release" "grafana" {
  name       = "my-grafana-release"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "grafana"
  namespace = "viet"

  values = [
    file("${path.module}/grafana-values.yaml")
  ]
  
}
