
#   YOU MUST FILL IN THE VALUES FOR THE MISSING VARIABLES BELOW

# PAT for Azure DevOps, used to deploy and manage the project
personal_access_token = "BluoUahAV9PeIofKbnZIUo1zo8GBoqtTrOXopAA2ro8mBUQpGuO2JQQJ99AKACAAAAAA3CiOAAASAZDOq4Eb"

# Subscription IDs for the development and production environments, these are the deployment targets for the pipelines created by this demo
# NOTE: you must use the same subscription values you used when running 'azureprep' to create the base infrastructure
production_subscription_id = "87ff0392-b7ef-4f58-8f08-44341f869380"
development_subscription_id = "b98347b0-4c4d-48ff-a0a2-320cf1cc97d9"

# this is the email address of the person running the script, need at least one default reviewer
default_reviewers = [
  "admin@MngEnvMCAP974625.onmicrosoft.com"
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
