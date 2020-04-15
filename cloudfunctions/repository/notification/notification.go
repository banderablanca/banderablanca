package notification

import (
	"cloudfunctions/config"
	"cloudfunctions/models"
	"context"

	"cloud.google.com/go/firestore"
	"firebase.google.com/go/messaging"
)

var ctx = context.Background()
var msg = config.GetMessagingInstance()
var db = config.GetDbInstance()

// Save function to create a notification
func Save(userID string, notification map[string]interface{}) <-chan error {
	r := make(chan error)

	go func() {
		defer close(r)

		if notification["sender_name"] == "" {
			notification["sender_name"] = "Anónimo"
		}
		notification["timestamp"] = firestore.ServerTimestamp

		_, err := db.Collection("notifications/"+userID+"/notifications").NewDoc().Set(ctx, notification)
		r <- err
	}()

	return r
}

// Send function send notification to users thats comment a white flag
func Send(flagID string, comment *models.Comment) <-chan error {
	err := make(chan error)

	go func() {
		defer close(err)

		var senderName = "Anónimo"
		if comment.SenderName != "" {
			senderName = comment.SenderName
		}

		var message = &messaging.Message{
			Data: map[string]string{
				"click_action":     "FLUTTER_NOTIFICATION_CLICK",
				"uid":              comment.UID,
				"sender_photo_url": comment.SenderPhotoURL,
				"flag_id":          flagID,
			},
			Notification: &messaging.Notification{
				Title: "¡Nuevo comentario en la bandera!",
				Body:  senderName + ": " + comment.Text,
			},
			Condition: "'" + flagID + "NewComments' in topics",
		}

		_, e := msg.Send(ctx, message)
		err <- e
	}()

	return err
}
