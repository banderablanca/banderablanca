package cloudfunctions

import (
	"cloudfunctions/models"
	"cloudfunctions/repository/comment"
	"cloudfunctions/repository/flag"
	"cloudfunctions/repository/notification"
	"cloudfunctions/utils"
	"context"
	"log"
)

// CreateNotifications trigger to create a notification to user that created a white flag
func CreateNotifications(ctx context.Context, e models.EventComment) error {
	path := e.Value.Name
	flagID := utils.GetParams(path, "comments")
	flagComment := e.Value.Fields.ParseComment()

	flagNotification := map[string]interface{}{
		"sender_name":      flagComment.SenderName,
		"sender_photo_url": flagComment.SenderPhotoURL,
		"message":          flagComment.Text,
		"uid":              flagComment.UID,
		"flag_id":          flagID,
	}

	flagSelected := <-flag.GetByID(flagID)
	commenters := <-comment.GetUsers(flagID)

	// Create Notifications
	for _, userID := range commenters {
		if userID != flagComment.UID && userID != flagSelected.UID {
			err := <-notification.Save(userID, flagNotification)
			if err != nil {
				log.Fatalf("Error save notification: %v", err)
				return err
			}
		}
	}

	if flagComment.UID != flagSelected.UID {
		err := <-notification.Save(flagSelected.UID, flagNotification)
		if err != nil {
			log.Fatalf("Error send notification to flag creator: %v", err)
			return err
		}
	}

	err := <-notification.Send(flagID, &flagComment)
	return err
}
