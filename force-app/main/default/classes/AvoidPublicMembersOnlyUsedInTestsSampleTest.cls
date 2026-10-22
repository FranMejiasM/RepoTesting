@IsTest
private class AvoidPublicMembersOnlyUsedInTestsSampleTest {
    @IsTest
    static void coversSample() {
        AvoidPublicMembersOnlyUsedInTestsSample sample = new AvoidPublicMembersOnlyUsedInTestsSample();
        sample.tvSampleStatus = 'Open';
        sample.tvSampleCounter = 1;
        sample.tvSampleHidden = 2;
        Decimal value = sample.tvSampleDiscount(10);
        value += sample.tvSampleDiscount(10, 0.5);
        value += sample.tvSampleTax(10);
        value += AvoidPublicMembersOnlyUsedInTestsSample.TV_SAMPLE_RATE;
        value += AvoidPublicMembersOnlyUsedInTestsSample.tvSampleRoundUp(value);
        AvoidPublicMembersOnlyUsedInTestsSample.TvSampleLine line = new AvoidPublicMembersOnlyUsedInTestsSample.TvSampleLine();
        line.tvSampleLineTotal = 1;
        value += line.tvSampleLineCompute();
        String loaded = AvoidPublicMembersOnlyUsedInTestsSample.tvSampleLoad();
        System.assertNotEquals(null, value, 'A value is expected');
        System.assertEquals('loaded', loaded, 'The load result is expected');
    }
}
