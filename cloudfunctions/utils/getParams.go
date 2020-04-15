package utils

import "strings"

/*
GetParams get value of a param from route
for example:
	route = projects/{id}/databases/(default)/documents/user_teams/{userTeamsId}/teams/{teamsId}
	key = "user_teams"
	return {userTeamsId}
*/
func GetParams(route string, key string) string {
	fullPath := strings.Split(route, "/documents/")[1]
	pathParts := strings.Split(fullPath, "/")

	for i, n := range pathParts {
		if key == n {
			return pathParts[i+1]
		}
	}

	return ""
}
