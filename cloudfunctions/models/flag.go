package models

import "time"

// Flag model
type Flag struct {
	UID              string    `json:"uid" firestore:"uid"`
	Address          string    `json:"address" firestore:"address"`
	AddressReference string    `json:"address_reference" firestore:"address_reference"`
	Description      string    `json:"description" firestore:"description"`
	SenderName       string    `json:"sender_name" firestore:"sender_name"`
	SenderPhotoURL   string    `json:"sender_photo_url" firestore:"sender_photo_url"`
	Text             string    `json:"text" firestore:"text"`
	Timestamp        time.Time `json:"timestamp" firestore:"timestamp"`
	Visibility       string    `json:"visibility" firestore:"visibility"`
}
