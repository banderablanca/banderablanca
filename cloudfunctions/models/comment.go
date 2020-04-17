package models

import "time"

// Comment model
type Comment struct {
	UID            string    `json:"uid" firestore:"uid"`
	SenderName     string    `json:"sender_name" firestore:"sender_name"`
	SenderPhotoURL string    `json:"sender_photo_url" firestore:"sender_photo_url"`
	Text           string    `json:"text" firestore:"text"`
	Timestamp      time.Time `json:"timestamp" firestore:"timestamp"`
	Visibility     string    `json:"visibility" firestore:"visibility"`
}

// CommentFirestore model
type CommentFirestore struct {
	UID struct {
		Value string `json:"stringValue"`
	} `json:"uid"`
	SenderName struct {
		Value string `json:"stringValue"`
	} `json:"sender_name"`
	SenderPhotoURL struct {
		Value string `json:"stringValue"`
	} `json:"sender_photo_url"`
	Text struct {
		Value string `json:"stringValue"`
	} `json:"text"`
	Timestamp struct {
		Value string `json:"timestampValue"`
	} `json:"timestamp"`
	Visibility struct {
		Value string `json:"stringValue"`
	} `json:"visibility"`
}

// ParseComment convert CommentFirestore to Comment
func (c *CommentFirestore) ParseComment() Comment {
	comment := Comment{
		UID:            c.UID.Value,
		SenderName:     c.SenderName.Value,
		SenderPhotoURL: c.SenderPhotoURL.Value,
		Text:           c.Text.Value,
		Visibility:     c.Visibility.Value,
	}
	return comment
}
