# wireless-regdb_%.bbappend
# Ensure the wireless regulatory database is installed so that the BCM43455
# chipset operates in a legal frequency range.
# This append simply pulls in the crda run-time and the regulatory database.

# crda is deprecated with kernel 5.15+; the in-kernel regulatory database
# is used instead.  Keep wireless-regdb as a run-time recommendation.
RRECOMMENDS:${PN} += "wireless-regdb"
