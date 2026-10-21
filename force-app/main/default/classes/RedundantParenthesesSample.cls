public with sharing class RedundantParenthesesSample {

    // Positive: each line below should raise an issue
    public Integer doubledParentheses(Integer a, Integer b) {
        Integer total = ((a + b));
        return total;
    }

    public Integer wholeReturnValue(Integer a, Integer b) {
        return (a + b);
    }

    public Integer wholeAssignedValue(Integer a, Integer b) {
        Integer total = (a * b);
        return total;
    }

    public String wholeArgument(String name) {
        return String.valueOf((name.length()));
    }

    public Integer wholeIndex(List<Integer> values, Integer i) {
        return values[(i - 1)];
    }

    public Boolean singleOperand(Boolean flag, Boolean other) {
        Boolean result = (flag) && other;
        return result;
    }

    public String singleLiteral() {
        String label = ('Quality') + ' Clouds';
        return label;
    }

    // Negative: none of the lines below should raise an issue
    public Integer precedenceGrouping(Integer a, Integer b, Integer c) {
        Integer total = (a + b) * c;
        return total;
    }

    public Decimal castExpression(Object value) {
        Decimal amount = (Decimal) value;
        return amount;
    }

    public Boolean conditionParentheses(Integer a) {
        if (a > 0) {
            return true;
        }
        return false;
    }

    public Integer methodCall(String name) {
        return name.length();
    }

    // return (a + b);  comment lines are skipped
}