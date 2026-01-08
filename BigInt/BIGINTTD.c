#include "BIGINT.H"
#include "BDSCTEST.H"

main() {
    START_TESTING("BIGINTTD.C");

    TEST_CASE("Read and write bigint 1234567") {
        struct bigint bi;
        set_bigint("1234567", &bi);
        ASSERT_STR(get_bigint(bi), "1234567");
    }

    /* Single digit addition tests */
    TEST_CASE("Add single digit: 5 + 3") {
        struct bigint bi1, bi2, result;
        set_bigint("5", &bi1);
        set_bigint("3", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "8");
    }

    TEST_CASE("Add single digit with carry: 7 + 8") {
        struct bigint bi1, bi2, result;
        set_bigint("7", &bi1);
        set_bigint("8", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "15");
    }

    TEST_CASE("Add single digit: 0 + 0") {
        struct bigint bi1, bi2, result;
        set_bigint("0", &bi1);
        set_bigint("0", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "0");
    }

    /* Double digit addition tests */
    TEST_CASE("Add double digit: 23 + 45") {
        struct bigint bi1, bi2, result;
        set_bigint("23", &bi1);
        set_bigint("45", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "68");
    }

    TEST_CASE("Add double digit with carry: 67 + 88") {
        struct bigint bi1, bi2, result;
        set_bigint("67", &bi1);
        set_bigint("88", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "155");
    }

    TEST_CASE("Add double digit: 99 + 99") {
        struct bigint bi1, bi2, result;
        set_bigint("99", &bi1);
        set_bigint("99", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "198");
    }

    /* Ten digit addition tests */
    TEST_CASE("Add ten digit: 1234567890 + 9876543210") {
        struct bigint bi1, bi2, result;
        set_bigint("1234567890", &bi1);
        set_bigint("9876543210", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "11111111100");
    }

    TEST_CASE("Add ten digit: 5555555555 + 4444444444") {
        struct bigint bi1, bi2, result;
        set_bigint("5555555555", &bi1);
        set_bigint("4444444444", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "9999999999");
    }

    /* Different length tests - first argument shorter */
    TEST_CASE("Add different lengths (first shorter): 123 + 456789") {
        struct bigint bi1, bi2, result;
        set_bigint("123", &bi1);
        set_bigint("456789", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "456912");
    }

    TEST_CASE("Add different lengths (first shorter): 5 + 12345") {
        struct bigint bi1, bi2, result;
        set_bigint("5", &bi1);
        set_bigint("12345", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "12350");
    }

    TEST_CASE("Add different lengths (first shorter): 99 + 8888888") {
        struct bigint bi1, bi2, result;
        set_bigint("99", &bi1);
        set_bigint("8888888", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "8888987");
    }

    /* Different length tests - second argument shorter */
    TEST_CASE("Add different lengths (second shorter): 456789 + 123") {
        struct bigint bi1, bi2, result;
        set_bigint("456789", &bi1);
        set_bigint("123", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "456912");
    }

    TEST_CASE("Add different lengths (second shorter): 12345 + 5") {
        struct bigint bi1, bi2, result;
        set_bigint("12345", &bi1);
        set_bigint("5", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "12350");
    }

    TEST_CASE("Add different lengths (second shorter): 8888888 + 99") {
        struct bigint bi1, bi2, result;
        set_bigint("8888888", &bi1);
        set_bigint("99", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "8888987");
    }

    /* Edge cases with carries */
    TEST_CASE("Add with multiple carries: 9999 + 1") {
        struct bigint bi1, bi2, result;
        set_bigint("9999", &bi1);
        set_bigint("1", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "10000");
    }

    TEST_CASE("Original test: 1234567 + 8888888") {
        struct bigint bi1, bi2, result;
        set_bigint("1234567", &bi1);
        set_bigint("8888888", &bi2);
        add_bigints(&bi1, &bi2, &result);
        ASSERT_STR(get_bigint(result), "10123455");
    }

    END_TESTING();
}


