import Vapor
import VaporMySQL

let drop = Droplet()

/// Hello world test
// call with param like: http://localhost:8080/hello?name=awesome%20Swift
drop.get("hello") { request in 

    guard let name = request.data["name"]?.string else {
        return "Hello World! Use the name parameter to get a personalized hello!"
    }

   return "Hello \(name)!"
}

/// Get JSON test
drop.get("json") { request in
    return try JSON(node: [
        "number": 123,
        "text": "server side swift is awesome",
        "bool": false
    ])
}


drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

/// Security square AP
drop.get("squareMe") { request in
    guard let intValue = request.data["number"]?.int else {
        
        return "Oops... You didn't provide a valid integer to be squared! Try using the end of the URL to be something like: 'squareMe?number=2'"
    }
    return "You provided the number \(intValue), which when squared becomes: \(intValue * intValue)"
}

/// MARK: - Connecting to a MySQL DB using a tutorial
try drop.addProvider(VaporMySQL.Provider.self)
drop.preparations.append(Attendee.self)
drop.group("api") { api in
    api.resource("attendees", AttendeesController())
}

drop.resource("posts", PostController())

drop.run()
