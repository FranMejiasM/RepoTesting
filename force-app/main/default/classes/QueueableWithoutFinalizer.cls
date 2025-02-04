// Incorrect code, does not attach a finalizer.
public class UserUpdater implements Queueable {
    public List<User> usersToUpdate;

    public UserUpdater(List<User> usersToUpdate) {
        this.usersToUpdate = usersToUpdate;
    }

    public void execute(QueueableContext context) { // no Finalizer is attached
        update usersToUpdate;
    }
}
