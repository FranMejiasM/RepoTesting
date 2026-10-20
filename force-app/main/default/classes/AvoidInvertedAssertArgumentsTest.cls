@IsTest
private class AvoidInvertedAssertArgumentsTest {
    private static final String EXPECTED = 'Test';
    private static final String expectedName = 'Test';
    private static String mutableName = 'Test';

    @IsTest
    static void wrongOrder() {
        final Integer expectedCount = 3;
        Integer n = 3;
        Account acc = new Account(Name = 'Test');
        System.assertEquals(acc.Name, 'Test');
        System.assertNotEquals(n, 0, 'n should not be zero');
        Assert.areEqual(acc.Name, 'Test');
        Assert.areNotEqual(getValue(), null);
        system.assertequals(n, 5);
        System.assertEquals(n, -1);
        System.assertEquals(acc.Name, EXPECTED);
        System.assertEquals(n > 1, true);
        System.assertEquals(acc.Name, expectedName);
        System.assertEquals(n, expectedCount);
    }

    @IsTest
    static void rightOrder() {
        Integer n = 3;
        Account acc = new Account(Name = 'Test');
        System.assertEquals('Test', acc.Name);
        System.assertEquals(3, n, 'n should be 3');
        System.assertEquals(n, getValue());
        Assert.areEqual(null, getValue());
        System.assertEquals(true, n > 1);
        System.assertEquals(expectedName, acc.Name);
        System.assertEquals(acc.Name, mutableName);
        System.assertEquals(1, 2);
        System.assert(n == 3);
        assertEquals(n, 3);
    }

    static Integer getValue() {
        return 1;
    }

    static void assertEquals(Integer actual, Integer expected) {
    }
}
