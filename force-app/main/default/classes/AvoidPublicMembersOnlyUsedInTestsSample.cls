public class AvoidPublicMembersOnlyUsedInTestsSample {
    public static final Decimal TV_SAMPLE_RATE = 0.2;
    public String tvSampleStatus;
    public Integer tvSampleCounter { get; set; }
    public Decimal tvSampleLimit;
    @TestVisible private Integer tvSampleHidden;

    public AvoidPublicMembersOnlyUsedInTestsSample() {
        tvSampleHidden = 0;
    }

    public Decimal tvSampleDiscount(Decimal amount) {
        return amount * 0.9;
    }

    public Decimal tvSampleDiscount(Decimal amount, Decimal pct) {
        return amount * pct;
    }

    public Decimal tvSampleTax(Decimal amount) {
        return amount * 1.2;
    }

    public static Decimal tvSampleRoundUp(Decimal value) {
        return value.round(System.RoundingMode.UP);
    }

    @AuraEnabled
    public static String tvSampleLoad() {
        return 'loaded';
    }

    public class TvSampleLine {
        public Decimal tvSampleLineTotal;

        public Decimal tvSampleLineCompute() {
            return 0;
        }
    }
}
