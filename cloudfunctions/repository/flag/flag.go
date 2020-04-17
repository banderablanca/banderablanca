package flag

import (
	"cloudfunctions/config"
	"cloudfunctions/models"
	"context"
)

var ctx = context.Background()
var db = config.GetDbInstance()

// GetByID get flag by ID
func GetByID(flagID string) <-chan models.Flag {
	flag := make(chan models.Flag)

	go func() {
		defer close(flag)

		dsnap, _ := db.Collection("flags").Doc(flagID).Get(ctx)

		var f models.Flag
		dsnap.DataTo(&f)

		flag <- f
	}()

	return flag
}
