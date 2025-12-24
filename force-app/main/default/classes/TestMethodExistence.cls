@IsTest
public class TestMethodExistence {
    @IsTest
    static void testEmailMethod() {
        // Call controller method
        Boolean result = CommunityRegistrationController.checkDuplicateEmail('test@example.com');
        System.assertEquals(false, result);
    }
}