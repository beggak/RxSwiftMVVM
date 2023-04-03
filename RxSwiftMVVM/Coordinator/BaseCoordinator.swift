
class BaseCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    
    func start() {
        fatalError("Children coordiator should implement 'start'.")
    }
}
