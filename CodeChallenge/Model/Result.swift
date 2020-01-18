// Result enum to show success or failure
enum Result<T> {
    case success(T)
    case failure(APPError)
}
