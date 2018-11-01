#Atlassian Confluence Cloud deployment

###Set up automated Atlassian Confluence deployment and CI/CD


##Requirements:
    Docker (18.06)
    Terraform (11.10)
    Google Cloud SDK (218.0.0)

##Initial Setup:
    Create project using GCP Console
    Create service account for project with role "Owner"
    Setup authentication for Terraform using json-file
    -  download json using GCP Console
    -  export GOOGLE_APPLICATION_CREDENTIALS="<<path-to-json-file>>"

##How to run:
```
cd infrastructure/terraform
terraform apply
```

##Project structure

![Project structure](misc/scheme.png)

## Folder structure:
docker.img     - Dockerfiles and all stuff needed for images
infrastructure - Infrasturucture creation scripts (terraform, etc)
misc           - Additional files
pipelines      - Jenkins pipelines
scripts        - Additional scripts
