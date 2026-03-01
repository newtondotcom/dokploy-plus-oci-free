# Apply all modules
apply:
    tofu apply -var-file="user/terraform.tfvars"

# Plan all modules
plan:
    tofu plan -var-file="user/terraform.tfvars"

# Init terraform
init:
    tofu init

# Apply only S3 module
apply-s3:
    tofu apply -target=module.s3 -var-file="user/terraform.tfvars"
    @just show-s3-keys

# Apply only alert module
apply-alert:
    tofu apply -target=module.alert -var-file="user/terraform.tfvars"

# Apply only dokploy module
apply-dokploy:
    tofu apply -target=module.dokploy -var-file="user/terraform.tfvars"

# Plan S3 module
plan-s3:
    tofu plan -target=module.s3 -var-file="user/terraform.tfvars"

# Plan alert module
plan-alert:
    tofu plan -target=module.alert -var-file="user/terraform.tfvars"

# Plan dokploy module
plan-dokploy:
    tofu plan -target=module.dokploy -var-file="user/terraform.tfvars"

# Destroy all
destroy:
    tofu destroy -var-file="user/terraform.tfvars"

# Destroy only S3 module
destroy-s3:
    tofu destroy -target=module.s3 -var-file="user/terraform.tfvars"

# Show S3 secret keys
show-s3-keys:
    @echo "Standard Bucket Secret Key:"
    @tofu output -raw standard_bucket_secret_key
    @echo "\n\nArchive Bucket Secret Key:"
    @tofu output -raw archive_bucket_secret_key
    @echo ""

# Destroy only alert module
destroy-alert:
    tofu destroy -target=module.alert -var-file="user/terraform.tfvars"

# Destroy only dokploy module
destroy-dokploy:
    tofu destroy -target=module.dokploy -var-file="user/terraform.tfvars"

# Format tofu files
fmt:
    tofu fmt -recursive

# Validate configuration
validate:
    tofu validate
