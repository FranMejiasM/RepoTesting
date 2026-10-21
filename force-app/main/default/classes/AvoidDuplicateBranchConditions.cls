public class AvoidDuplicateBranchConditions {
    public enum Color { RED, GREEN, BLUE }

    public Integer duplicated(Integer a, String s, Object o) {
        Integer r = 0;
        if (a == 1) {
            r = 1;
        } else if (a == 1) {
            r = 2;
        }
        if (s.equals('x') && a > 0) {
            r = 3;
        } else if (a < 0) {
            r = 4;
        } else if (S.Equals( 'x' )  &&  a > 0) {
            r = 5;
        }
        if (o instanceof Account) {
            r = 6;
        } else if (o instanceof Contact) {
            r = 7;
        } else if (o instanceof Contact) {
            r = 8;
        } else if (O INSTANCEOF Account) {
            r = 9;
        }
        if (a == 1) {
            r = 10;
        } else if (1 == a) {
            r = 11;
        }
        if (a > 0) {
            r = 12;
        } else if (0 < a) {
            r = 13;
        }
        if (o != null && a >= 2) {
            r = 14;
        } else if (null != o && 2 <= a) {
            r = 15;
        }
        if (a == 2) {
            r = 16;
        } else if ((a == 2)) {
            r = 17;
        }
        return r;
    }

    public Integer differentOrder(Integer a, Integer b, String s) {
        Integer r = 0;
        if (a > b) {
            r = 1;
        } else if (b > a) {
            r = 2;
        }
        if (a < 1) {
            r = 3;
        } else if (a > 1) {
            r = 4;
        }
        if (a - 1 == 0) {
            r = 5;
        } else if (1 - a == 0) {
            r = 6;
        }
        if (s == 'x') {
            r = 7;
        } else if ('y' == s) {
            r = 8;
        }
        if (s != null && s.length() > 1) {
            r = 9;
        } else if (s.length() > 1 && s != null) {
            r = 10;
        }
        return r;
    }

    public Integer different(Integer a, String s, Color c, SObject o) {
        Integer r = 0;
        if (a == 1) {
            r = 1;
        } else if (a == 2) {
            r = 2;
        } else {
            r = 3;
        }
        if (a == 1) {
            r = 4;
        }
        if (a == 1) {
            r = 5;
        }
        if (a > 0) {
            if (a > 0) {
                r = 6;
            }
        } else if (a < 0) {
            r = 7;
        } else {
            if (a > 0) {
                r = 8;
            }
        }
        if (s == 'x') {
            r = 9;
        } else if (s == 'y') {
            r = 10;
        }
        switch on s {
            when 'x' { r = 11; }
            when 'y', 'z' { r = 12; }
            when else { r = 13; }
        }
        switch on c {
            when RED { r = 14; }
            when GREEN, BLUE { r = 15; }
        }
        switch on o {
            when Account acc { r = 16; }
            when Contact con { r = 17; }
        }
        return r;
    }
}
