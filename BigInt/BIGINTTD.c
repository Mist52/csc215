#include "BIGINT.H"
#include "BDSCTEST.H"

main() {
    START_TESTING("BIGINTTD.C");

    TEST_CASE("Read and write bigint 1234567") {
        struct bigint bi;
        set_bigint("1234567", &bi);
        ASSERT_STR(get_bigint(bi), "1234567");
    }
TEST_CASE("Adding bigints") {
    struct BigInt bi1;
    struct BigInt bi2;
    struct BigInt biout;
    char buffer3[256];
    char buffer4[256];
    char buffer5[256];
    char buffer6[256];
    char* temp2;
}
    END_TESTING();
}
