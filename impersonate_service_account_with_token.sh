export PROJECT_ID=$(gcloud config get-value core/project)

# Create the SA
export SA_NAME="retail-service-account"
gcloud iam service-accounts create $SA_NAME --display-name $SA_NAME

# Bind the SA to some role
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
 --member="serviceAccount:$SA_NAME@${PROJECT_ID}.iam.gserviceaccount.com" \
 --role="roles/retail.editor"

# Create a role binding on the Retail API service account for your 
# user account to permit impersonation
export USER_ACCOUNT=$(gcloud config list --format 'value(core.account)')
gcloud iam service-accounts add-iam-policy-binding $SA_NAME@$PROJECT_ID.iam.gserviceaccount.com --member "user:$USER_ACCOUNT" --role roles/iam.serviceAccountTokenCreator

# Generate a temporary access token for the Retail API
export ACCESS_TOKEN=$(gcloud auth print-access-token --impersonate-service-account $SA_NAME@$PROJECT_ID.iam.gserviceaccount.com )