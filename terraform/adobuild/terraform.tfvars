
#   YOU MUST FILL IN THE VALUES FOR THE MISSING VARIABLES BELOW

# PAT for Azure DevOps, used to deploy and manage the project
personal_access_token = "YOUR_PAT_HERE"

# Subscription IDs for the development and production environments, these are the deployment targets for the pipelines created by this demo
# NOTE: you must use the same subscription values you used when running 'azureprep' to create the base infrastructure
production_subscription_id = "<DEV_SUBSCRIPTION>"
development_subscription_id = "<PROD_SUBSCRIPTION>"

# this is the email address of the person running the script, need at least one default reviewer
default_reviewers = [
  "<your@email.here>"
]

# For demo purposes, we only require 1 reviewer, but you can increase this number in a production environment
minimum_number_of_reviewers = 1

# application name for the pipeline folder structure
application_name = "adobuilder"

# list of environments to deploy to, THIS DEMO DOES NOT YET SUPPORT MODIFYING THIS VALUE
environments = [
  "dev",
  "prod"
]
