package cloudfunctions

import (
	"cloudfunctions/models"
	"cloudfunctions/repository/comment"
	"cloudfunctions/repository/notification"
	"cloudfunctions/utils"
	"context"
	"log"
	"sort"
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
		"flag_id":          flagID,
	}

	commenters := <-comment.GetUsers(flagID)
	// Create Notifications
	for _, userID := range commenters {
		err := <-notification.Save(userID, flagNotification)
		if err != nil {
			log.Fatalf("Error save notification: %v", err)
			return err
		}
	}

	if find := sort.SearchStrings(commenters, flagComment.UID); find < 0 {
		err := <-notification.Save(flagComment.UID, flagNotification)
		if err != nil {
			log.Fatalf("Error send notification to creator flag: %v", err)
			return err
		}
	}

	err := <-notification.Send(flagID, &flagComment)
	return err
}
