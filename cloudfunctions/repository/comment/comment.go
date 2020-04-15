package comment

import (
	"cloudfunctions/config"
	"cloudfunctions/models"
	"context"
	"sort"

	"google.golang.org/api/iterator"
)

var ctx = context.Background()
var db = config.GetDbInstance()

// GetUsers get users that comment at a white flag
func GetUsers(flagID string) <-chan []string {
	users := make(chan []string)

	go func() {
		defer close(users)

		var commenters []string

		iter := db.Collection("comments").Doc(flagID).Collection("comments").Documents(ctx)

		for {
			doc, err := iter.Next()

			if err == iterator.Done {
				break
			}

			comment := &models.Comment{}
			doc.DataTo(comment)

			if find := sort.SearchStrings(commenters, comment.UID); find < 0 {
				commenters = append(commenters, comment.UID)
			}
		}

		users <- commenters
	}()

	return users
}
