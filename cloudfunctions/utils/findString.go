package utils

// FindString function to find string in slice of strings
func FindString(slice []string, val string) int {
	for i, item := range slice {
		if item == val {
			return i
		}
	}
	return -1
}
