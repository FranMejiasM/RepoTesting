public class AvoidPublicMembersOnlyUsedInTestsSampleCaller {
    public Decimal tvSampleRun() {
        AvoidPublicMembersOnlyUsedInTestsSample sample = new AvoidPublicMembersOnlyUsedInTestsSample();
        sample.tvSampleLimit = 10;
        Decimal result = sample.tvSampleDiscount(5, 0.5);
        result += sample.tvSampleTax(result);
        result += new AvoidPublicMembersOnlyUsedInTestsSample.TvSampleLine().tvSampleLineCompute();
        return result;
    }
}
