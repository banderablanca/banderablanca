echo "---> Deploy function CreateNotifications"
gcloud functions deploy CreateNotifications --runtime go111 --trigger-event providers/cloud.firestore/eventTypes/document.create --trigger-resource "projects/$1/databases/(default)/documents/comments/{flagID}/comments/{commentID}" --timeout="450"
echo "---> Deploy Finished!"
