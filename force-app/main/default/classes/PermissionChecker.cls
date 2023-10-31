public class PermissionChecker {

    private static final String NO_PERMISSION = 'Current user does not have permission to ';
    private static final String TO_ACCESS = 'access ';
	private static final String TO_UPDATE = 'update ';
	private static final String TO_DELETE = 'delete ';
	private static final String TO_CREATE = 'create ';

	public static void exceptionIfNotAccessible(Schema.SObjectType obj){
		if (!obj.getDescribe().isAccessible()) {
			throw new HasNoAccessException(NO_PERMISSION + TO_ACCESS + obj);
		}
	}

	public static void exceptionIfNotUpdateable(Schema.SObjectType obj){
		if (!obj.getDescribe().isUpdateable()) {
			throw new HasNoAccessException(NO_PERMISSION + TO_UPDATE + obj);
		}
	}

	public static void exceptionIfNotDeletable(Schema.SObjectType obj){
		if (!obj.getDescribe().isDeletable()) {
			throw new HasNoAccessException(NO_PERMISSION + TO_DELETE + obj);
		}
	}

	public static void exceptionIfNotCreateable(Schema.SObjectType obj){
		if (!obj.getDescribe().isCreateable()) {
			throw new HasNoAccessException(NO_PERMISSION + TO_CREATE + obj);
		}
	}
}