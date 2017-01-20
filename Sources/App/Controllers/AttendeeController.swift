import Vapor
import HTTP

final class AttendeesController: ResourceRepresentable {
    
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Attendee.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        guard let name = request.data["name"]?.string else {
            throw Abort.custom(status: Status.preconditionFailed, message: "Missing Name")
        }
        guard let email = request.data["email"]?.string else {
            throw Abort.custom(status: Status.preconditionFailed, message: "Missing Email")
        }
        guard email.contains("@"), email.characters.count > 4 else {
            throw Abort.custom(status: Status.preconditionFailed, message: "Invalid Email")
        }
        
        var attendee = Attendee(name: name, email: email)
        try attendee.save()
        return try attendee.converted(to: JSON.self)
    }
    
    func makeResource() -> Resource<Attendee> {
        return Resource(
            index: index,
            store: create
        )
    }
    
    
}
