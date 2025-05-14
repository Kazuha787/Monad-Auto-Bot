using HTTP
using JSON

# Your GitHub username
username = "Kazuha787"

# GitHub API URL
url = "https://api.github.com/users/$Kazuha787"

# Make GET request
response = HTTP.get(url)

# Parse JSON response
profile = JSON.parse(String(response.body))

# Display cool stuff
println("GitHub Username: ", profile["login"])
println("Name: ", get(profile, "name", "N/A"))
println("Bio: ", get(profile, "bio", "N/A"))
println("Public Repos: ", profile["public_repos"])
println("Followers: ", profile["followers"])
println("Following: ", profile["following"])
println("GitHub Profile: ", profile["html_url"])
