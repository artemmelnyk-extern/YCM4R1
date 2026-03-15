# wireless-regdb_%.bbappend
# Ensure the wireless regulatory database is installed so that the BCM43455
# chipset operates in a legal frequency range.
# This append simply pulls in the crda run-time and the regulatory database.

RDEPENDS_${BPN} += "crda"
